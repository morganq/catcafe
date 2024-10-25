SPRITE_META = {}
local i = 1
while i < #SPRITE_META_STR do
    function next()
        local value = tonum(SPRITE_META_STR[i] .. SPRITE_META_STR[i + 1], 0x1)
        i += 2
        return value
    end    
    local len = next()
    --printh(len)
    local meta = split"0,0,0,0,0,0,0,0,0,0,0"
    for j = 1, len do
        meta[j] = next()
        if j == 5 or j == 6 then meta[j] = meta[j] - 127 end
    end
    add(SPRITE_META, meta)
end

p8_spr = spr
function spr(n, x, y, fx, fy, dw, dh)
    local m = SPRITE_META[ n ]
    sspr(m[1], m[2], m[3], m[4], x + m[5], y - m[6], dw or m[3], dh or m[4], fx, fy)
end
function sprc(n, x, y, fx, fy, dw, dh)
    local m = SPRITE_META[ n ]
    sspr(m[1], m[2], m[3], m[4], x - m[3] / 2 - m[5], y - m[4] / 2 - m[6], dw or m[3], dh or m[4], fx, fy)    
end

function outline_sprc(c, n, x, y, fx, fy, dw, dh, p)
    pal({c,c,c,c,c,c,c,c,c,c,c,c,c,c,c})
    local off = {{-1,0},{1,0},{0,-1},{0,1}}
    for i = 1, 4 do
        sprc(n, x + off[i][1], y + off[i][2], fx, fy, dw, dh)
    end
    pal(p)
    sprc(n, x, y, fx, fy, dw, dh)
    pal()
end

function draw_paw(x, y, angle, size, color1, color2)
    circfill(x + cos(angle) * size * 0.1, y + sin(angle) * size * 0.1, size*1.1, color1)
    for i = -2, 1 do
        local ta = angle + i * 0.125 + 0.0625
        local cx, cy = cos(ta) * size + x, sin(ta) * size + y
        circfill(cx, cy, size * 0.5, color1)
        
    end
    for i = -2, 1 do
        local ta = angle + i * 0.125 + 0.0625
        local cx, cy = cos(ta) * size + x, sin(ta) * size + y
        circfill(cx, cy, size * 0.30, color2)
    end
    for i = 0, 2 do
        local ta = angle + 0.33 * i
        local cx = cos(ta) * size * 0.3 + x + cos(angle) * size * -0.1
        local cy = sin(ta) * size * 0.3 + y + sin(angle) * size * -0.1
        circfill(cx, cy, size * 0.40, color2)
    end
end

function center_print(s, x, y, color, bgcolor, outlinecolor, rounded)
	for s in all(split(s,"\n")) do
		local w = print(s,0,-600) 
		local xo = (w - 0.5) \ 2
		if bgcolor then
            
			rectfill(x - xo - 1, y - 1, x + xo + 1, y + 5, bgcolor)
            if rounded then
                rectfill(x - xo - 2, y, x + xo + 2, y + 4, bgcolor)
            end
		end
		if outlinecolor then
			rect(x - xo - 2, y - 2, x + xo + 2, y + 6, outlinecolor)
		end
		print(s, x - xo, y, color)
		y += 8
	end
end

function draw_cash(num, x, y, selected)
    CASH_SPRS = {64, [5] = 65, [10] = 66, [20] = 67}
    local s = CASH_SPRS[num]
    rectfill(x, y, x + 17, y + 36, 11)
    rect(x, y, x + 17, y + 36, 3)
    if selected then
        rect(x-1, y-1, x + 18, y + 37, 10)
    end
    spr(63, x + 4, y + 13)
    spr(s, x + 2, y + 35 - SPRITE_META[s][4])
    spr(s, x + 11, y + 2)
end

function contains(lst, ele)
	for item in all(lst) do
		if ele == item then return true end
	end
	return false
end

function populate_table(o, s)
	for kv in all(split(s)) do
		local k,v = unpack(split(kv, "="))
		if v == "false" then o[k] = false
		elseif v == "true" then o[k] = true
		else
			o[k] = v
		end
	end
end

function string_table(s)
    local z = {}
    populate_table(z, s)
    return z
end

function up_down_t(x, total, cap)
	local ma = cap - mid(abs(x - total/2) - (total / 2 - cap), 0, cap)
	return ma / cap
end

function cos_ease(x)
	return cos(x / 2) * -0.5 + 0.5 
end