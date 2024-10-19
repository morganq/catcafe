state_game.draw = function()
    local controls = {}
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



    draw_ents()

    if selected_ent then
        controls = {"select"}
        if selected_ent.interactable then controls = {"use"} end
    end

    if activity.name == "moving" then
        controls = {"place", "rotate"}
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
    end

    if activity.name == "moving" then
        if activity.ent then
            activity.ent:draw(not activity.drop_valid)
        end
    end

    -- UI camera
    camera()
    if activity.name == "phone" then
        controls = {"select", "back"}
        rectfill(41,14,88,113, 1)
        rectfill(36,19,93,108, 1)

        -- todo: screen lights up and loads
        rectfill(38,16,91,111, 7)
        spr(54, 36, 14)
        spr(54, 89, 14, true)
        spr(54, 36, 109, false, true)
        spr(54, 89, 109, true, true)

        local tree, selected = get_phone_state()
        camera(-38, -18)
        clip(38, 18, 54, 92)
        local y = 3
        local children = tree.children
        if tree.title then
            center_print(tree.title, 26, 0, 2)
            y = 12
            if tree.title == "stats" then
                children = {
                    {title="max cats", value=stats["max_cats"]},
                    {title="seats", value=#get_seats()},
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
        local last_page = (#children \ tree.scroll_page + 1)
        for i = p1, min(p1 + tree.scroll_page - 1, #children) do
            local child = children[i]
            local x = 2
            local th = 5
            if child.type == "buy_floor" or child.type == "buy_counter" then
                th = 13
            end            
            if selected == i then
                rectfill(0, y - 2, 53, y + th + 1, 10)
            end            
            if child.img then
                local meta = SPRITE_META[ child.img ]
                local x1, y1, w, h, dx, dy = meta[1], meta[2], meta[3], meta[4], 1, y
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
                sspr(x1, y1, w, h, dx, dy)
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
            
            print(child.title, x, y, child.color or 0)
            if child.type == "buy_floor" or child.type == "buy_counter" then
                print("$" .. child.price, x, y + 7, child.price > money and 8 or 0)
            end
            y += th + 5
        end
        if #children > tree.scroll_page then
            if page > 1 then
                spr(71, 24, 7)
            end
            if page < last_page then
                spr(71, 24, 81,false,true)
            end
            center_print(page .. "/" .. last_page, 26, 87, 0)
        end
        clip()
        camera()
    elseif activity.name == "register" then
        controls = {"pick", "back"}
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
    
    if controls[1] then
        spr(73, 3, 120)
        local o = print(controls[1], 12, 121, 0)
        if controls[2] then
            spr(74, o + 8, 120)
            print(controls[2], o + 17, 121, 0)        
        end
    end
end