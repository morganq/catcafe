CUST_PALS = {
    --                                  I     N     S
    "01,02,03,04,05,06,07,08,09,10,01,12,01,14,04",
    "01,02,03,04,05,06,07,08,09,10,04,12,13,14,15",
    "01,02,03,04,05,06,07,08,09,10,00,12,00,14,02",
    "01,02,03,04,05,06,07,08,09,10,01,12,04,14,13",
}

function generate_desires()
    local desires = {}
    local num_people = rnd(split"1,1,1,1,2,2,2,3,4")
    for i = 1, num_people do
        add(desires, "drip coffee")
    end
    return desires
end

function make_customer()
    local e = make_ent({62,0,68}, door.x + 2, door.y, 4)
    e.state = "entering"
    e.state_timer = 0
    e.pal = split(rnd(CUST_PALS))
    e.pal[12] = rnd(split"1,2,3,4,5,12")
    local s = rnd(split"7,6,9,11")
    e.pal[6] = s
    if rnd() < 0.5 then
        e.pal[7] = s
    else
        e.pal[7] = rnd(split"7,6,9,10")
    end
    e.desires = generate_desires()
    local _draw = e.draw
    e.draw = function(self)
        _draw(self)
        if self.state == "queued" and self.state_timer > 150 then
            spr(69, self.x - 2, self.y - 13)
        end
    end
    e.set_state = function(self, state)
        self.state = state
        self.state_timer = 0
    end
    e.update = function(self)
        self.state_timer += 1
        if self.state == "entering" then
            if self.state_timer > 60 then
                -- var
                if #customer_queue < 3 then
                    add(customer_queue, self)
                    self:move(register.x + rnd(4) - 2,register.y - #customer_queue * 9)           
                    self:set_state("queued")
                    self.order = {}
                    local menu = get_menu()
                    self.sale = 0
                    for desire in all(self.desires) do
                        if contains(menu, desire) then
                            add(self.order, {desire, prices[desire]})
                            self.sale += prices[desire]
                        end
                    end
                    
                    local rn = rnd()
                    if rn < 0.1 then
                        self.given = ((self.sale - 0.5) \ 5 + 1) * 5
                    elseif rn < 0.3 then
                        self.given = ((self.sale - 0.5) \ 10 + 1) * 10
                    elseif rn < 0.8 then
                        self.given = ((self.sale - 0.5) \ 20 + 1) * 20
                    elseif rn < 0.9 then
                        self.given = ((self.sale - 0.5) \ 50 + 1) * 50
                    else
                        self.given = ((self.sale - 0.5) \ 100 + 1) * 100
                    end
                else
                    self:set_state("leave")
                end
            end
        end
        if self.state == "queued" then
            if self.state_timer >= 600 then
                self:set_state("leave")
                next_customer()
            end
        end
        if self.state == "leave" then
            self:move(door.x - 4, door.y + 3)
            self.dir = {0, -1}
            if self.state_timer > 30 then
                del(customers, self)
                del(ents, self)
            end
        end
        if self.state == "paid" then
            -- sit?
            if self.state_timer > 10 then
                self:set_state("leave")
            end
        end
    end
    return e
end

function init_customers()
    customer_queue = {}
    customers = {}
    walkin_timer = 0
end

function update_customers()
    -- var
    if walkin_timer <= 0 and #customers < 5 then
        if rnd(1) < 0.1 then -- var
            local c = make_customer()
            add(customers, c)
            walkin_timer = 100 + rnd(300) \ 1
        end
    end
    walkin_timer -= 1
end

function next_customer()  
    deli(customer_queue, 1)
    for c in all(customer_queue) do
        c.y += 9
    end
end