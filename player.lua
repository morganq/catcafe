function make_player(x, y)
    local p = make_ent({40,41,42}, x, y, 4)
    p.update = function(self)
    end
    p.control = function(self)
        local dx = -tonum(btn(0)) + tonum(btn(1))
        local dy = -tonum(btn(2)) + tonum(btn(3))
        if abs(dx) > 0 and abs(dy) > 0 then
            dx = dx * 0.707
            dy = dy * 0.707
        end
        self.x += dx * 1.5
        self.y += dy * 1.5

        if abs(dx) > 0 or abs(dy) > 0 then
            if abs(dx) > abs(dy) then
                self.dir = {(dx < 0) and -1 or 1, 0}
            else
                if dy > 0 then
                    self.dir = {0,1}
                else
                    self.dir = {0,-1}
                end
            end
        end

        for ent in all(ents) do
            if ent != self then
                local col = collide_ents(self, ent)
                self.x += col[1]
                self.y += col[2]
            end
        end
        self.x = mid(self.x, 5, cafe_size[1] * 12 - 4)
        self.y = mid(self.y, -4, cafe_size[2] * 12 - 7)

        local pt = {self.dir[1] * 8 + self.x, self.dir[2] * 8 + self.y + 2}
        selected_ent = nil
        for ent in all(ents) do
            if ent.moveable or ent.interactable then
                if point_in_ent(pt[1], pt[2], ent) then
                    if btnp(B_CONFIRM) then
                        if ent.moveable then
                            activity = moving_activity(ent)
                        else
                            ent:interact()
                        end
                    end                      
                    selected_ent = ent
                    break
                end
            end
        end              
    end
    p.get_rect = function(self)
        return unpack(self:calculate_rect())
    end
    return p
end