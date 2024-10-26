function make_ent(spri, x, y, depth_offset)
    if type(spri) == "number" then spri = {spri,spri,spri} end
    local meta = SPRITE_META[spri[1]]
    local e = {spri=spri, x=x, y=y, depth_offset=depth_offset or 0, meta=meta}
    e.dir = {0,1}
    e.top_height = meta[4] - meta[10]
    e.max_height = meta[11] and (meta[11] * 2 + 1) or e.top_height
    populate_table(e, "moveable=false,interactable=false,blocks_placement=true,collides=true,shaking=0,name=none,height=0,imm_offset=0,hflip=false")
    e.debug_hitbox = true
    e.draw = function(self, invalid, fakex, fakey)
        --[[
        if self.pal then pal(self.pal) end
        local s = self.spri
        if type(self.spri) == "table" then
            s = self.spri[1]
            if self.dir[1] == 0 then
                if self.dir[2] < 0 then
                    s = self.spri[3]
                end
                self.hflip = false
            else
                if self.dir[1] > 0 then
                    self.hflip = false
                    s = self.spri[2]
                else
                    self.hflip = true
                    s = self.spri[2]
                end
            end
        else
            self.hflip = self.dir[1] < 0        
        end
        local x = self.x
        if self.shaking > 0 then
            self.shaking -= 1
            x = self.x + cos(time / 0x0.0004) * self.shaking / 8
        end
        x = fakex or x
        local y = fakey or self.y
        y -= self.height
        x -= self.imm_offset
        y -= self.imm_offset
        sprc(s, x, y, self.hflip)
        pal()
        --pset(self.x, self.y, 8)
        if selected_ent == self or (activity.name == "moving" and activity.ent == self) or self.outline_color then
            local mc = invalid and 8 or 7
            outline_sprc(self.outline_color or mc, s, x, y, self.hflip, false, nil, nil, self.pal)
        end
        if self.debug_hitbox then
            local x1, x2, y1, y2 = self:get_rect()
            rect(x1, y1 - self.height, x2, y2 - self.height, 8)
            rect(x1, y1 - self.top_height - self.height, x2, y2 - self.top_height - self.height, 12)
        end        
        ]]
    end
    e.update = function(self)
        self.imm_offset = 0
    end
    e.set_sprite = function(self, i)
        if type(i) == "number" then i = {i,i,i} end
        self.spri = i
        self.meta = SPRITE_META[i[1]]
    end
    e.get_rect = function(self)
        return unpack(self.rect)
    end
    e.move = function(self, x, y)
        self.x, self.y = x, y
        self:calculate_rect()        
    end
    e.rotate = function(self)
        self.dir = {self.dir[2], -self.dir[1]}
        self:calculate_rect()
    end
    e.get_dir_spri = function(self)
        local s = self.spri[1]
        local hflip = false
        if self.dir[1] == 0 then
            if self.dir[2] < 0 then
                s = self.spri[3]
            end
        else
            s = self.spri[2]
            if self.dir[1] < 0 then
                hflip = true
            end
        end
        return s, hflip
    end
    e.calculate_rect = function(self)
        local s = self:get_dir_spri()
        self.meta = SPRITE_META[s]
        local x1 = self.x + self.meta[7] - self.meta[5] - self.meta[3] / 2
        --local y1 = self.y + self.meta[8] - self.meta[6] - self.meta[4] / 2
        local y1 = self.y + self.meta[8] / 2 - self.meta[6] - self.meta[4] / 2 - 0.5
        self.rect = {
            x1,
            x1 + self.meta[9],
            y1,
            y1 + self.meta[10]
        }
        return self.rect
    end
    e.get_center = function(self)
        return {self.x, self.y}
    end
    e.get_sit_spot = function(self)
        local x1, x2, y1, y2 = self:get_rect()
        return {self.x, (y2 + y1) / 2}
    end
    e.shake = function(self)
        self.shaking = 20
    end
    e:calculate_rect()
    add(ents, e)
    return e
end

function draw_ents()
    local S_LOW, S_HIGH = 0, 32

    function get_slices(ent)
        local s, hflip = ent:get_dir_spri()
        local slices = {}
        local sx, sy, sw, sh, ox, oy, cx, cy, cw, ch = unpack(SPRITE_META[s])
        local h = 0
        local eh = ent.height \ 1
        for i = sh, ch, -1 do
            local iyo, iho, ih = i - 1, h + 1, 1
            if i == ch or h > ent.max_height then
                ih = ch + max(ent.top_height - ent.max_height,0)
                iyo = 0
                iho = sh
            end
            slices[h + eh] = {{
                sx, sy + iyo, sw, ih,
                ent.x - sw / 2, ent.y - iho - oy + ch / 2 - eh,
                sw, ih,
                hflip
            }, ent.pal}
            h += 1
        end
        return slices
    end

    local slices = {}
    for ent in all(ents) do
        for s, rect in pairs(get_slices(ent)) do
            if not slices[s] then slices[s] = {} end
            add(slices[s], rect)
        end
    end
    for s = S_LOW, S_HIGH do
        for slice in all(slices[s]) do
            r, cpal = unpack(slice)
            --if time % 0x0.0020 > 0x0.001 then
            --    rectfill(rect[5], rect[6], rect[5] + rect[3] - 1, rect[6] + rect[4] - 1, s)
            --else
                pal(cpal)
                sspr(unpack(r))
            --end
        end
        pal()
        flip() flip() flip()
    end
    
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

function make_floor_item(name, spri3, x, y, depth_offset)
    local e = make_ent(spri3, x, y, depth_offset)
    populate_table(e, "moveable=true,taken=false,name=" .. name)

    function e.try_move(self, dx, dy)
        e:move(self.x + dx, self.y + dy)
        local x1, x2, y1, y2 = self:get_rect()
        if x1 <= 0 or x2 >= cafe_size[1] * 12 + 1 or y1 <= -4 or y2 >= cafe_size[2] * 12 - 1 then
            self.x -= dx
            self.y -= dy
            self:calculate_rect()
        end
    end

    return e
end

function make_counter_item(name, spri3, x, y, depth_offset)
    local e = make_floor_item(name, spri3, x, y, (depth_offset or 0) - 2)
    e.moveable = false
    return e
end

function make_counter(spri3, x, y)
    local e = make_ent(spri3, x, y)
    populate_table(e, "is_counter=true")
    local x1, x2, y1, y2 = e:get_rect()
    
    e.counter_center = {(x2 + x1) / 2 + 0.5, (y1 + y2) / 2 - 0.5}
    e.counter_height = e.top_height
    return e
end

function collide_ents(a, b)
    local ox, oy = 0,0
    local ax1, ax2, ay1, ay2 = a:get_rect() --a.meta[7] + a.x, a.meta[9] + a.meta[7] + a.x, a.meta[8] + a.y, a.meta[10] + a.meta[8] + a.y
    local bx1, bx2, by1, by2 = b:get_rect() --b.meta[7] + b.x, b.meta[9] + b.meta[7] + b.x, b.meta[8] + b.y, b.meta[10] + b.meta[8] + b.y
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
    local ax1, ax2, ay1, ay2 = e:get_rect()
    return x >= ax1 and x <= ax2 and y >= ay1 and y <= ay2
end