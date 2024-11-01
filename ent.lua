function make_spritepart(ent, spri1, spri2, spri3, xo, yo, ho)
    return {
        ent = ent,
        spri={spri1, spri2, spri3},xo=xo or 0,yo=yo or 0,ho = ho or 0,
        get_vars = function(self)
            local s, dir, hflip = self.spri[1], self.ent.dir, false
            if dir[1] == 0 then
                if dir[2] < 0 then
                    s = self.spri[3]
                end
            else
                s = self.spri[2]
                if dir[1] < 0 then
                    hflip = true
                end
            end
            return {s, hflip, SPRITE_META[s]}
        end,
        can_rotate = function(self)
            return (self.spri[1] != self.spri[2] or self.spri[1] != self.spri[3])
        end,
        get_sprite = function(self)
            return self:get_vars()[1]
        end,
        get_top_height = function(self)
            local meta = self:get_vars()[3]
            return meta[4] - meta[10]
        end,        
        get_manual_height = function(self)
            local meta = self:get_vars()[3]
            return meta[11] and (meta[11] * 2 + 1) or (meta[4] - meta[10])
        end,
        get_total_height = function(self)
            return self:get_top_height() + self.ent.height + self.ho
        end,        
        get_rect = function(self)
            local s, hflip, meta = unpack(self:get_vars())
            -- use hflip?
            local x1 = ent.x + meta[7] - meta[5] - meta[3] / 2 + self.xo
            local y1 = ent.y + meta[8] / 2 - meta[6] - meta[4] / 2 - 0.5 + self.yo
            return {
                x1,
                x1 + meta[9],
                y1,
                y1 + meta[10]
            }
        end
    }
end

function make_ent(name, parts_def, x, y, extras)
    local e = {x=x, y=y, name=name, pal=split"1,2,3,4,5,6,7,8,9,10,11,12,13,14,15"}
    e.parts = {}
    if type(parts_def) == "number" then
        parts_def = {{parts_def, parts_def, parts_def, 0, 0, 0}}
    end
    for s in all(parts_def) do 
        local args = pack(unpack(s))
        add(args, e, 1)
        add(e.parts, make_spritepart(unpack(args)))
    end
    e.dir = {0,1}
    populate_table(e, "moveable=false,interactable=false,blocks_placement=true,collides=true,shaking=0,height=0,imm_offset=0,hflip=false,hoppable=true")
    if extras then populate_table(e, extras) end

    e.update = function(self)
        self.imm_offset = 0
        if self == selected_ent then
            if self.interactable then
                self.outline_color = 10
            else
                if activity.name == "moving" and not activity.drop_valid then
                    self.outline_color = 8
                else
                    self.outline_color = 7
                end
                if activity.name == "moving" and is_ent_in_sell_spot(self) then
                    self.outline_color = 3
                end
            end
        else
            self.outline_color = nil
        end
    end
    e.set_spritepart = function(self, def, index)
        self.parts[index or 1] = make_spritepart(self,def,def,def,0,0,0)
        self:calculate_rect()
    end
    e.get_rect = function(self)
        return self.cached_rect
    end
    e.move = function(self, x, y)
        self.x, self.y = x, y
        self:calculate_rect()
    end
    e.adjust = function(self, dx, dy)
        self:move(self.x + dx, self.y + dy)
        local x1, x2, y1, y2 = unpack(self:get_rect())
        if x1 <= 0 or x2 >= cafe_size[1] * 12 + 1 or y1 <= -2 or y2 >= cafe_size[2] * 12 then
            self:move(self.x - dx, self.y - dy)
        end
    end    
    e.rotate = function(self)
        local rotates = false
        for part in all(self.parts) do 
            if part:can_rotate() then
                rotates = true
            end
        end
        if not rotates then return end
        self.dir = {self.dir[2], -self.dir[1]}
        self:calculate_rect()
    end
    e.calculate_rect = function(self)
        self.cached_rect = self.parts[1]:get_rect()
        return self.cached_rect
    end
    e.shake = function(self)
        self.shaking = 20
    end
    e.get_total_height = function(self)
        return self.parts[#self.parts]:get_total_height()
    end
    e:calculate_rect()
    add(ents, e)
    return e
end

function draw_ents()
    local S_LOW, S_HIGH = 0, 32

    function get_slices(ent, part)
        local s, hflip, meta = unpack(part:get_vars())
        local slices = {}
        local sx, sy, sw, sh, ox, oy, cx, cy, cw, ch = unpack(meta)
        local h = 0
        local eh = ent.height \ 1 + part.ho + ent.imm_offset \ 1
        ox += ent.imm_offset \ 1
        local mh,th = part:get_manual_height(), part:get_top_height()
        
        ox += part.xo
        oy += part.yo  
        
        for i = sh, ch, -1 do
            local iyo, iho, ih = i - 1, h + 1, 1
            if i == ch or h > mh then
                ih = ch + max(th - mh,0)
                iyo = 0
                iho = sh
            end
            slices[h + eh] = {{
                sx, sy + iyo, sw, ih,
                ent.x - sw / 2 + ox, ent.y - iho - oy + ch / 2 - eh,
                sw, ih,
                hflip
            }, ent.pal, ent.outline_color, i == sh}
            --printh(i .. " / " .. h + eh .. " / " .. iyo .. ", " .. iho .. ", " .. ih)
            if h > mh then return slices end
            h += 1
        end
        return slices
    end

    local slices = {}
    for ent in all(ents) do
        for part in all(ent.parts) do
            for s, rect in pairs(get_slices(ent, part)) do
                if not slices[s] then slices[s] = {} end
                add(slices[s], rect)
            end
        end
    end
    for s = S_LOW, S_HIGH do
        for slice in all(slices[s]) do
            r, cpal, oc, is_bottom = unpack(slice)
            if oc then
                memset(0x5f01,oc,15)
                for co in all({{-1,0},{1,0},{0,1}}) do
                    camera(camx + co[1], camy + co[2])
                    sspr(unpack(r))
                end
                if is_bottom then
                    camera(camx, camy - 1)
                    sspr(unpack(r))
                end 
                camera(camx, camy)
            end
            
            --rectfill(r[5], r[6], r[5] + r[3] - 1, r[6] + r[4] - 1, 8)
            --if time % 0x0.0020 > 0x0.001 then
            --    
            --else
            --rectfill(r[5], r[6], r[5] + r[3] - 1, r[6] + r[4] - 1, s)
                pal(cpal)
                sspr(unpack(r))
            --end
        end
        pal()
        if DEBUG_LAYERS == true then
            print(s, (s % 8) * 8 - 20, -30 + (s \ 8) * 8, 8)
            flip()
            while not btn(5) do
                _update_buttons()
            end
            while btn(5) do
                _update_buttons()
            end            
            
        end
    end
    DEBUG_LAYERS = false
    --[[
    for ent in all(ents) do
        --pset(ent.x, ent.y, 8)
        local x1, x2, y1, y2 = ent:get_rect()
        rect(x1, y1, x2, y2, 12)
    end
    ]]
end

function make_blocker(x, y, w, h)
    local e = make_ent(1, x, y, -127)
    e.collides = false
    e.draw = function(self)
        local x1,x2,y1,y2 = self:get_rect()
        rectfill(x1,y1,x2,y2, 15)
    end
    e.get_rect = function(self) return self.x, self.x + w, self.y, self.y + h end
    return e
end

function collide_ents(a, b)
    local ox, oy = 0,0
    local ax1, ax2, ay1, ay2 = unpack(a:get_rect())
    local bx1, bx2, by1, by2 = unpack(b:get_rect())
    if ax2 > bx1 and ax1 < bx2 and ay2 >= by1 and ay1 <= by2 then
        local ox1, ox2, oy1, oy2 = ax2 - bx1, bx2 - ax1, ay2 - by1, by2 - ay1
        local sx, sy = 1,1
        if ox1 < ox2 then ox = ox1; sx = -1
        else ox = ox2 end
        if oy1 < oy2 then oy = oy1; sy = -1
        else oy = oy2 end        
        if abs(ox) < abs(oy) then
            return {ox * sx, 0}
        else
            return {0, oy * sy}
        end        
    end
    return {0,0}
end

function point_in_ent(x, y, e)
    local a = e:get_rect()
    return x >= a[1] and x <= a[2] and y >= a[3] and y <= a[4]
end