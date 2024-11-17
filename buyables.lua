buyables = string_multitable([[
ind=1,sspr=24/13/7/14,title=chair,type=buy_floor,sprite=chair,price=15,description=always good to have more seating
ind=2,sspr=56/0/7/12,title=chair2,type=buy_floor,sprite=chair2,price=25
ind=3,img=103,title=couch 1,type=buy_floor,sprite=couch1,price=25,description=left side sectional
ind=4,img=104,title=couch 2,type=buy_floor,sprite=couch2,price=25,description=center sectional
ind=5,img=105,title=couch 3,type=buy_floor,sprite=couch3,price=25,description=right side sectional
ind=6,img=36,title=table,type=buy_floor,sprite=table,price=30,stat=appeal,stat_value=0.5,description=customers usually expect tables
ind=7,img=107,title=table2,type=buy_floor,sprite=table2,price=30,stat=appeal,stat_value=0.5,description=customers usually expect tables
ind=8,img=30,title=bookshelf,type=buy_floor,sprite=bookshelf,price=50,stat=max_cats,stat_value=0.25,description=cats might like to climb it
ind=9,img=88,title=counter,type=buy_floor,sprite=counter,price=20,is_counter=true
ind=10,img=106,title=plant,type=buy_floor,sprite=plant1,price=8,description=plant,stat=appeal,stat_value=0.1,hoppable=false
ind=11,img=53,title=register,type=buy_floor,price=100,sprite=register,is_counter=true,moveable=false
ind=12,img=127,title=auto-reg,type=autoreg,price=100,description=automatically run the register!
ind=13,img=84,title=drip machine,type=buy_floor,price=50,sprite=drip machine,is_counter=true,hoppable=false,menu=drip coffee
ind=14,img=116,sprite=cream,title=cream+sug,type=buy_floor,price=20,sprite=cream,stat=appeal,stat_value=0.25,description=self serve cream and sugar packets,is_counter=true
ind=15,img=86,sprite=grinder,title=grinder,type=buy_floor,price=35,sprite=grinder,fn=action_buy_grinder,description=raises drip coffee price +$1,is_counter=true
ind=16,img=97,sprite=pastries,title=pastries,type=buy_floor,price=40,sprite=pastries,menu=sweet pastry/savory pastry,description=adds pastries to the menu,is_counter=true
ind=17,img=52,sprite=espresso,title=espresso,type=buy_floor,price=100,sprite=espresso,stat=appeal,stat_value=0.5,menu=espresso,description=adds espresso to the menu,is_counter=true
ind=18,img=85,sprite=frother,title=frother,type=buy_floor,price=100,sprite=frother,stat=appeal,stat_value=1.0,menu=cappuccino/latte,requires=espresso,description=adds espresso milk drinks to the menu,is_counter=true
]])

function get_buyables(s)
    local o = {}
    for b in all(split(s)) do
        add(o, buyables[b])
    end
    return o
end