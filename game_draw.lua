--1441 tokens
state_game.draw = function()
    local controls = {}
    local description = nil
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
    camx, camy = cx,cy

    rect(-1, -17, cspx + 1, cspy + 1, 2)
    rect(-2, -18, cspx + 2, cspy + 2, 4)
    rect(-3, -19, cspx + 3, cspy + 3, 2)

    for fx = 0, cafe_size[1] - 1 do
        for fy = 0, cafe_size[2] - 1 do
            zspr(31, fx * 12, fy * 12)
        end
        zspr(34, fx * 12, -16)
    end
sfn([[
zspr,33,-1,-16
zspr,32,5,-14
zspr,32,13,-14
zspr,32,39,-14
zspr,32,47,-14
zspr,32,55,-14
zspr,37,41,-10
zspr,38,49,-12
zspr,39,57,-11
]])    
    
    zspr(33, cspx - 1, -16)

    if activity.name == "moving" and not activity.counter_only then
        clip(-cx, -cy, cspx, cspy)
        fillp(0b0101111101011111.1)
        local r = activity.ent:get_rect()
        rectfill(r[1] - 4, r[3] - 4, r[2] + 5, r[4] + 5, 7)
        fillp()
        clip()
    end

    draw_ents()
    for customer in all(customers) do
        if customer.status_timer > 0 then
            center_print(customer.status, customer.x, customer.y - 15, 1, 7, nil, true)
        end        
    end

    if activity.name == "moving" then
        if activity.counter_only then
            local counters = get_counters()
            for c in all(counters) do
                local x,y = c.x, c.y
                y -= c:get_total_height()
                rect(x - 1, y - 1, x + 1, y + 1, 7)
            end
        else
            controls = {"place", "rotate"}
            --[[
            fillp(0b0101111101011111.1)
            local x1, x2, y1, y2 = activity.ent:get_rect()
            local ax1, ay1, ax2, ay2 = max(x1 - 8, 0), max(y1 - 8, 0), min(x2 + 8, cspx), min(y2 + 8, cspy)
            local bx1, by1, bx2, by2 = max(x1 - 4, 0), max(y1 - 4, 0), min(x2 + 4, cspx), min(y2 + 4, cspy)
            clip(-cx + ax1, -cy + ay1, ax2-ax1, ay2-ay1)
            rectfill(0, 0, 127, 127, 15)
            clip(-cx + bx1, -cy + by1, bx2-bx1, by2-by1)
            rectfill(0, 0, 127, 127, 7)     
            clip(-cx + ax1, -cy + ay1, ax2-ax1, ay2-ay1)   
            for ent in all(ents) do
                if ent.blocks_placement and ent != activity.ent then
                    local r = pack(ent:get_rect())
                    rectfill(r[1], r[3], r[2], r[4], 9)
                end
            end
            clip()
            fillp()
            ]]
        end
        if activity.ent.cost then
            zspr(117, door.x - 9, door.y - 12 + (time \ 0x0.0010) % 2)
        end
    end

    if activity.name == "play" then
        if selected_ent then
            controls = {"move"}
            if selected_ent.interactable then controls = {selected_ent.interact_text or "use"} end
        elseif player.nearest_cat then
            controls = {"call " .. player.nearest_cat.name}
        end
        controls[2] = "phone"
    end

    -- UI camera
    camera()
    local w = print(money,0,-100)
    zspr(44, 0, 3, false, false, w + 10)
    zspr(43, w + 10, 3)
    zspr(45, 2, 5)
    print(money, 9, 6 - bump_money \ 4, 1)
    bump_money = max(bump_money - 1, 0)

    w = print(stars,0,-100)
    zspr(44, 117 - w, 3, false, false, w + 11)
    zspr(43, 115 - w, 3, true)
    zspr(46, 120, 5)
    print(stars, 119 - w, 6 - bump_stars \ 4, 1)
    bump_stars = max(bump_stars - 1, 0)
    for p in all(particle_stars) do
        local t = (time - p.time) / 0x0.0020
        t = t ^ 3
        local px, py = (p.x - cx) * (1-t) + 120 * t, (p.y - cy) * (1-t) + 5 * t
        --print("\f9⁶:083e1c0814000000", px, py)
        zspr(46, px, py)
        if t >= 1 then
            stars += 1
            del(particle_stars, p)
        end
    end

    -- 1 hour = 20 seconds
    -- 12 hours = 4 minutes
    local minutes = ((daytime \ 50) * 5) % 60
    local hours = 7 + daytime \ 600
    time_str = ((hours < 13) and hours or hours - 12) .. ":" .. ((minutes < 10) and "0" or "") .. minutes .. (hours < 12 and " am" or " pm")
    center_print(cafe_open and "open" or "closed", 64, 2, cafe_open and 0 or 8)
    if not cafe_open then
        if daytime == 0 then time_str = "6:59 am"
        else time_str = (closing_time - 12) .. ":01 pm" end
    end
    center_print(time_str, 64, 9, 0)


    if activity.name == "phone" then
        controls = {"select", "back"}
        local tree, selected = get_phone_state()
        -- todo: screen lights up and loads
        sfn([[
rectfill,41,4,88,103,1
rectfill,36,9,93,98,1
rectfill,38,6,91,101,7
zspr,54,36,4
zspr,54,89,4,1
zspr,54,36,99,,1
zspr,54,89,99,1,1
camera,-38,-8
clip,38,8,54,92
]])
        local y = 3
        local children = tree.children
        if tree.title then
            center_print(tree.title, 26, 0, 2)
            y = 12
            if tree.title == "info" then
                children = {
                    {title="max cats", value=get_max_cats(), description="collect stars to adopt more cats"},
                    {title="appeal", value=stats["appeal"], description="more appeal = more customers"},
                    {title="seats", value=#get_seats(), description="customers will stay longer if they can sit"},
                    {title="cafe menu:", color=2},
                }
                for item in all(get_menu()) do
                    add(children, {title=item})
                end
            end
            tree.children = children
        end
        local page = (selected - 1) \ tree.scroll_page + 1
        local p1 = (page - 1) * tree.scroll_page + 1
        local last_page = (#children \ tree.scroll_page)
        for i = p1, min(p1 + tree.scroll_page - 1, #children) do
            local child = children[i]
            local have_it = tree.title == "appliances" and has_ent(child.title)
            have_it = have_it or (child.type == "adopt_cat" and has_ent(child.title))
            local x = 2
            local th = 5
            if child.price or child.type == "adopt_cat" then
                th = 13
            end            
            if selected == i then
                rectfill(0, y - 2, 53, y + th + 1, have_it and 6 or 10)
                description = child.description
            end          
            local sprd = child.sspr and split(child.sspr, "/") or SPRITE_META[child.img]
            if sprd then
                local x1, y1, w, h = unpack(sprd)
                local dx, dy = 1, y
                if w < 10 then
                    dx += (10 - w) \ 2
                else
                    w = 10
                end
                if h < th then
                    dy += (th - h) \ 2
                else
                    y1 += (h - th) \ 2
                    h = th
                end                
                if child.img_pal then pal(child.img_pal) end
                sspr(x1, y1, w, h, dx, dy)
                pal()
                x += 11
            elseif child.value then
                print(child.value \ 1, x + 3, y, 0)
                for i = 0, 1, 0.025 do
                    local px, py = sin(i) * -4.3 + x + 4.5, -cos(i) * 4.3 + y + 2.5
                    pset(px, py, (i < child.value % 1) and 8 or 6)
                end
                x += 12
            else
            end
            
            print(child.title, x, y, have_it and 5 or child.color)
            if child.price then
                print("$" .. child.price, x, y + 7, have_it and 5 or (child.price > money and 8 or 0))
            end
            y += th + 5
        end
        if #children > tree.scroll_page then
            if page > 1 then
                zspr(71, 24, 7)
            end
            if page < last_page then
                zspr(71, 24, 81,false,true)
            end
            center_print(page .. "/" .. last_page, 26, 87, 0)
        end
        clip()
        camera()
    elseif activity.name == "register" then
        controls = {"pick"}
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
            zspr(70, 1 + 9 * i, ty - 3)
        end
        y = 72
        for item in all(order) do
            print(item[1], 4, y, 5)
            print(item[2], 58 - print(item[2],0,-100), y, 1)
            y -= 7
        end

        sfn([[
rectfill,0,80,127,127,6
line,0,80,127,80,1
rect,-1,87,43,118,5
rectfill,43,81,127,123,5
rect,43,81,127,123,1
rectfill,0,88,42,117,7
rectfill,0,107,42,115,10
print,sale,10,91,1
print,change,2,109,1
]])     
        for i = 1, 4 do
            draw_cash(BILLS[i], 24 + i * 21, 85, activity.selected_bill == i)
        end
        local sale, given, change = activity.sale, "+" .. activity.given, activity.change
        print(sale, 43 - print(sale, 0, -100), 91, 1)
        print(given, 43 - print(given, 0, -100), 99, 3)

        local w = print(change, 0, -100)
        if bump_change > 0 then
            rectfill(42 - w, 108, 42, 114, 11)
        end
        print(change, 43 - w, 109, (bump_change > 0) and 7 or 8)
        
    end
    bump_change = max(bump_change - 1, 0)

    
    local o = 3
    if controls[1] then
        zspr(73, 3, 120)
        o = print(controls[1], 12, 121, 0) + 8
    end
    if controls[2] then
        zspr(74, o, 120)
        print(controls[2], o + 9, 121, 0)        
    end

    if #hints > 0 then
        local h = hints[1]
        local yo = up_down_t(h.time, 150, 7) * 8
        rectfill(0, 127 - yo, 127, 135 - yo, 10)
        center_print(h.text, 64, 129 - yo, 0)
    end

    if description then
        --center_print(description, 64, 111, 1, 7)
        rectfill(0, 109, 127, 119, 6)
        rectfill(0, 110, 127, 118, 7)
        local w = print(description,0,-100)
        if w > 125 then
            local w2 = (w - 125) + 16
            clip(0, 1, 127, 126)
            local t = mid(w2 - abs((description_t\2) % (w2 * 2) - w2) - 8, 0, w - 125)
            camera(t)
        end
        print(description, 1, 112, 1)
        camera()
        description_t += 1
    end

    if time < 0x0.0010 then
        fillp(0b0.1 + (0b1000000000000000 >> (time \ 0x0.0001)))
        rectfill(0,0,127,127,1)
    end
    fillp()
end