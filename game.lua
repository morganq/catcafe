--[[

Goal: Get to 9x7


-- 7644

]]

--[[ Feedback

 - need cheap stuff to decorate
   - plants
   - token space for rugs?
   - hanging light???
   - couch (sectional?)
   - shelving with cute stuff
   - window seating
   - bar/counter seating?
   - place for cream etc
   - elevated area with stairs
   - long table

 - didn't know how stars were acquired via cats
  * gain star at the moment they interact with the cat
 - need clear goal
 - no time to do other things when making change all the time
 - no other gameplay but making change is tiring
    1. treats for cats - moves them around, but maybe not mechanically clear?
    2. play with cat - ?
    3. talk to customer to get tip? - odd feeling
 - overpriced expansions
 - 

]]


--[[ TODO
 - Make buying stuff use stats etc.
 - Customers use chairs
 - Make appliances

]]

for os in all(OBJECT_SPRITES) do
    for k,v in pairs(os) do
        local t = {}
        local parts = split(v, "|")
        for part in all(parts) do
            add(t, make_spritepart(unpack(split(part,"/"))))
        end
        OBJECT_SPRITES[k] = t
    end
end

BILLS = {1, 5, 10, 20}

function action_buy_grinder() prices["drip coffee"] = 3 end

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
    cats_menu = {}
    for cat in all(cats_available) do
        add(cats_menu, {img=cat.portrait, img_pal=cat.pal, title=cat.name, type="adopt_cat", features = cat})
    end
    return {name = "phone", tree = {scroll_page = 8, children = {
            {img = 55, title = "info", scroll_page = 8, children = {}},
            {img = 56, title = "furniture", scroll_page = 4, children = string_multitable([[
img=27,title=chair,type=buy_floor,sprite=chair,price=20,description=always good to have more seating
img=110,title=chair2,type=buy_floor,sprite=chair2,price=30
img=103,title=couch 1,type=buy_floor,sprite=couch1,price=25,description=left side sectional
img=104,title=couch 2,type=buy_floor,sprite=couch2,price=25,description=center sectional
img=105,title=couch 3,type=buy_floor,sprite=couch3,price=25,description=right side sectional
img=36,title=table,type=buy_floor,sprite=table,price=40,stat=appeal,stat_value=0.5,description=customers usually expect tables
img=107,title=table2,type=buy_floor,sprite=table2,price=40,stat=appeal,stat_value=0.5,description=customers usually expect tables
img=30,title=bookshelf,type=buy_floor,sprite=bookshelf,price=60,stat=max_cats,stat_value=0.25,description=cats might like to climb it
img=100,title=counter,type=buy_floor,sprite=cabinet,price=60,is_counter=true,description=can fit appliances or serve as decoration
img=106,title=plant,type=buy_floor,sprite=plant1,price=10,description=plant,stat=appeal,stat_value=0.1,hoppable=false
]])},
            {img = 57, title = "appliances", scroll_page = 4, children = string_multitable([[
img=53,title=register,type=buy_counter,price=100,sprite=register
img=84,title=drip machine,type=buy_counter,price=50,sprite=drip machine
img=86,title=grinder,type=buy_counter,price=50,sprite=grinder,fn=action_buy_grinder,description=raises drip coffee price +$1
img=97,title=pastries,type=buy_counter,price=50,sprite=pastries,menu=sweet pastry/savory pastry,description=adds pastries to the menu
img=52,title=espresso,type=buy_counter,price=500,sprite=espresso,stat=appeal,stat_value=0.5,menu=espresso,description=adds espresso to the menu
img=85,title=frother,type=buy_counter,price=150,sprite=frother,stat=appeal,stat_value=1.0,menu=cappuccino/latte,requires=espresso,description=adds espresso milk drinks to the menu
]])},
            --{img = 58, title = "restock", scroll_page = 8, children = {}},
            {img = 60, title = "floorplan", scroll_page = 4, children = string_multitable([[
img=58,title=6x6 cafe,price=200,type=floorplan,planx=6,plany=6
img=58,title=7x6 cafe,price=600,type=floorplan,planx=7,plany=6
img=58,title=7x7 cafe,price=1100,type=floorplan,planx=7,plany=7
img=58,title=8x7 cafe,price=2000,type=floorplan,planx=8,plany=7
img=58,title=9x7 cafe,price=5000,type=floorplan,planx=9,plany=7
            ]])},
            {img = 59, title = "adopt!", scroll_page = 4, children = cats_menu},
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

prices = {["drip coffee"] = 2, espresso = 4, latte = 5, cappuccino = 5, ["sweet pastry"] = 4, ["savory pastry"] = 5}
function get_menu()
    local menu = { "drip coffee" }
    for ent in all(ents) do
        if ent.menu then
            for item in all(ent.menu) do
                add(menu, item)
            end
        end
    end
    return menu
end

function get_seats(must_be_empty)
    local s = {}
    local chairs = split"chair,couch1,couch2,couch3"
    for ent in all(ents) do
        if contains(chairs, ent.name) then
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

function get_sitting_spots()
    local sits = {}
    for c in all(get_counters(true)) do add(sits, c) end
    for c in all(get_seats(true)) do add(sits, c) end
    return sits
end

function has_ent(name)
    for ent in all(ents) do if ent.name == name then return true end end
    return false
end

function get_max_cats()
    local n = sqrt(stars) / 3.17
    return stats["max_cats"] + n
end

state_game = {}
state_game.start = function()
    cafe_size = {6,5}
    ents = {}
    cats_available = {}
    local nums = {}
    for i = 1, 100 do add(nums, i) end
    for i = 1, 16 do
        local ni = rnd(#nums) \ 1 + 1
        local num = nums[ni]
        deli(nums, ni)
        add(cats_available, generate_cat_features(num))
    end
    
    description_t = 0

    make_floor_item("table",OBJECT_SPRITES["table"], 51, 16)
    make_floor_item("chair",OBJECT_SPRITES["chair"], 52, 6)
    make_floor_item("bookcase",30, 12, 6)
    -- opt: string setup
    local rc1 = make_counter(47, 6, 44)
    --flap = make_ent(48, 18, 44)
    local rc2 = make_counter(49, 30, 44)
    make_counter(50, 43, 44)
    make_counter(51, 54, 45)
    make_counter(75, 54, 55)

    drip = make_counter_item("drip machine",84, 2, 34, 1)
    drip.height = rc1.counter_height
    rc1.counter_item = drip 
    drip:move(rc1.x, rc1.y)

    register = make_counter_item("register",53, 27, 34, 1)
    register.height = rc2.counter_height
    register.interactable = true
    register.interact = function(self)
        if #customer_queue > 0 then
            activity = register_activity(customer_queue[1])
        else
        end
    end
    rc2.counter_item = register
    register:move(rc2.x, rc2.y)


    day_num = 1
    door = make_ent(35, 31, -5)
    --blocker = make_blocker(door.x - 10, door.y + 4, 10, register.y - door.y - 6)

    player = make_player(31, 8)

    money = 550
    stars = 0
    selected_ent = nil

    activity = play_activity()
    stats = {max_cats = 1.0, appeal = 1.5}
    stock = {beans = 100, pastries = 0, ingredients = 0, catfood = 100}

    init_customers()
    cats = {}

    time = 0
    daytime = 0
    hints = {}
    closing_time = 13
    closing_ticks = 600 * (closing_time - 7)
    cafe_open = false
    bump_money = 0
    bump_stars = 0
    bump_change = 0
    particle_stars = {}
    today_stats = string_table("customers=0,stars earned=0,sales=0,tips=0,total=0")
    today_stats_order = split("customers,stars earned,sales,tips,total")
end

function hint(s)
    hints[1] = {text=s, time=0}
end

function add_star(x, y)
    --stars += n
    --bump_stars = 10
    add(particle_stars, {x=x + rnd(4) - 2, y=y + rnd(4) - 2, time=time})
    today_stats["stars earned"] += 1
end
function add_money(n)
    money += n
    bump_money = 10
end

function end_day()
    reporthints = split("hint: customers\ngive you a star for\neach cat they meet,hint: appliances\ncan expand your\nmenu and earn you\nmore money,hint: buying\nfurniture will\nattract more\ncustomers,hint: customers\nare more likely to\ntip if they meet\nsome cats")
    time = 0
    daytime = 0
    for i = 1, 400 do
        --fillp(0b1111000011110000.1)
        --fillp(0b1100100100110110.1)
        fillp(0b0.1 + (0b1111111111111110 << (i)))
        rectfill(0,0,127,127,1)
        fillp()
        if i > 16 then
            rectfill(23, 7, 104, 120, 1)
            rectfill(24, 8, 103, 119, 7)
            center_print("day " .. day_num .. " report", 64, 11, 1)
            line(30, 19, 97, 19, 1)
            for j = 1, #today_stats_order do
                local s = today_stats_order[j]
                if i > j * 30 + 15 then
                    print(s, 27, 24 + j * 11, 1)
                end
                if i > j * 30 + 25 then
                    local v = (j > 2 and "$" or "") .. today_stats[s]
                    print(v, 100 - print(v, 0, -100), 24 + j * 11, 0)
                end
            end
            if i > 200 then
                if reporthints[day_num] then
                    print(reporthints[day_num], 27, 94, 1)
                end
            end
        end
        flip()
    end
    day_num += 1
    today_stats = string_table("customers=0,stars earned=0,sales=0,tips=0,total=0")
    cafe_open = false
end

state_game.update = function()
    
    door.interactable = false
    time += 0x0.0001
    if not cafe_open then
        if time > 0x0.0080 and daytime == 0 then
            door.outline_color = (time % 0x0.002 < 0x0.001) and 10 or nil
        end
        door.interactable = true
        if daytime == 0 then
            door.interact_text = "open cafe"
            door.interact = function(self) cafe_open = true end
        else
            door.interact_text = "go home"
            door.interact = function(self) end_day() end
        end
    end

    if daytime > 10 then
        --end_day()
    end

    if cafe_open and activity.name != "phone" then
        
        daytime += 1
        if daytime >= closing_ticks then
            cafe_open = false
        end
        update_customers()        
    end
    if activity.name != "phone" then
        update_cats()
        for ent in all(ents) do
            ent:update()
        end        
    end

    if #hints > 0 then
        hints[1].time += 1
        if hints[1].time > 150 then
            deli(hints,1)
        end
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
            activity.selected_counter = (activity.selected_counter + dx + dy - 1) % #counters + 1
            local c = counters[activity.selected_counter]
            e:move( c.x, c.y )
            e.height = c.counter_height
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
        if dy != 0 then description_t = 0 end
        cursor[#cursor] = mid(selected + dy, 1, #tree.children)
        if btnp(B_CONFIRM) then
            local item = tree.children[selected]
            if item.children then
                add(cursor, 1)
                activity.scroll = 0
            elseif item.type == "floorplan" then
                if item.price <= money then
                    money -= item.price
                    local dx, dy = item.planx - cafe_size[1], item.plany - cafe_size[2]
                    for c in all(get_counters()) do
                        c:move(c.x, c.y + dy * 12)
                        if c.counter_item then
                            c.counter_item:move(c.counter_item.x, c.counter_item.y + dy * 12)
                        end
                    end
                    --flap:move(flap.x, flap.y + dy * 12)
                    --blocker.y += dy * 12

                    activity = play_activity()
                    cafe_size = {item.planx, item.plany}
                else
                    hint("not enough money")
                end                
            elseif item.type == "buy_floor" then
                if item.price <= money then
                    money -= item.price
                    local e
                    if item.is_counter then
                        e = make_counter(OBJECT_SPRITES[item.sprite], 25, 0, true)
                    else
                        e = make_floor_item(item.title, OBJECT_SPRITES[item.sprite], 25, 0)
                    end
                    if item.stat then
                        stats[item.stat] += item.stat_value
                    end
                    e.hoppable = item.hoppable or true
                    activity = moving_activity(e)
                else
                    hint("not enough money")
                end
            elseif item.type == "buy_counter" then
                if #get_counters(true) == 0 then
                    hint("no counter space")
                elseif has_ent(item.title) then
                    hint("already owned")
                elseif item.requires and not has_ent(item.requires) then
                    hint(item.title .. " requires " .. item.requires)
                else
                    if item.price <= money then
                        money -= item.price
                        local e = make_counter_item(item.title, OBJECT_SPRITES[item.sprite], 25, 0)
                        e.menu = split(item.menu,"/")
                        if item.fn then _ENV[item.fn]() end
                        activity = moving_activity(e, true)
                    else
                        hint("not enough money")
                    end
                end
            elseif item.type == "adopt_cat" then
                if has_ent(item.title) then
                    hint("already adopted " .. item.title .. "!")
                elseif #cats >= get_max_cats()\1 then
                    hint("reached maximum cats")
                else
                    add(cats, make_cat(item.features.index, door.x - 3, door.y + 8))
                    stats["appeal"] += 0.5
                    activity = play_activity()
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
            bump_change = 4
        end
        if activity.change == 0 then
            add_money(activity.sale)
            
            local tip = 0
            if activity.customer.order.tip then
                tip = activity.customer.order.tip
            end
            today_stats["sales"] += activity.sale - tip
            today_stats["tips"] += tip
            today_stats["total"] += activity.sale
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