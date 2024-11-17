function activity_updates()
    if activity.name == "play" then
        player:control()
        if btnp(B_CONFIRM) then
            activity = phone_activity()
        end

    elseif activity.name == "moving" then
        local e = activity.ent
        local dx, dy = tonum(btnp(1)) - tonum(btnp(0)),tonum(btnp(3)) - tonum(btnp(2))
        activity.drop_valid = true
        e:adjust( dx * 2 , dy * 2 )
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
            if is_ent_in_sell_spot(activity.ent) then
                del(ents, activity.ent)
                money += activity.ent.cost
                activity = play_activity()
            else 
                if activity.drop_valid then
                    activity = play_activity()
                else
                    -- sfx
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
            if not item.price or money >= item.price then
                money -= item.price and item.price or 0
                if item.children then
                    add(cursor, 1)
                    activity.scroll = 0
                elseif item.type == "autoreg" then
                    install_autoreg()
                elseif item.type == "floorplan" then
                    local dy = item.plany - cafe_size[2]
                    for c in all(ents) do
                        if c != door then
                            c:move(c.x, c.y + dy * 12)
                        end
                    end
                    --flap:move(flap.x, flap.y + dy * 12)
                    --blocker.y += dy * 12
                    activity = play_activity()
                    cafe_size = {item.planx, item.plany}
                elseif item.type == "buy_floor" then
                    local e = acquire_buyable(item.ind)
                    activity = moving_activity(e)
                    selected_ent = e
                    
                elseif item.type == "adopt_cat" then
                    if has_ent(item.title) then
                        hint("already adopted " .. item.title .. "!")
                    elseif #cats >= get_max_cats()\1 then
                        hint("reached maximum cats")
                    else
                        add(cats, make_cat(item.features.index))
                        activity = play_activity()
                    end
                elseif item.fn then
                    item.fn()
                end
            else
                hint("not enough money")
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
        determine_tip()
        local dx = tonum(btnp(1)) - tonum(btnp(0))
        activity.selected_bill = mid(activity.selected_bill + dx, 1, 4)
        if btnp(B_CONFIRM) then
            local v = BILLS[activity.selected_bill]
            add(activity.bills, v)
            activity.change -= v
            bump_change = 4
        end
        if activity.change == 0 then
            complete_change()
        elseif activity.change < 0 or #activity.bills > 10 then
            activity.change = activity.given - activity.customer.sale
            activity.bills = {}
            hint("wrong change")
        end        
        if btnp(B_BACK) then
            activity = play_activity()
        end         
    end
end