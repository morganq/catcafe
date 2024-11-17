pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- mem
-- by morganquirk

cartdata("catcafe_0")

for i = 0, 0xff do
    printh(tostr(i,1) .. ": " .. peek(0x5e00 + i))
end