--[[ Save Data
money
stars
16 cat ids
32 objects:
    4 bytes per object
    byte 1: object id
    byte 2: x
    byte 3: y
    byte 4: rotation
autoreg
]]

function save()

end

function load()
    money, stars = peek2(0x5e00), peek2(0x5e02)
    for i = 0,15 do
        local cid = peek(0x5e04 + i)
        if cid > 0 then
            add(cats, make_cat(cid, door.x - 3, door.y + 8))
        end
    end
    -- 0x5e14
    for i = 0,128,4 do
        local oid, x, y, rot = peek(0x5e14 + i), peek(0x5e14 + i + 1), peek(0x5e14 + i + 2), peek(0x5e14 + i + 3)
    end
    -- 0x5e94
    autoreg = peek(0x5e94)
end

poke(0X5F5C, 8)
poke(0X5F5D, 2)

B_CONFIRM = 5
B_BACK = 4

function _init()
    set_state(state_game)
end

function set_state(s, args)
    current_state = s
    s.start(args)
end

function _update()
    current_state.update()
end

function _draw()
    current_state.draw()
    pal(split"130,132,3,4,134,6,7,8,9,10,11,140,143,14,15,0",1)
end