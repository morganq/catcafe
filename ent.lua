function get_meta_heights(meta)
    local th = (meta[4] - meta[10])
    return (meta[11] and (meta[11] * 2 + 1) or th), th
end

function make_spritepart(spri1, spri2, spri3, xo, yo, ho)
    local meta = SPRITE_META[spri1]
    return {
        spri={spri1, spri2, spri3},xo=xo or 0,yo=yo or 0,ho = ho or 0,
        get_dir_spri = function(self, ent)
            local s = self.spri[1]
            local hflip = false
            if ent.dir[1] == 0 then
                if ent.dir[2] < 0 then
                    s = self.spri[3]
                end
            else
                s = self.spri[2]
                if ent.dir[1] < 0 then
                    hflip = true
                end
            end
            return s, hflip, SPRITE_META[s]
        end,
        calculate_rect = function(self, ent)
            local s = self:get_dir_spri(ent)
            local meta = SPRITE_META[s]
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

function make_ent(parts, x, y)
    if type(parts) == "number" then parts = {make_spritepart(parts,parts,parts,0,0)} end
    local meta = SPRITE_META[parts[1].spri[1]]
    local e = {x=x, y=y, meta=meta, pal=split"1,2,3,4,5,6,7,8,9,10,11,12,13,14,15"}
    e.parts = parts
    e.dir = {0,1}
    populate_table(e, "moveable=false,interactable=false,blocks_placement=true,collides=true,shaking=0,name=none,height=0,imm_offset_x=0,imm_offset_y=0,imm_offset_h=0,hflip=false,hoppable=true")

    e.update = function(self)
        self.imm_offset_x = 0
        self.imm_offset_y = 0
        self.imm_offset_h = 0
        if self == selected_ent then
            if self.interactable then
                self.outline_color = 10
            else
                if activity.name == "moving" and not activity.drop_valid then
                    self.outline_color = 8
                else
                    self.outline_color = 7
                end
            end
        else
            self.outline_color = nil
        end
    end
    e.set_sprite = function(self, i)
        if type(i) == "number" then i = make_spritepart(i,i,i) end
        self.parts[1] = i
        self:calculate_rect()
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
    e.calculate_rect = function(self)
        self.rect = self.parts[1]:calculate_rect(self)
        return self.rect
    end
    e.shake = function(self)
        self.shaking = 20
    end
    e.get_top_height = function(self)
        local th = 0
        for p in all(self.parts) do
            local _,_,m = p:get_dir_spri(self)
            local _,z = get_meta_heights(m)
            th += z
        end
        return th
    end
    e:calculate_rect()
    add(ents, e)
    return e
end

function draw_ents()
    local S_LOW, S_HIGH = 0, 32

    function get_slices(ent, part)
        local s, hflip, meta = part:get_dir_spri(ent)
        local slices = {}
        local sx, sy, sw, sh, ox, oy, cx, cy, cw, ch = unpack(meta)
        local h = 0
        local eh = ent.height \ 1 + part.ho + ent.imm_offset_h \ 1
        local mh,th = get_meta_heights(meta)
        
        ox += part.xo
        oy += part.yo  
        --printh("-- " .. ent.name .. " --")
        for i = sh, ch, -1 do
            local iyo, iho, ih = i - 1, h + 1, 1
            if i == ch or h > mh then
                ih = ch + max(th - mh,0)
                iyo = 0
                iho = sh
            end
            slices[h + eh] = {{
                sx, sy + iyo, sw, ih,
                ent.x - sw / 2, ent.y - iho - oy + ch / 2 - eh,
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
        --flip() flip() flip()
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

function make_floor_item(name, spri3, x, y)
    local e = make_ent(spri3, x, y)
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

function make_counter_item(name, spri3, x, y)
    local e = make_floor_item(name, spri3, x, y)
    e.moveable = false
    e.hoppable = false
    return e
end

function make_counter(spri3, x, y, moveable)
    local e = make_floor_item("none",spri3, x, y)
    populate_table(e, "is_counter=true")
    e.moveable = moveable or false
    local x1, x2, y1, y2 = e:get_rect()
    
    _,e.counter_height = get_meta_heights(e.meta)
    return e
end

function collide_ents(a, b)
    local ox, oy = 0,0
    local ax1, ax2, ay1, ay2 = a:get_rect()
    local bx1, bx2, by1, by2 = b:get_rect()
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