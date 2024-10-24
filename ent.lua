function make_ent(spri, x, y, depth_offset)
    local meta = SPRITE_META[spri]
    if not meta then meta = SPRITE_META[spri[1]] end
    local e = {spri=spri, x=x + meta[3] \ 2, y=y + meta[4] \ 2, depth_offset=depth_offset or 0, meta=meta, hflip = false}
    e.dir = {0,1}
    e.has_top = meta[11] > 0
    e.top_height = e.has_top and (meta[11] * 2 + 1) or 0
    populate_table(e, "moveable=false,interactable=false,blocks_placement=true,collides=true,shaking=0,name=none,height=0,imm_offset=0")
    e.debug_hitbox = false
    e.draw = function(self, invalid, fakex, fakey)
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
            rectfill(x1, y1, x2, y2, rnd(15)\1)
        end        
    end
    e.update = function(self)
        self.imm_offset = 0
    end
    e.set_sprite = function(self, i)
        self.spri = i
        self.meta = SPRITE_META[i]
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
    end
    e.calculate_rect = function(self)
        local x1 = self.x + self.meta[7] - self.meta[5] - self.meta[3] / 2
        --local y1 = self.y + self.meta[8] - self.meta[6] - self.meta[4] / 2
        local y1 = self.y + self.meta[8] - self.meta[4] / 2
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
    local layers = {}
    local MINL, MAXL = 1, 160
    for ent in all(ents) do
        local layer = mid((ent.y + ent.depth_offset + ent.height) \ 1, MINL, MAXL)
        if not layers[layer] then
            layers[layer] = {}
        end
        add(layers[layer], ent)
    end

    for layer = MINL, MAXL do
        for ent in all(layers[layer]) do
            ent:draw()
        end
    end
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
    
    e.counter_center = {(x2 + x1) / 2 + 0.5, (y2 + y1) / 2}
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