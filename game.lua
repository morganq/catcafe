--[[ Stats
 - Money: based on sales
 - Stars: based on quantity of good customer experience, which is based on: food variety, cat exposure, speed of being helped
 - Cat Capacity: based on furniture and toys etc
 - Max Furniture Pieces: based on floorplan
 - Customer Capacity: based on tables + chairs
 - Restock stats: Beans, Ingredients, Cat Food
]]


--[[ TODO
 - Make buying stuff use stats etc.
 - Customers use chairs
 - Make appliances

]]

BILLS = {1, 5, 10, 20}

function play_activity() return {name = "play"} end
function moving_activity(ent, counter) return {name = "moving", ent = ent, drop_valid=true, counter_only=counter, selected_counter = 1} end
function register_activity(customer)
    return {
        name = "register",
        customer = customer,
        selected_bill = 1,
        sale = customer.sale,
        given = customer.given,
        change = customer.given - customer.sale,
        bills = {}
    }
end
function phone_activity()
    return {name = "phone", tree = {scroll_page = 8, children = {
            {img = 55, title = "stats", scroll_page = 8, children = {}},
            {img = 56, title = "furniture", scroll_page = 4, children = {
                {img = 27, title = "chair", type = "buy_floor", sprite={27,28,29}, price = 20},
                {img = 36, title = "table", type = "buy_floor", price = 50, stat = "appeal", stat_value = "0.5"},
                {img = 30, title = "bookshelf", type = "buy_floor", price = 100, stat = "max_cats", stat_value = "0.25"},
                {img = 61, title = "rug 2x2", type = "buy_floor", price = 100},
                {img = 61, title = "rug 3x2", type = "buy_floor", price = 100},
                {img = 61, title = "rug 3x3", type = "buy_floor", price = 100},
                {img = 61, title = "rug 4x3", type = "buy_floor", price = 100},
                {img = 61, title = "rug 4x4", type = "buy_floor", price = 100},
                {img = 61, title = "rug 5x4", type = "buy_floor", price = 100},
                {img = 61, title = "rug 5x5", type = "buy_floor", price = 100},
                {img = 61, title = "rug 6x5", type = "buy_floor", price = 100},
                {img = 61, title = "rug 6x6", type = "buy_floor", price = 100},
                {img = 61, title = "rug 7x6", type = "buy_floor", price = 100},
            }},
            {img = 57, title = "appliances", scroll_page = 4, children = {
                {img = 53, title = "register", type = "buy_counter", price = 0},
                {img = 53, title = "grinder", type = "buy_counter", price = 100, stat = "coffee_price", stat_value = "1", description = "raises coffee price +$1"},
                {img = 52, title = "espresso", type = "buy_counter", price = 1000, menu = "espresso"},
            }},        
            {img = 58, title = "restock", scroll_page = 8, children = {}},
            {img = 60, title = "floorplan", scroll_page = 8, children = {

            }},
            {img = 59, title = "adopt!", scroll_page = 4, children = {}},
        }
    }, cursor = {1}}
end
function get_phone_state()
    local tree = activity.tree
    for i = 1, #activity.cursor - 1 do
        tree = tree.children[activity.cursor[i]]
    end
    local selected = activity.cursor[#activity.cursor]
    return tree, selected
end

prices = {["drip coffee"] = 3, espresso = 4}
function get_menu()
    local menu = { "drip coffee" }
    for ent in all(ents) do
        if ent.menu_add then add(menu, ent.menu_add) end
    end
    return menu
end

function get_seats(must_be_empty)
    local s = {}
    for ent in all(ents) do
        if ent.name == "chair" then
            if not must_be_empty or not ent.taken then
                add(s,ent)
            end
        end
    end
    return s
end

function get_counters(unoccupied)
    local c = {}
    for ent in all(ents) do
        if ent.is_counter and (not unoccupied or not ent.counter_item) then
            add(c,ent)
        end
    end
    return c
end

state_game = {}
state_game.start = function()
    cafe_size = {6,5}
    ents = {}

    make_floor_item("table",36, 11, 11)
    make_floor_item("chair",{27,28,29}, 41, 11)
    -- opt: string setup
    make_counter(47, 0, 35)
    make_ent(48, 12, 35)
    local rc = make_counter(49, 25, 35)
    make_counter(50, 36, 35)
    make_counter(51, 48, 35)
    make_counter(75, 48, 45)
    register = make_counter_item("register",53, 27, 32, 8)
    register.height = 3
    register.interactable = true
    register.interact = function(self)
        if #customer_queue > 0 then
            activity = register_activity(customer_queue[1])
        else
        end
    end
    rc.counter_item = register
    door = make_ent(35, 26, -13)
    make_blocker(door.x - 6, door.y + 7, 10, register.y - door.y)

    player = make_player(31, 8)

    money = 25
    selected_ent = nil

    activity = play_activity()
    stats = {max_cats = 1.0, appeal = 1.0}
    stock = {beans = 100, pastries = 0, ingredients = 0, catfood = 100}

    init_customers()
    time = 0
    daytime = 0
    hints = {}
end

function hint(s)
    for hint in all(hints) do
        if s == hint.text then
            hint.time = 0
            return
        end
    end
    add(hints, {text=s, time=0})
end

state_game.update = function()
    time += 0x0.0001
    daytime += 1
    if #hints > 0 then
        hints[1].time += 1
        if hints[1].time > 150 then
            deli(hints,1)
        end
    end
    update_customers()
    for ent in all(ents) do
        ent:update()
    end
    if activity.name == "play" then
        player:control()
        if btnp(B_BACK) then
            activity = phone_activity()
        end



    elseif activity.name == "moving" then
        local e = activity.ent
        local dx, dy = tonum(btnp(1)) - tonum(btnp(0)),tonum(btnp(3)) - tonum(btnp(2))
        activity.drop_valid = true
        if activity.counter_only then
            local counters = get_counters()
            activity.selected_counter = mid(activity.selected_counter + dx + dy, 1, #counters)
            printh(activity.selected_counter)
            local c = counters[activity.selected_counter]
            e:move( c.counter_center[1], c.counter_center[2] )
            e.height = c.counter_height + 2
            if c.counter_item then c.counter_item.imm_offset = 5 end
            if btnp(B_CONFIRM) then
                if c.counter_item then
                    local other_item = c.counter_item
                    c.counter_item = activity.ent
                    activity = moving_activity(other_item, true)
                else
                    c.counter_item = activity.ent
                    activity = play_activity()
                end
                
            end            
        else
            e:try_move( dx * 2 , dy * 2 )
            for ent in all(ents) do
                if ent != e then
                    local col = collide_ents(e, ent)
                    if col[1] != 0 or col[2] != 0 then
                        activity.drop_valid = false
                        break
                    end
                end
            end
            if btnp(B_CONFIRM) then
                if activity.drop_valid then
                    activity = play_activity()
                else
                    activity.ent:shake()
                    --hint("bad spot")
                end
            end            
        end

        if btnp(B_BACK) then
            activity.ent:rotate()
        end



    elseif activity.name == "phone" then
        local tree, selected = get_phone_state()
        local cursor = activity.cursor
        local dy = tonum(btnp(3)) - tonum(btnp(2))
        cursor[#cursor] = mid(selected + dy, 1, #tree.children)
        if btnp(B_CONFIRM) then
            local item = tree.children[selected]
            if item.children then
                add(cursor, 1)
                activity.scroll = 0
            elseif item.type == "buy_floor" then
                if item.price <= money then
                    money -= item.price
                    local e = make_floor_item(item.title, item.sprite or item.img, 25, 0)
                    activity = moving_activity(e)
                else
                    hint("not enough money")
                end
            elseif item.type == "buy_counter" then
                if #get_counters(true) == 0 then
                    hint("no counter space")
                else
                    if item.price <= money then
                        money -= item.price
                        local e = make_counter_item(item.title, item.sprite or item.img, 25, 0)
                        activity = moving_activity(e, true)
                    else
                        hint("not enough money")
                    end
                end
            end
        end
        if btnp(B_BACK) then
            if #cursor == 1 then
                activity = play_activity()
            else
                deli(cursor, #cursor)
            end
        end       
        
        

    elseif activity.name == "register" then
        local dx = tonum(btnp(1)) - tonum(btnp(0))
        activity.selected_bill = mid(activity.selected_bill + dx, 1, 4)
        if btnp(B_CONFIRM) then
            local v = BILLS[activity.selected_bill]
            add(activity.bills, v)
            activity.change -= v
        end
        if activity.change == 0 then
            money += activity.sale
            activity.customer:set_state("paid")
            next_customer()
            activity = play_activity()
        elseif activity.change < 0 or #activity.bills > 10 then
            activity.change = activity.given - activity.sale
            activity.bills = {}
            hint("wrong change")
        end        
        if btnp(B_BACK) then
            activity = play_activity()
        end        
    end
end