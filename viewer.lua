view_offset = #SPRITE_META - 15
time = 0

function _draw()
    cls(7)
    local j =  0
    for i = view_offset, view_offset + 15 do
        local ox = j % 4 * 32 + 8
        local oy = j \ 4 * 32 + 8
        if i <= #SPRITE_META then
            local m = SPRITE_META[ i ]
            --sspr(m[1], m[2], m[3], m[4], ox + m[5], oy + m[6])
            spr(i, ox, oy)
            rect(ox - 1 - m[5], oy - 1 - m[6], ox + m[3] - m[5], oy + m[4] - m[6], 6)
            print(i, ox - 1, oy - 6, 0)
            if m[11] > 0 then
                print(m[11], ox + 10, oy - 6, 12)
            end
            pset(ox, oy, 8)
            if time % 8 < 4 and m[9] > 0 and m[10] > 0 then
                rectfill(ox + m[7], oy + m[8], ox + m[7] + m[9], oy + m[8] + m[10], 0)
            end
        end
        j += 1
    end

    pal(split"130,132,3,4,134,6,7,8,9,10,11,140,143,14,15,0",1)
end

function _update()
    time += 1
    if btn(0) then 
        view_offset = max(view_offset - 1, 1)
    end
    if btn(1) then 
        view_offset = min(view_offset + 1, #SPRITE_META - 15)
    end    
end