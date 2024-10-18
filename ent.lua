function make_ent(spri, x, y, depth_offset)
    local meta = SPRITE_META[spri]
    if not meta then meta = SPRITE_META[spri[1]] end
    local e = {spri=spri, x=x + meta[3] \ 2, y=y + meta[4] \ 2, depth_offset=depth_offset or 0, meta=meta, hflip = false}
    e.dir = {0,1}
    e.moveable = false
    e.interactable = false
    e.draw = function(self)
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
            printh(s)
        end
        sprc(s, self.x, self.y, self.hflip)
        pal()
        --pset(self.x, self.y, 0)
        if false then
            local x1, x2, y1, y2 = self:get_rect()
            rectfill(x1, y1, x2, y2, 12)
        end
        if selected_ent == self or (activity.name == "moving" and activity.ent == self) then
            outline_sprc(7, self.spri, self.x + self.meta[5] * (self.hflip and -1 or 1), self.y + self.meta[6], self.hflip)
        end
    end
    e.update = function(self) end
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
    e.calculate_rect = function(self)
        local x1 = self.x + self.meta[7] - self.meta[5] - self.meta[3] / 2
        local y1 = self.y + self.meta[8] - self.meta[6] - self.meta[4] / 2
        self.rect = {
            x1,
            x1 + self.meta[9],
            y1,
            y1 + self.meta[10]
        }
        --[[if self.hflip then
            local xo = self.meta[7]
            printh(xo)
            self.rect[1] -= xo
            self.rect[2] -= xo
        end]]
        return self.rect
    end
    e.get_center = function(self)
        --return {self.x + self.meta[3] / 2 - self.meta[5], self.y + self.meta[4] / 2 - self.meta[6]}
        return {self.x, self.y}
    end
    e:calculate_rect()
    add(ents, e)
    return e
end

function draw_ents()
    local layers = {}
    local MINL, MAXL = 1, 160
    for ent in all(ents) do
        local layer = mid((ent.y + ent.depth_offset) \ 1, MINL, MAXL)
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

function make_floor_item(spri3, x, y)
    local e = make_ent(spri3, x, y)
    e.moveable = true

    function e.try_move(self, dx, dy)
        e:move(self.x + dx, self.y + dy)

        local fail = false
        for ent in all(ents) do
            if ent != self then
                local col = collide_ents(self, ent)
                if col[1] != 0 or col[2] != 0 then
                    fail = true
                    break
                end
            end
        end
        local x1, x2, y1, y2 = self:get_rect()
        if x1 <= 0 or x2 >= cafe_size[1] * 12 + 1 or y1 <= 0 or y2 >= cafe_size[2] * 12 + 1 then
            fail = true
        end
        if fail then
            self.x -= dx
            self.y -= dy
            self:calculate_rect()
        end
        
    end

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