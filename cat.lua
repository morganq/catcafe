CAT_NAMES = split"bella,tigger,chloe,shadow,luna,oreo,oliver,kitty,lucy,molly,jasper,smokey,gizmo,simba,tiger,charlie,angel,jack,lily,peanut,toby,baby,loki,gracie,milo,princess,sophie,harley,max,missy,rocky,zoe,coco,misty,nala,oscar,pepper,sasha,buddy,pumpkin,kiki,mittens,bailey,callie,lucky,patches,simon,garf,george,maggie,sammy,sebastian,boots,cali,felix,lilly,phoebe,sassy,tucker,bandit,dexter,fiona,jake,precious,romeo,snickers,socks,daisy,midnight,lola,sadie,sox,casper,fluffy,marley,minnie,sweetie,ziggy,belle,brownie,chester,frankie,ginger,muffin,murphy,rusty,scooter,batman,boo,cleo,izzy,jasmine,mimi,sugar,cupcake,dusty,leo,noodle,panda,peaches"

CAT_EYES = {
    [0] = split"10,11,12,7,9",
    [1] = split"10,11,12,7,9",
    [2] = split"10,11,6,7,0,9",
    [4] = split"10,11,12,7,0",
    [6] = split"12,7,0,1,2,3",
    [9] = split"1,2,3,0",
    [10] = split"12,0,1,2",
}

CAT_SHADOWS = split"0,0,1,X,2,X,5,X,X,4,9"

--200ish tokens
function generate_cat_features(index, cat)
    local t = cat or {}
    t.name = CAT_NAMES[index]
    local prerand = rnd()
    
    srand(index)
    t.index = index
    t.base_color = rnd(split"0,1,2,4,6,9,10")
    t.eye_color = rnd(CAT_EYES[t.base_color])
    if contains(split"0,1,2,3", t.eye_color) then
        t.portrait_pupil_color = t.eye_color
        t.portrait_iris_color = 6
    else
        t.portrait_pupil_color = 0
        t.portrait_iris_color = t.eye_color        
    end
    t.portrait_border_color = 1
    if contains(split"0,1,2", t.base_color) then
        t.portrait_border_color = 7
    end

    function drnd()
        return (rnd() + rnd() + rnd()) / 3
    end

    t.prop_sit = drnd() * 1.8 + 0.2
    t.prop_speed = drnd() * 0.25 + 0.125
    t.prop_run = drnd() * 0.5 + 0.125
    t.prop_annoying = drnd() * 0.5 + 0.125
    t.prop_active = drnd() * 0.5 + 0.2


    t.portrait = rnd(split"89,90,91,92,93,94,95,96")
    srand(prerand)

    t.pal = split"1,2,3,4,5,6,7,8,9,10,11,12,13,14,15"
    t.pal[4] = t.base_color
    t.pal[2] = CAT_SHADOWS[t.base_color + 1]
    t.pal[10] = t.eye_color
    t.pal[11] = t.portrait_iris_color
    t.pal[8] = t.portrait_pupil_color
    t.pal[12] = t.portrait_border_color
    if t.base_color == 0 or t.base_color == 1 then t.pal[1] = 0 end
    return t
end

--659 tokens
function make_cat(index, x, y)
    local e = make_ent("cat", 1, x, y)
    populate_table(e, "state=sitting,state_timer=0,hopping_up=0,hop_time=0,debug_hitbox=false,collides=true,sit_time=0,boost_time=0")
    
    generate_cat_features(index, e)
    
    printh("cat: " .. e.name .. "\nbase: " .. e.base_color .. "\neye: " .. e.eye_color .. "\nsit: " .. e.prop_sit .. "\nspeed: " .. e.prop_speed .. "\nannoying: " .. e.prop_annoying .. "\nactive: " .. e.prop_active .. "\nrun: " .. e.prop_run)

    e.set_state = function(self, state)
        self.state = state
        self.state_timer = 0
    end
    e.walk_to = function(self, tx, ty)
        self:set_state("walking")
        self.walk_target = {tx,ty}
    end
    e.pick_random_state = function(self)
        if rnd() < self.prop_active then
            local spots = get_sitting_spots()
            if #spots > 0 and rnd() < e.prop_annoying then
                local c = rnd(spots)
                local ss = {c.x, c.y}
                self:walk_to(ss[1], ss[2])
            else
                self:walk_to((rnd(cafe_size[1] - 1) + 0.5) * 12, (rnd(cafe_size[2] - 1) + 0.5) * 12)
            end
            if rnd() < self.prop_run then
                self.boost_time = self.prop_run * 80
            end
        elseif rnd() < 0.35 then
            self:set_state("belly")
        elseif rnd() < 0.35 then
            self:set_state("playing")            
        else
            self:set_state("sitting")
            self.sit_time = (120 + rnd(120)) * self.prop_sit
        end
    end
    e.update = function(self)
        self.boost_time -= 1
        if self.state == "sitting" then
            self:set_spritepart(1)
            if self.state_timer > self.sit_time then
                self:pick_random_state()
            end
        elseif self.state == "playing" then
            self:set_spritepart((self.state_timer < 10) and 1 or 23 + self.state_timer \ 5 % 4)
            if self.state_timer > 120 then
                self:pick_random_state()
            end
        elseif self.state == "belly" then
            self:set_spritepart((self.state_timer < 30) and 1 or 23)
            if self.state_timer > 120 then
                self:pick_random_state()
            end            
        elseif self.state == "walking" then
            local dx, dy = self.walk_target[1] - self.x, self.walk_target[2] - self.y
            if dx < 0 then self.dir = {-1, 0} else self.dir = {1, 0} end
            local d = sqrt(dx * dx + dy * dy)
            local boost = (self.boost_time > 0) and 2 or 1
            local delta = {dx / d * self.prop_speed * boost, dy / d * self.prop_speed * boost}
            if self.hopping_up != self.height then
                self.hop_time += 1
                if self.height > self.hopping_up then
                    self.height -= 0.5
                    self:set_spritepart(87)
                end
                if self.height < self.hopping_up then
                    self.height += 0.5
                    self:set_spritepart(14 + min(self.hop_time \ (8 / boost), 1))
                end
                self:move(self.x + delta[1] / 8, self.y + delta[2] / 8)
            else
                self:set_spritepart(2 + (self.state_timer \ 8) % 6)
                self.hopping_up = 0
                self:move(self.x + delta[1], self.y + delta[2])
                for ent in all(ents) do
                    if ent != self and ent.collides then
                        local c = collide_ents(self, ent)
                        if c[1] != 0 or c[2] != 0 then
                            if not ent.hoppable then
                                if self.state_timer > 30 and rnd() < 0.5 then
                                    self:set_state("sitting")
                                else
                                    self.walk_target[1] = self.x + sgn(c[1]) * 8
                                    self.walk_target[2] = self.y + sgn(c[2]) * 8
                                    printh("PUSH AWAY")
                                end
                                self:move(self.x + c[1], self.y + c[2])
                            else 
                                local h = 0
                                for part in all(ent.parts) do
                                    local c2 = collide_ents(self, part)
                                    if c2[1] != 0 or c2[2] != 0 then
                                        h = max(h, part:get_total_height())
                                    end
                                end
                                self.hopping_up = max(self.hopping_up, h)
                                self.hop_time = 0
                            end
                        end
                    end
                end
                if d < 3 then
                    self:pick_random_state()
                end                
            end
        end
    end
    --e:walk_to(20, 55)
    return e
end

function update_cats()
    for c in all(cats) do
        c.state_timer += 1
    end
end