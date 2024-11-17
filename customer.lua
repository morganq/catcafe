CUST_PALS = {
    --                                  I     N     S
    "01,02,03,04,05,06,07,08,09,10,01,12,01,14,04",
    "01,02,03,04,05,06,07,08,09,10,04,12,13,14,15",
    "01,02,03,04,05,06,07,08,09,10,00,12,00,14,02",
    "01,02,03,04,05,06,07,08,09,10,01,12,04,14,13",
}

BREAKFAST_END = 600 * (11.5 - 7.5)
LUNCH_END = 600 * (13.5 - 7.5)

function generate_desires()
    local menu = get_menu()
    local desires = {}
    local num_people = rnd(split"1,1,1,1,2,2,2,3,4")
    for i = 1, num_people do
        if contains(menu, "latte") and rnd() < 0.5 then
            add(desires, "latte")
        elseif contains(menu, "cappuccino") and rnd() < 0.25 then
            add(desires, "cappuccino")
        elseif contains(menu, "espresso") and rnd() < 0.25 then
            add(desires, "espresso")
        else
            add(desires, "drip coffee")
        end
        if rnd() < ((daytime > BREAKFAST_END) and 0.1 or 0) + 0.15 then
            add(desires, "savory pastry")
        end
        if rnd() < ((daytime <= BREAKFAST_END) and 0.2 or 0) + 0.1 then
            add(desires, "sweet pastry")
        end
        if rnd() < ((daytime <= BREAKFAST_END) and 0 or 0.2) then
            add(desires, "sandwich")
        end        
    end
    return desires
end

function make_customer()
    local e = make_ent("customer", OBJECT_SPRITES.customer, door.x + 2, door.y + 8)
    populate_table(e, "state=entering,state_timer=0,total_time=0,move_timer=10,oldx=0,oldy=-999,is_customer=true,status_timer=0,given=0,change=0")
    today_stats["customers"] += 1
    e.pal = split(rnd(CUST_PALS))
    e.pal[12] = rnd(split"1,2,3,4,5,12")
    local s = rnd(split"7,6,9,11")
    e.pal[6] = s
    if rnd() < 0.5 then
        e.pal[7] = s
    else
        e.pal[7] = rnd(split"7,6,9,10")
    end
    e.hair = rnd({{76,113,77},{78,114,79},{80,113,81},{82,115,83}}) --rnd(split"76,78,80,82")
    e.hc = rnd(split"10,1,2,2,4,4,9,6")
    if e.pal[15] == 2 or e.pal[15] == 4 then
        e.hc = 1--rnd(split"1,")
    end
    e.pal[4] = e.hc
    e.desires = generate_desires()
    e.parts[2] = make_spritepart(e, e.hair[1], e.hair[2], e.hair[3], 0, -2, 10)
    --e.parts[2] = make_spritepart(e, 82,115,83, 0, -2, 10)
    e.cats_seen = {}

    local _move = e.move
    e.move = function(self, x, y)
        self.oldx, self.oldy = self.x, self.y
        self.move_timer = 10
        _move(self, x, y)
    end
    e.set_status = function(self, text)
        -- smile ⁶:001400221c000000
        -- sad ⁶:0014001c22000000
        -- heart ⁶:143e3e1c08000000
        -- star ⁶:083e1c0814000000
        self.status_timer = 90
        self.status = text
    end
    e.set_state = function(self, state)
        self.state = state
        self.state_timer = 0
    end
    e.enter_line = function(self, tip)
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
        else
            self:leave(true)
        end        
    end
    e.leave = function(self, bad_time)
        self:set_state("leave")
        self:move(door.x - 4, door.y + 6)        
        if bad_time then
            self:set_status("\fc⁶:0014001c22000000")
            --stars = (stars * 0.95) \ 1
        end
    end
    e.update = function(self)
        --self.dir = {1,0}
        self.height = 0
        if self.move_timer > 0 then self.move_timer -= 1 end
        if self.state == "entering" then
            if self.state_timer > 60 then
                self:enter_line(true)
            end
        elseif self.state == "queued" then
            self.dir = {0, 1}
            if self.state_timer >= 300 and self.state_timer % 180 == 0 then
                self:set_status("⁶:0000000049000000")
            end
            if daytime > closing_ticks - 60 or self.state_timer >= 900 then
                self:leave(self.state_timer >= 900)
                next_customer()
            end
        elseif self.state == "leave" then
            self.dir = {0, -1}
            if self.state_timer > 30 then
                del(customers, self)
                del(ents, self)
            end
        elseif self.state == "seated" then
            self.height = 2
            if self.state_timer > 600 then
                self.seat.taken = false
                if self.total_time >= 1200 or rnd() < 0.35 then
                    self:leave()
                else
                    self.desires = generate_desires()
                    self:enter_line(true)
                end
            end
            if daytime > closing_ticks - 120 then
                self.seat.taken = false
                self:leave()
            end
        elseif self.state == "paid" then
            if self.state_timer > 10 then
                local seats = get_seats(true)
                if #seats > 0 and rnd() < 0.75 and daytime < closing_ticks - 120 then
                    self.seat = rnd(seats)
                    self.seat.taken = self
                    self:move(self.seat.x, self.seat.y + self.seat.dir[2] * 2)
                    self.dir = self.seat.dir
                    self:set_state("seated")
                else
                    self:leave()
                end
            end
        end
    end

    --e:set_status("\f8⁶:143e3e1c08000000 \f1fluffy")

    return e
end

function init_customers()
    customer_queue = {}
    customers = {}
    walkin_timer = 30
end

cat_check_index = 1
function update_customers()
    -- var
    if walkin_timer <= 0 and #customers < 5 and daytime < closing_ticks - 240 then
        local c = make_customer()
        add(customers, c)
        local factor = (stats["appeal"] \ 1 / 4 + 0.75)
        walkin_timer = (350 + rnd(300)) / factor \ 1
    end
    walkin_timer -= 1
    for i = 1, #customers do
        local c = customers[i]
        c.state_timer += 1
        c.total_time += 1
        c.status_timer = max(c.status_timer - 1, 0)
        if i == cat_check_index then
            for cat in all(cats) do
                if not contains(c.cats_seen, cat.name) then
                    local dx, dy = cat.x - c.x, cat.y - c.y
                    if abs(dx) < 10 and abs(dy) < 10 then
                        add(c.cats_seen, cat.name)
                        c:set_status("\f8⁶:143e3e1c08000000 \f1" .. cat.name)
                        add_star(c.x, c.y - 8)
                    end
                end
            end
        end
    end
    
    cat_check_index = cat_check_index % #customers + 1
end

function next_customer()  
    deli(customer_queue, 1)
    for c in all(customer_queue) do
        c:move(c.x, c.y + 9)
    end
end