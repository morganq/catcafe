pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- catcafe
-- by morganquirk

cartdata("catcafe_0")

SPRITE_META_STR = "000008087f7f80800000080008087f7f78800000100008087f7f70800000180008087f7f68800000200008087f7f60800000280008087f7f58800000300008087f7f50800000380008087f7f48800000400008087f7f40800000480008087f7f38800000500008087f7f30800000580008087f7f28800000600008087f7f20800000680008087f7f18800000700008087f7f10800000780008087f7f08800000000808087f7f80780000080808087f7f78780000100808087f7f70780000180808057f7c687b0000200808057f7c607b0000280808057f7c587b0000300808057f7c507b0000380808057f7c487b0000400808057f7c407b0000480808057f7c387b0000180d070e7f7f000706061f0d070f7f7f00080606260d07097f7f000206062d0d0d167f7f000c0c0900100d0d7f7f807000000d10090b7f7f73700000001d03107f7f80630000031d0c107f7f7d6300000f1b0b0d7f7f716500003a0d0e0d7f7f01030b090f2805057f7f71580000142805077f7f6c580000192805067f7f6758000050080b0e7f7f010808055b080e0e7f7f0308070569080b0e7f7f010808057e75020b7f7f020b00007d75010b7f7f030b0000787905077f7f08070000717907077f7f0f0700003a1a0d0d7f7f01030a091a1c0d087f7f666400001e240d0d7f7f00030c092b240d0d7f7f00030c09002d0a197f7f000308150a2f0c0e7f7f765100001631090c7f7f000608056c7b05057f7f14050000557b04057f7f2b050000597b04057f7f270500005d7b05057f7f23050000627b05057f7f1e050000677b05057f7f19050000627605057f7f1e0a00001f310b0d7f7f614f000075080b0d7f7f010808044b760a0a7f7f350a0000467d05037f7f3a030000417d05037f7f3f0300003c7905077f7f44070000377905077f7f4907000075150b0d7f7f01080804347903077f7f4c0700002b7d09037f7f55030000"

#include util.lua
#include ent.lua
#include player.lua
#include customer.lua
#include state_game.lua
#include src.lua

__gfx__
00000000000024040000240400002404000024040000240400002404000024040000240400002404000000000000000000000000000024040000000000000000
00000000000044440000444400004444000044440000444400004444000044440000444400004444000024040000240400002404000044440000000000000000
0000240400004a4a00004a4a00004a4a00004a4a00004a4a00004a4a00004a4a00004a4a00004a4a00004444000044440000444400004a4a0000240400000000
0000444440004444400044444000444440004444400044444000444440004444400044444000444440004a4a40004a4a40004a4a400044444000444440002404
40444a4a4444422044444220444442204444422044444220444442204444422044444220444442204444444444444444444444444444422044444a4a44444444
44424444044444000444440004444400044424000444240004444400044444000444440004444400044442200444422004444220044444400444444404444a4a
04442220442020406420240006440450020640205400420004500240442002404400204004420400004240000042400000400060044000564420422044444444
04446460605050060055006005000600500060050606005006000600650000566500050606050060005606000056600000520000052000006050506065046220
00240400002404000024040000002404000024040000240400000400000004000006040000000400000111110000000011111000000011111000000011111000
00444400004444000044440040004444040044444000444400004a4400064a4400042a4400604a440018888810000011888881000001888881000001fffff100
004a4a40004a4a40004a4a4044424a4a44424a4a44424a4a60624440600424406004244060042440018888888100018888888810001888888810001fffffff10
40244400404422004044445044224444244244444442444444424a4444442a4444442a4444442a44018fffff81001888888f8810001881118810001fffffff10
4446250044424425444220006226222662462226644622266446244464462444644624446446244418fffffff810188888ffff10018818881881001fbfffbf10
0422400004444060044444000111110100000001111100111111111110011111111111100000000018fcfffcf8118188fffcff10018f18881f81001fbfdfbf10
0444000004440000044400601010101100000010101011ddddddddddd1144444444444410000000001fcfdfcf100101f8ffcffd1001ff888ff100001fffff100
0605000005200000052000001101011100000011111111ddddddddddd11444444444444100000000001fffff10000001ffffff100001ff8ff100001667f76610
ddddddddddddd5555555550010101011000000151f1511ddddddddddd11222222222222100000000019447449100000144444100001944444910016666766661
dfffffffffffd577777775001101011100000011f1f1114ddddddddd41144444444444410000000019999799991000019999910001999999999101f6667666f1
dffdddddddffd5777777750011111111000000151f151144444444444114444444444441000000001f9997999f1000001919910001f9999999f1001ccccccc10
dfdddddddddfd5777777750015fff51111111021111121222222222221122222222222210000000001ccc4ccc10000001f1c1000001c99999c100001cc1cc100
dfdddddddddfd577777775001fffff115fff51120002114444444444411444444444444100000000001cc1cc1000000001ccc1000001cc1cc100000111011100
dfdddddddddfd577777775001fffff11fffff1110001114cc2882bff411444444444444100000000001110111000000001111100000111011100000011111000
dfdddddddddfd577777775001fffff11fffff1000000014cc2882bff4101111111111110000000000000000000000000000000000000000000000001fffff100
dfdddddddddfd5777777750015fff511fffff1000000014cc2882bff410120000000021000000000000000000000000000000000000000000000001fffffff10
dfdddddddddfd57777777500211111215fff51000000014cc2882bff410120000000021000000000000000000000000000000000000000000000001fffffff10
dfdddddddddfd5777777750012000212111112000000014222222222410120000000021000000000000000000000000000000000000000000000001fffffff10
dffdddddddffd5555555550011000111200021000000014444444444410111111111110000000000000000000000000000000000000000000000001fffffff10
dfffffffffffd000022222220000000110001100000001498c22cb994114444444444410000000000000000000000000000000000000000000000001fffff100
ddddddddddddd000211111112011111111111110000001498c22cb99411444444444441000000000000000000000000000000000000000000000001666666610
2225555555555552111111111215555555555550000001498c2cb299411444444444441000000000000000000000000000000000000000000000016666666661
222ffffffffffff2111111111215555555555550000001498c2cb29941144444444444100000000000000000000000000000000000000000000001f6666666f1
242ffffffffffff21111111112155555555555500000014222222222411444444444441000000000000000000000000000000000000000000000001c66666c10
242ffffffffffff211111111121555555555555000000144444444444114444444444410000000000000000000000000000000000000000000000001cc1cc100
242ffffffffffff21111111112155555555555500000014111111111411444444444441000000000000000000000000000000000000000000000000111011100
242ffffffffffff21111111112111111111111100000011000000000110222222222220000000000000000000000000000000000000000000000000000000000
242ffffffffffff21111111112011111111111100000000000000000000122222222210000000000000000000000000000000000000000000000000000000000
242ffffffffffff21111111112000011111111111111111111111111000122222222210000000000000000000000000000000000000000000000000000000000
242ffffffffffff21111111112000044444444444444444444444444000121111111210000000000000000000000000000000000000000000000000000000000
242ffffffffffff21111111112000044444444444444444444444444000110000000110000000000000000000000000000000000000000000000000000000000
242ffffffffffff11111111111000014444444444444444444444444000000000000000000000000000000000000000000000000000000000000000000000000
242ffffffffffff66677776776777644444444444444444444444444000000000000000000000000000000000000000000000000000000000000000000000000
242ffffffffffff77767777676666614444444444444444444444444000000000000000000000000000000000000000000000000000000000000000000000000
242ffffffffffff66776776776777644444444444444444444444444000000000000000000000000000000000000000000000000000000000000000000000000
24222222222222277676666666676644444444444444444444444444000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111167676677766767622222222222222222222222222000000000000000000000000000000000000000000000000000000000000000000000000
11111111100000000000677760666012222222222222222222222222000000000000000000000000000000000000000000000000000000000000000000000000
44444444410000000000766670000012222222222222222222222222000000000000000000000000000000000000000000000000000000000000000000000000
44444444410000110000000000000012111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000
44444444410111871111000000000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4444444441166177166610007700000044f4fdfffd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444411666116666150777000004dfffdfffdf00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444411111111111111777111114fffdfffdff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
444444444115115551551017775bbb1fffdfffdfff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
244444444116666666661011115bbb14fdfffdfffd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1444444441166666666610155555551fdfffdfffdf00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1444444441166666666610166666661dfffdfffdff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1444444441165555555610161616161fffdfffdfff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1444444441165555555610166666661ffdfffdfffd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1444444441216666666120155555551fdfffdfffdf00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1444444441021111111200155555551dfffdfffdff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1444444441002222222000111111111fffdfffdfff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1444444441000000000000000000000ffdfffdfffd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
14444444410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
14444444410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
14444444410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01222222100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01222222100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01211112100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01100001100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100
00000000000000000000000000000000000000000000000000000000000000000000000000033333330000000000000000333330000000000000000000000710
00000000000000000000000000000000000000000000000000000000000000000000000000003003003000000000000000303030000000000000000000000771
00000000000000000000000000000000000000000000000000000000000000000000000000000300300300000000000000333330000000000000000000000771
00000000000000000000000000000000000000000000000000007773333333333000000000000300000330000000000000303030000000000777977777377771
00000000000000000000000000000000000000000000000000007873000330003000000000000300000300000000000000333330000000000779a97773337771
00000000000000000000000000000000000000000000000000007873333333333000000000000303000300cc000030033000300900090000199a999937377771
0123000000000000000000000000000000000000000000000000787000000000000000000000030000030c00c000333303003009999900111799999773337771
456700000000000000000000000000000000000000000600060077733303000033033300003030000003000cc333300303333339090901117779997777373761
89ab0000000000000000000000000000000000000000676067607873030333333303033333333333330000000300333303003009999901177779797773337610
cdef00000000000000000000000000000000000000067776777607030333300033330330003000000030000c0300300330003000999011777797779777377100

