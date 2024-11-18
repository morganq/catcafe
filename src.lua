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

--[[
Playtest
day 1: 35?
day 2: 90
day 3: 180

]]

function save_game()
    memset(0x5e00,0,0xff) -- reset save
    poke (0x5e00, day_num)
    poke2(0x5e01, money)
    poke2(0x5e03, stars)
    for i = 0,min(#cats - 1, 15) do
        poke(0x5e05 + i, cats[i + 1].index)
    end
    local i = 0
    for e in all(ents) do
        if e.ind and i < 32 then
            poke(0x5e15 + i * 4, e.ind, e.x, e.y, e.rot)
            i += 1
        end
    end
    poke(0x5e95, autoreg and 1 or 0)
    poke4(0x5e96, seed)
    poke(0x5ea0, )
    for i = 1, 30 do
sfn([[
rectfill,0,59,127,69,0
print,saving,11,62,7
zspr,131,1,60
]])
        flip()
    end
end

function load_game()
    day_num = peek(0x5e00)
    if day_num == 0 then return end
    money, stars = peek2(0x5e01), peek2(0x5e03)
    for i = 0,15 do
        local cid = peek(0x5e05 + i)
        if cid > 0 then
            add(cats, make_cat(cid))
        end
    end
    -- 0x5e15
    for i = 0,127,4 do
        local oid, x, y, rot = peek(0x5e15 + i), peek(0x5e15 + i + 1), peek(0x5e15 + i + 2), peek(0x5e15 + i + 3)
        if oid > 0 then
            acquire_buyable(oid, x, y, rot)
        end
    end
    -- 0x5e95
    if peek(0x5e95) > 0 then install_autoreg() end
    seed = peek4(0x5e96)
end

poke(0X5F5C, 8)
poke(0X5F5D, 2)

--B_CONFIRM, B_BACK, ZS_CONFIRM, ZS_BACK = 4, 5, 74, 73
B_CONFIRM, B_BACK, ZS_CONFIRM, ZS_BACK = 5, 4, 73, 74
