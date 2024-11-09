function make_player(x, y)
    local p = make_ent("player", {{40,41,42,0,0}}, x, y, "hoppable=false,snack_time=0")
    p.control = function(self)

        if self.snack_time > 0 then
            self.snack_time -= 1
            local s = (self.snack_time % 10 > 5) and 124 or 125
            self:set_spritepart(s)
            self.dir = {0,1}
        else

            local dx, dy = -tonum(btn(0)) + tonum(btn(1)), -tonum(btn(2)) + tonum(btn(3))
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
                if time \ 4 % 2 == 0 then
                    self:set_spritepart(118, (time \ 8 % 2 == 0) and 122 or 123, 120)
                else
                    self:set_spritepart(119, 41, 121)
                end
            else
                self:set_spritepart(40, 41, 42)
            end

        end

        for ent in all(ents) do
            if ent.collides and ent != self then
                local col = collide_ents(self, ent)
                self.x += col[1]
                self.y += col[2]
            end
        end
        self.x = mid(self.x, 5, cafe_size[1] * 12 - 4)
        self.y = mid(self.y, 1, cafe_size[2] * 12 - 1)

        local pt = {self.dir[1] * 6 + self.x, self.dir[2] * 6 + self.y}
        selected_ent = nil
        for ent in all(ents) do
            if not ent.taken and (ent.moveable or ent.interactable) then
                if point_in_ent(pt[1], pt[2], ent) then
                    if btnp(B_CONFIRM) then
                        if ent.interactable then
                            ent:interact()
                        else
                            activity = moving_activity(ent)
                        end
                    end                      
                    selected_ent = ent
                    break
                end
            end
        end
        if not selected_ent then
            local nd, nc = 999, nil
            for cat in all(cats) do
                local dx, dy = self.x - cat.x, self.y - cat.y
                local d = sqrt(dx * dx + dy * dy)
                if d < 23 and d < nd then
                    nc = cat
                    nd = d
                end
            end
            self.nearest_cat = nc
            if btnp(B_CONFIRM) and nc then
                self.snack_time = 30
                nc:walk_to(self.x + rnd(12) - 6, self.y + rnd(12) - 6)
            end
        end
    end
    p.get_rect = function(self)
        return self:calculate_rect()
    end
    return p
end