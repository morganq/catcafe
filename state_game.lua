--[[ Stats
 - Money: based on sales
 - Stars: based on quantity of good customer experience, which is based on: food variety, cat exposure, speed of being helped
 - Cat Capacity: based on furniture and toys etc
 - Max Furniture Pieces: based on floorplan
 - Customer Capacity: based on tables + chairs
 - Restock stats: Beans, Ingredients, Cat Food
]]

BILLS = {1, 5, 10, 20}

function play_activity() return {name = "play"} end
function moving_activity(ent) return {name = "moving", ent = ent} end
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
    return {name = "phone", tree = {scrolling = 8, children = {
            {img = 55, title = "stats", scrolling=8, children = {}},
            {img = 56, title = "furniture", scrolling=4.5, children = {
                {img = 27, title = "chair", type = "buy", price = 20, params = {27}},
                {img = 36, title = "table", type = "buy", price = 50, params = {36}},
                {img = 30, title = "bookshelf", type = "buy", price = 100, params = {30}},
                {img = 61, title = "rug 2x2", type = "buy", price = 100, params = {61}},
                {img = 61, title = "rug 3x2", type = "buy", price = 100, params = {61}},
                {img = 61, title = "rug 3x3", type = "buy", price = 100, params = {61}},
                {img = 61, title = "rug 4x3", type = "buy", price = 100, params = {61}},
            }},
            {img = 57, title = "appliances", scrolling=4, children = {
                {img = 53, title = "register", type = "buy", price = 0},
                {img = 52, title = "espresso", type = "buy", price = 100, params = {"espresso"}},
            }},        
            {img = 58, title = "restock", scrolling=8, children = {}},
            {img = 60, title = "floorplan", scrolling=8, children = {

            }},
            {img = 59, title = "adopt!", scrolling=4, children = {}},
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

state_game = {}
state_game.start = function()
    cafe_size = {6,5}
    ents = {}

    make_floor_item(36, 11, 11)
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
    door = make_ent(35, 25, -13)
    --make_ent(52, 38, 28, 8)

    player = make_player(31, 8)

    money = 500
    selected_ent = nil

    activity = play_activity()
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
        activity.ent:try_move( (tonum(btnp(1)) - tonum(btnp(0))) * 2 , (tonum(btnp(3)) - tonum(btnp(2))) * 2 )
        if btnp(B_CONFIRM) then
            activity = play_activity()
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
            elseif item.type == "buy" then
                -- check for num furniture etc
                if item.price <= money then
                    money -= item.price
                    local e = make_floor_item(item.params[1], 25, 0)
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

state_game.draw = function()
    cls(7)

    for i = 0, 5 do
        for j = 0, 5 do
            local x = j * 26 + 3 + (i % 2 ) * 8
            local y = i * 30 + 3 + j * 2
            local angle = i * 1.3103 + j * 0.73
            draw_paw(x, y, angle, sin(i / 7) * 2.65 + 9.5, 7, 6)
        end
    end

    -- World camera
    local csx, csy = cafe_size[1], cafe_size[2]
    local cspx, cspy = csx * 12, csy * 12
    local cx, cy = (cspx - 128) \ 2, (cspy - 128) \ 2 - 8
    camera(cx, cy)

    rect(-1, -17, cspx + 1, cspy + 1, 2)
    rect(-2, -18, cspx + 2, cspy + 2, 4)
    rect(-3, -19, cspx + 3, cspy + 3, 2)

    for fx = 0, cafe_size[1] - 1 do
        for fy = 0, cafe_size[2] - 1 do
            spr(31, fx * 12, fy * 12)
        end
        spr(34, fx * 12, -16)
    end
    spr(33, -1, -16)
    spr(33, cspx - 1, -16)

    spr(32, 5, -14)
    spr(32, 13, -14)
    spr(32, 39, -14)
    spr(32, 47, -14)
    spr(32, 55, -14)
    spr(37, 41, -10)
    spr(38, 49, -12)
    spr(39, 57, -11)

    if activity and activity.name == "moving" then
        fillp(0b0101111101011111.1)
--[[        for x = 0, cspx, 4 do
            line(x, 0, x, cspy, 3)
        end
        for y = 0, cspy, 4 do
            line(0, y, cspx, y, 3)
        end]]
        local x1, x2, y1, y2 = activity.ent:get_rect()
        clip(-cx, -cy, cspx, cspy)
        rectfill(x1 - 6, y1 - 8, x2 + 6, y2 + 8, 15)
        rectfill(x1 - 8, y1 - 6, x2 + 8, y2 + 6, 15)
        rectfill(x1 - 4, y1 - 4, x2 + 4, y2 + 4, 7)
        clip()
        fillp()
    end

    draw_ents()

    -- UI camera
    camera()
    if activity.name == "phone" then
        rectfill(41,14,88,113, 1)
        rectfill(36,19,93,108, 1)

        -- todo: screen lights up and loads
        rectfill(38,16,91,111, 7)
        spr(54, 36, 14)
        spr(54, 89, 14, true)
        spr(54, 36, 109, false, true)
        spr(54, 89, 109, true, true)

        local tree, selected = get_phone_state()
        camera(-38, -18 + selected \ tree.scrolling * 64)
        clip(38, 18, 54, 92)
        local y = 3
        if tree.title then
            center_print(tree.title, 26, 0, 0)
            y = 12
        end
        for i = 1, #tree.children do
            local child = tree.children[i]
            local meta = SPRITE_META[ child.img ]
            local th = 5
            if child.type == "buy" then
                th = 13
            else
            end
            --spr(child.img, 1, y)
            local x1, y1, w, h, dx, dy = meta[1], meta[2], meta[3], meta[4], 1, y
            if w < 10 then
                dx += (10 - w) \ 2
            else
                --x1 += (w - 10) \ 2
                w = 10
            end
            if h < th then
                dy += (th - h) \ 2
            else
                y1 += (h - th) \ 2
                h = th
            end            
            if selected == i then
                rectfill(0, y - 2, 53, y + h + 1, 10)
            end            
            sspr(x1, y1, w, h, dx, dy)
            print(child.title, 13, y, 0)
            if child.type == "buy" then
                print("$" .. child.price, 13, y + 7, child.price > money and 8 or 0)
            end
            y += h + 5
        end
        clip()
        camera()
    elseif activity.name == "register" then
        local o = 0
        if #activity.bills > 5 then o = 2 end        
        for i = 1, #activity.bills do
            draw_cash(activity.bills[i], 72 + i * (5 - o), 65)
        end

        local order = activity.customer.order
        local ty = 76 - 7 * #order
        rect(1, ty, 61, 80, 6)
        rectfill(2, ty, 60, 80, 7)
        for i = 0, 6 do
            spr(70, 1 + 9 * i, ty - 3)
        end
        y = 72
        for item in all(order) do
            print(item[1], 4, y, 5)
            print(item[2], 58 - print(item[2],0,-100), y, 1)
            y -= 7
        end

        rectfill(0, 80, 127, 127, 6)
        line(0, 80, 127, 80, 1)
        rect(-1,87,43,119,5)
        rectfill(43, 81, 127,123,5)
        rect(43, 81, 127,123,1)
        
        for i = 1, 4 do
            draw_cash(BILLS[i], 24 + i * 21, 85, activity.selected_bill == i)
        end

        rectfill(0,88,42,118,7)
        print("sale", 10, 91, 1)
        local sale, given, change = activity.sale, "+" .. activity.given, activity.change
        print(sale, 43 - print(sale, 0, -100), 91, 1)
        print(given, 43 - print(given, 0, -100), 99, 3)

        rectfill(0, 107, 42, 115, 10)
        print("change", 2, 109, 1)
        print(change, 43 - print(change, 0, -100), 109, 8)
    end
    spr(44, 0, 3, false, false, 26)
    spr(43, 26, 3)
    spr(45, 2, 5)
    print(money, 9, 6, 1)

    spr(44, 102, 3, false, false, 26)
    spr(43, 100, 3, true)
    spr(46, 120, 5)
    print("4.9", 105, 6, 1)    

    -- 12 hours = 4 minutes
    local minutes = ((daytime \ 50) * 5) % 60
    local hours = 7 + daytime \ 600
    time_str = ((hours < 13) and hours or hours - 12) .. ":" .. ((minutes < 10) and "0" or "") .. minutes .. (hours < 12 and " am" or " pm")
    center_print(time_str, 64, 6, 0)
    
end