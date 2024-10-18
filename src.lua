--[[ Save Data
0: money
1: stars
2 - 18: 16 cat ids
19 - 51: 32 objects
    4 bytes per object
    byte 1: object id
    byte 2: x
    byte 3: y
    byte 4: ??
52-63: ??
]]

--[[ TODO 
rotating floor objects
]]

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