OBJECT_SPRITES = string_multitable([[
customer=62/112/68/0/0/0
chair=27/27/27/0/0/0|29/28/99/0/0/5
bookshelf=30/30/30/0/0/0
table=36/98/36/0/0/0
register=53/53/53/0/0/0
drip machine=84/84/84/0/0/0
grinder=86/86/86/0/0/0
espresso=52/52/52/0/0/0
frother=85/85/85/0/0/0
pastries=97/97/97/0/0/0
counter=88/88/88/0/0/0
cabinet=101/100/102/0/0/0
couch1=103/103/103/0/0/0
couch2=104/104/104/0/0/0
couch3=105/105/105/0/0/0
plant1=106/106/106/0/0/0
table2=107/107/107/0/0/0
chair2=108/108/108/0/0/0|109/110/111/0/0/5
door=35/35/35/0/0/0
cream=116/116/166/0/0/0
]])

for os in all(OBJECT_SPRITES) do
    for k,v in pairs(os) do
        local t = {}
        local parts = split(v, "|")
        for part in all(parts) do
            add(t, split(part,"/"))
        end
        OBJECT_SPRITES[k] = t
    end
end