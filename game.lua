--poke(0x5F2D, 0x1) -- mouse

--[[

-- floor plan star requirements??
-- background
-- check if tip is fixed


Goal: Get to 9x7

]]



-- Is it diagonal?
if abs(dx) != 0 and abs(dy) != 0 then
    -- Get the subpixel position
    xmod = x % 1
    ymod = y % 1
    
    -- Set up the line to project onto, based on if this is the up-left diagonal or the up-right diagonal
    local diagonal = {.707, -.707}
    if sgn(dx) == sgn(dy) then
        diagonal = {.707, .707}
    end
    -- Use dot product to project the position onto the diagonal line.
    local dot_product = xmod * diagonal[1] + ymod * diagonal[2]
    xmod = dot_product * diagonal[1]
    ymod = dot_product * diagonal[2]

    -- Adjust the actual position
    x = x \ 1 + xmod
    y = y \ 1 + ymod
end


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

 - need clear goal

]]


--[[ TODO
 - auto register?
 - make a plan for tutorialization
 - teach:
  - you own this cafe and you gotta make it a success
  - it's a cat cafe - adopt a cat!
  - use your phone to get furniture and appliances
  - check the stats and try to improve your cafe
  - you can interact with cats too
]]

BILLS = {1, 5, 10, 20}

function play_activity() return {name = "play"} end
function moving_activity(ent) return {name = "moving", ent = ent, drop_valid=true} end
function register_activity(customer)
    return {
        name = "register",
        customer = customer,
        selected_bill = 1,
        given=customer.given,
        change=customer.given - customer.sale,
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
            {img = 56, title = "furniture", scroll_page = 4, children = get_buyables("1,2,3,4,5,6,7,8,9")},
            {img = 57, title = "appliances", scroll_page = 4, children = get_buyables("11,12,13,14,15,16,17,18")},
            {img = 128, title = "decor", scroll_page = 4, children = get_buyables("10")},
            {img = 60, title = "floorplan", scroll_page = 4, children = string_multitable([[
img=58,title=6x6 cafe,price=150,type=floorplan,planx=6,plany=6,stars=10
img=58,title=7x6 cafe,price=600,type=floorplan,planx=7,plany=6,stars=50
img=58,title=7x7 cafe,price=1100,type=floorplan,planx=7,plany=7,stars=100
img=58,title=8x7 cafe,price=2000,type=floorplan,planx=8,plany=7,stars=200
img=58,title=9x7 cafe,price=5000,type=floorplan,planx=9,plany=7,stars=500
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

function ent_map(fn)
    local o = {}
    for ent in all(ents) do
        fn(o, ent)
    end
    return o
end

function get_menu()
    return ent_map(function(o, ent)
        for item in all(split(ent.menu,"/")) do
            add(o, item)
        end        
    end)
end

function get_seats(must_be_empty)
    local chairs = split"chair,couch 1,couch 2,couch 3,chair2"
    return ent_map(function(o, ent)
        if contains(chairs, ent.name) and (not must_be_empty or not ent.taken) then
            add(o,ent)
        end        
    end)
end

function get_counters(unoccupied)
    return ent_map(function(o, ent)
        if ent.is_counter then
            add(o,ent)
        end        
    end)
end

function get_sitting_spots()
    local sits = {}
    for c in all(get_counters(true)) do add(sits, c) end
    for c in all(get_seats(true)) do add(sits, c) end
    return sits
end

function is_ent_in_sell_spot(ent)
    if ent.cost == nil then return false end
    local r = ent:get_rect()
    return r[2] > door.x - 4 and r[1] < door.x + 4 and r[3] <= door.y + 5
end

function has_ent(name)
    for ent in all(ents) do if ent.name == name then return true end end
    return false
end

function get_max_cats()
    local n = sqrt(stars) / 3.17
    --return 7
    return min(stats["max_cats"] + n, 7)
end


_init = function()
    menuitem(2 | 0x300,"delete save data", function()
        menuitem(2 | 0x300, "really?", function()
            memset(0x5e00,0,0xff)
            run()
        end)
        return true
    end)
    cafe_size = {6,5}
    ents = {}
    description_t = 0
    autoreg_time = 0
    autoreg = false
    door = make_ent("door", OBJECT_SPRITES["door"], 31, -5)
    stats = {max_cats = 1.0, appeal = 1.5}
    player = make_player(31, 18)

    money = 50
    stars = 0

    cats = {}

    load_game()
    if day_num == 0 then
sfn([[
acquire_buyable,13,07,44
acquire_buyable,11,31,44
acquire_buyable,9,19,44
acquire_buyable,6,57,14
acquire_buyable,1,57,6
]])        
        day_num = 1
        seed = rnd()
    end    
    srand(seed)

    cats_available = {}
    local nums = {}
    while #cats_available < 16 do
        local n = rnd(100) \ 1 + 1
        if nums[n] == nil then
            nums[n] = true
            add(cats_available, generate_cat_features(n))
        end
    end

    selected_ent = nil

    activity = play_activity()
    init_customers()
    

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

function acquire_buyable(i, x, y, rotn)
    local item = buyables[i]
    local e = make_ent(item.title, OBJECT_SPRITES[item.sprite], x or door.x, y or (door.y + 11), "moveable=true")
    e.dir = ({{0,1}, {1,0}, {0,-1}, {-1, 0}})[rotn or 1]
    if item.stat then
        stats[item.stat] += item.stat_value
    end
    for k,v in pairs(item) do
        e[k] = v
    end
    
    e.cost = item.price

    if e.ind == 11 then
        e.interact = function(self)
            if #customer_queue > 0 then
                activity = register_activity(customer_queue[1])
            else
            end
        end
        register = e
    end
    if e.ind == 15 then
        prices["drip coffee"] = 3 
    end

    return e
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

function install_autoreg()
    autoreg = true
    register:set_spritepart(127,127,127,2)
    register.interact = nil
    activity = play_activity()
end

function complete_change()
    local c = customer_queue[1]
    autoreg_time = 0
    add_money(c.sale)
            
    local tip = 0
    if c.order.tip then
        tip = c.order.tip
    end
    today_stats["sales"] += c.sale - tip
    today_stats["tips"] += tip
    today_stats["total"] += c.sale
    c:set_state("paid")
    next_customer()
    activity = play_activity()    
end

function determine_tip()
    local c = customer_queue[1]
    local o = c.order
    if o.calced_tip == nil then
        local tip_chance = 0
        local cs = #c.cats_seen
        if cs > 0 then
            tip_chance = 1 / max(5 - cs / 2, 3)
            super_tip_chance = 0
            if cs > 4 then
                super_tip_chance = 1 / mid(7 - (cs - 4), 3, 7)
            end
        end
        local tip_amt = 0
        if rnd() < tip_chance then
            local is_super_tip = rnd() < super_tip_chance
            tip_amt = is_super_tip and c.sale * 3 or c.sale
            c.sale += tip_amt
            o.tip = tip_amt
            add(o, {"tip", tip_amt, is_super_tip})
        end

        local rn = rnd()
        local sale = c.sale - 0.5
        local bill = 100
        if rn < 0.1 then
            bill = 5
        elseif rn < 0.3 then
            bill = 10
        elseif rn < 0.8 then
            bill = 20
        elseif rn < 0.9 then
            bill = 50
        end
        c.given = (sale \ bill + 1) * bill

        if(activity.name == "register") then
            activity.given = c.given
            activity.change = c.given - c.sale
            printh("sale: " .. c.sale .. " given: " .. c.given .. " change: " .. activity.change)
        end
        o.calced_tip = true
    end
end

function end_day()
    reporthints = split("hint: customers\ngive you a star for\neach cat they meet,hint: appliances\ncan expand your\nmenu and earn you\nmore money,hint: customers\nare more likely to\ntip if they meet\nmany cats,hint: buying\nfurniture will\nattract more\ncustomers")
    time = 0
    daytime = 0
    for i = 1, 400 do
        --fillp(0b1111000011110000.1)
        --fillp(0b1100100100110110.1)
        fillp(0b0.1 + (0b1111111111111110 << i))
        rectfill(0,0,127,127,1)
        fillp()
        if i > 16 then
            sfn([[
rectfill,23,7,104,120,1
rectfill,24,8,103,119,7                
line,30,19,97,19,1
]])
            center_print("day " .. day_num .. " report", 64, 11, 1)
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
    save_game()
end

_update = function()
    time = (time + 1) % 32767
    if not cafe_open then
        if daytime == 0 then
            door.interact_text = "open cafe"
            door.interact = function(self)
                if #cats == 0 then
                    hint("adopt a cat first!")
                    return
                end
                save_game()
                cafe_open = true
                time = 30
                door.interact_text = nil
                door.interact = nil
                init_customers()
            end
        else
            door.interact_text = "go home"
            door.interact = function(self)
                end_day()
            end
        end
    end

    
    --if daytime > 10 then
    --    end_day()
    --end
    
    if activity.name != "phone" then
        if cafe_open then
            daytime += 1
            if daytime >= closing_ticks then
                cafe_open = false
            end
            update_customers()                    
        end
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

    if activity.name != register and #customer_queue > 0 and autoreg then
        autoreg_time += 1
        if autoreg_time == 140 then
            register:set_spritepart(132,132,132,2)
        end
        if autoreg_time > 150 then
            register:set_spritepart(127,127,127,2)
            determine_tip()
            complete_change()
        end
    end

    activity_updates()
end