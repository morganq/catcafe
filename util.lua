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

function zspr(n, x, y, fx, fy, dw, dh)
    local m = SPRITE_META[ n ]
    sspr(m[1], m[2], m[3], m[4], x + m[5], y - m[6], dw or m[3], dh or m[4], fx == true or fx == 1, fy == true or fy == 1)
end

function draw_paw(x, y, angle, size, color1, color2)
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
		--[[if outlinecolor then
			rect(x - xo - 2, y - 2, x + xo + 2, y + 6, outlinecolor)
		end]]
		print(s, x - xo, y, color)
		y += 8
	end
end

--8093
function rprint(text, x, y, color)
    print(text, x - print(text, 0, -100), y, color)
end

function temp_camera(dx, dy, fn)
    local cx, cy = peek2(0x5f28), peek2(0x5f2a)
    camera(cx + dx, cy + dy)
    fn()
    camera(cx, cy)
end

function draw_cash(num, x, y, selected)
    CASH_SPRS = {64, [5] = 65, [10] = 66, [20] = 67}
    local s = CASH_SPRS[num]
    temp_camera(-x, -y, function()
        sfn([[
rectfill,0,0,17,36,11
rect,0,0,17,36,3
zspr,63,4,13
]])
        zspr(s,11,2)
        zspr(s, 2, 35 - SPRITE_META[s][4])
        if selected then
            rect(-1, -1, 18, 37, 10)
        end        
    end)
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

function string_multitable(s)
    local mt = {}
    for line in all(split(s,"\n")) do
        if #line > 3 then
            add(mt, string_table(line))
        end
    end
    return mt
end

function up_down_t(x, total, cap)
	local ma = cap - mid(abs(x - total/2) - (total / 2 - cap), 0, cap)
	return ma / cap
end

function cos_ease(x)
	return cos(x / 2) * -0.5 + 0.5 
end

function sfn(s)
    for line in all(split(s, "\n")) do
        if #line > 3 then
            local vars = split(line)
            local fnn = vars[1]
            deli(vars, 1)
            _ENV[fnn](unpack(vars))
        end
    end
end

function dxdyd(x1, y1, x2, y2)
    local dx, dy = x2 - x1, y2 - y1
    local d = sqrt(dx * dx + dy * dy)
    return dx, dy, d, dx / d, dy / d
end