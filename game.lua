--[[ Stats
 - Money: based on sales
 - Stars: based on quantity of good customer experience, which is based on: food variety, cat exposure, speed of being helped
 - Cat Capacity: based on furniture and toys etc
 - Max Furniture Pieces: based on floorplan
 - Customer Capacity: based on tables + chairs
 - Restock stats: Beans, Ingredients, Cat Food
]]


--[[ TODO
 - Scrolling
 - Stat page
 - Make buying stuff use stats etc.
 - Counters
 - Customers use chairs
 - Make appliances

]]

BILLS = {1, 5, 10, 20}

function play_activity() return {name = "play"} end
function moving_activity(ent) return {name = "moving", ent = ent, drop_valid=true} end
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
                {img = 36, title = "table", type = "buy_floor", price = 50},
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
                {img = 52, title = "espresso", type = "buy_counter", price = 100, menu = "espresso"},
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

state_game = {}
state_game.start = function()
    cafe_size = {6,5}
    ents = {}

    make_floor_item("table",36, 11, 11)
    make_floor_item("chair",{27,28,29}, 41, 11)
    -- opt: string setup
    make_ent(47, 0, 35)
    make_ent(48, 12, 35)
    make_ent(49, 25, 35)
    make_ent(50, 36, 35)
    make_ent(51, 48, 35)
    register = make_ent(53, 27, 30, 8)
    register.interactable = true
    register.interact = function(self)
        if #customer_queue > 0 then
            activity = register_activity(customer_queue[1])
        else
        end
    end
    door = make_ent(35, 26, -13)
    make_blocker(door.x - 6, door.y + 7, 10, register.y - door.y)

    player = make_player(31, 8)

    money = 25
    selected_ent = nil

    activity = play_activity()
    stats = {max_cats = 1.9}
    stock = {beans = 100, pastries = 0, ingredients = 0, catfood = 100}

    init_customers()
    time = 0
    daytime = 0
end

state_game.update = function()
    time += 0x0.0001
    daytime += 1
    update_customers()
    if activity.name == "play" then
        player:control()
        if btnp(B_BACK) then
            activity = phone_activity()
        end
    elseif activity.name == "moving" then
        local e = activity.ent
        e:try_move( (tonum(btnp(1)) - tonum(btnp(0))) * 2 , (tonum(btnp(3)) - tonum(btnp(2))) * 2 )

        activity.drop_valid = true
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
        end        
    end
    for ent in all(ents) do
        ent:update()
    end
end