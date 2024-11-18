pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- viewer
-- by morganquirk

cartdata("catcafe_0")

SPRITE_META_STR = "0b000008087f7f01050502020b080008087f7f01050502020b100008087f7f01050502020b180008087f7f01050502020b200008087f7f01050502020b280008087f7f01050502020b300008087f7f01050502020b380008087f7f01050502020b400008087f7f01050502020b480008087f7f01050502020b500008087f7f01050502020b580008087f7f01050502020b600008087f7f01050502020b000808087f7f01050502020b080808087f7f01050602010b100808087f7f00050602020b700008087f7f01050502020b780008087f7f01050502020b680008087f7f01050502020b180808057f7f01020502020b200808057f7f01020502020b280808057f7f01020502020b300808057f7f01020502020b380808057f7f01020502020b400808057f7f01020502020b480808057f7f01020502020b181207097f7f00030605010b1f0d070b7f7d000c0600070b180d07057f8100020600040b2d0d0d167f7f000f0c06070400100d0d040d10090b04001d031004031d0c100b0f1b0b0d7f7f00000a0a020b3a0d0e0d7f7f00040d0802040f280505041428050704192805060b51080b0e7f7f01090804050b5c080e0e7f7f03090704050b6a080b0e7f7f0109080405047e75020b047d75010b047879050704717907070b3a1a0d0d7f7f01040b0802041a1c0d080b1e240d0d7f7f00040c08020b2b240d0d7f7f00040c08020b002d0a0f7f7f0004090a020b0a2f0c0e7f7f00080905020b1631090c7f7e0007080502046c7b050504557b040504597b0405045d7b050504627b050504677b05050462760505041f310b0d0b75080b0d7f7f0108080405044b760a0a04467d050304417d0503043c79050704377905070b75150b0d7f7f01080804050434790307042b7d090304267d0503045d760505041f7a070604187a07060b003c0a0f7f7f0004090a020675230b067f7e0475290b05046a230b05066a280b087f7c065f230b057f7f065f280b057f7f0654230b097f7c06542c0b0a7f7b0b38270b0e7f7f01080805060b0a3d08097f7f00050703020b123d070c7f7e010a04020504480d08080b2a310d0d7f7f00040c08020476680a0d046c680a0d0462680a0d0458680a0d044e680a0d0444680a0d043a680a0d0430680a0d0b193e08077f7f00040702020b48160a107f7f0004090b020b261207057f7b00080600040b3943090e7f7f00040709020b42430b0b7f7f00040a06020b4d430b0b7f7f00040a06020b5843090b7f7f00050805020b6143070b7f7f00050605020b6843090b7f7f00050805020b3735070e7f7f010a0403050b43270b107f7f00060a09050b714a07057f7f00000604050b714307077f7f00020604010b794307077f7f00020604010b794a07067f7f00010604010b6b160a0d7f7f0008080405065f2d0b067f7d066a300d087f7b0654360b0a7f7a06213e04077f7d04077711090b004b0b0e7f7f01090804050b0b4b0b0e7f7f01090804050b164b0b0e7f7f01090704050b214b0b0e7f7f01090804050b00590e0e7f7f03090704050b0f590e0e7f7f03090704050b52160b0d7f7f01080804050b5d160b0d7f7f0108080405041f7307070b253e090c7f7f000608050204597604050467760505042674070904286c08080b2e3e090c7f7f000608050204424e0f0f"

#include util.lua
#include viewer.lua

__gfx__
00000000000024040000240400002404000024040000240400002404000024040000240400002404000000000000000000000000000024040000000000000000
00000000000044440000444400004444000044440000444400004444000044440000444400004444000024040000240400002404000044440000000000000000
0000240400004a4a00004a4a00004a4a00004a4a00004a4a00004a4a00004a4a00004a4a00004a4a00004444000044440000444400004a4a0000240400000000
0000444440004444400044444000444440004444400044444000444440004444400044444000444440004a4a40004a4a40004a4a400044444000444440002404
40444a4a4444422044444220444442204444422044444220444442204444422044444220444442204444444444444444444444444444422044444a4a44444444
44424444044444000444440004444400044424000444240004444400044444000444440004444400044442200444422004444220044444400444444404444a4a
04442220442020406420240006440450020640205400420004500240442002404400204004420400004240000042400000400060044000564420422044444444
04446460605050060055006005000600500060050606005006000600650000566500050606050060005606000056600000520000052000006050506065046220
00240400002404000024040000002404000024040000240400000400000004000006040000000400000011111000000001111100000001111100000011111000
00444400004444000044440040004444040044444000444400004a4400064a4400042a4400604a440001888881000001188888100000188888100001fffff100
004a4a40004a4a40004a4a4044424a4a44424a4a44424a4a60624440600424406004244060042440001888888810001888888881000188888881001fffffff10
40244400404422004044445044224444244244444442444444424a4444442a4444442a4444442a440018fffff81001888888f881000188111881001fffffff10
44462500444244254442200062262226624622266446222664462444644624446446244464462444018fffffff810188888ffff1001881888188101fbfffbf10
04224000044440600444440001111100000000000000001111111111100111111111111044400000018fcfffcf8118188fffcff10018f18881f8101fbfdfbf10
0444000004440000044400601010101010000000000001ddddddddddd11444444444444140000000001fcfdfcf100101f8ffcffd1001ff888ff10001fffff100
0605000005200000052000001101011110000000000001ddddddddddd112222222222221440000000001fffff10000001ffffff100001ff8ff10001667f76610
ddddddddddddd555555555001010101110000000000001ddddddddddd11444444444444144224040001979997910000011777710000197777791016666766661
dfffffffffffd5777777750011010111100000000000014ddddddddd41144444444444414424444001997777799100001999971000199999999911f6667666f1
dffdddddddffd577777775001111111110000001111101444444444441144444444444416424a4a401f9777779f10000019fcc10001f9999999f101ccccccc10
dfdddddddddfd5777777750015fff511100000101010112222222222211222222222222100424440001c77777c100000001cc1000001c99999c10001cc1cc100
dfdddddddddfd577777775001fffff110000001101011144444444444114444444444441000462500001cc1cc1000000001cc10000001cc1cc10000111011100
dfdddddddddfd577777775001fffff11000000101010114cc2882bff411222222222222100000000000111011100000000111110000011101110000011111000
dfdddddddddfd577777775001fffff11000000110101114cc2882bff4101111111111110011111111000011111000000111110000000011111000001fffff100
dfdddddddddfd5777777750015fff511000000000000014cc2882bff41012000000002101424444241001888881000018888810000001fffff10001fffffff10
dfdddddddddfd5777777750021111120000000000000014cc2882bff4101200000000210142444424101888888810018888888100001fffffff1001fffffff10
dfdddddddddfd577777775001200021000000000000001422222222241012000000002101424444241018fffff810018fffff8100001fffffff1001fffffff10
dffdddddddffd55555555500110001100000000000000144444444444101111111111100142444424118fffffff8118fffffff810001ffffbff1001fffffff10
dfffffffffffd000022222220000000000000000000001498c22cb994104444444444410142444424118fcfffcf8118fcfffcf810001ffffbffd1001fffff100
ddddddddddddd000211111112011111111111110000001498c22cb994104444444444410142444424101fcfdfcf1001fcfdfcf1000001ffffff1011666666610
2225555555555552111111111215555555555550000001498c2cb29941044444444444101424444241001fffff100001fffff100000016666710016666666661
222ffffffffffff2111111111215555555555550000001498c2cb29941044444444444101424444241019799979100197999791000001661671001f6666666f1
242ffffffffffff2111111111215555555555550000001422222222241044444444444101424444241019117119100191f1f1910000001661610001c66666c10
242ffffffffffff2111111111215555555555550000001444444444441044444444444101424444241019cfcfc910019ccccc9100000001cfcc10001cc1cc100
242ffffffffffff211111111121555555555555000000141111111114104444444444410122222222101111c1111000111c111000000000111c1000111011100
242ffffffffffff21111111112111111111111100000011000000000110222222222221001111111100011101110000111011100000000000011000000000000
242ffffffffffff21111111112011111111111100000000000000000000222222222210001200002100000000000000000000000000000111000000000000000
242ffffffffffff21111111112000011111111111111111111111111000222222222210001200002100000011111000000111110000001141100000011111000
242ffffffffffff21111111112000044444444444444444444444444000111111111110001200002100000144444100001444441000014444410000144444100
242ffffffffffff21111111112000044444444444444444444444444000110000000110000000000000001444444410014444444100144444441001444444410
242ffffffffffff11111111111000014444444444444444444444444000111110000001111100000000014440004441004400044000044000440000400444400
242ffffffffffff66677776776777644444444444444444444444444001111111000014444410000000014000000041000000000000000000000000000044400
242ffffffffffff77767777676666614444444444444444444444444006111116000144444441000000014000000041000111110000001111100000000000000
242ffffffffffff66776776776777644444444444444444444444444116766556111444444444100000014000000041001444441000014444410000011111000
24222222222222277676666666676644444444444444444444444444106766556011444444444100000014000000041014444444100144414441000144444100
11111111111111167676677766767622222222222222222222222222016766556101444444444100000000000000000004444444000044141440001444444410
11111111100000000000677760666012222222222222222222222222006766556001244444442100000000011111000000000000000004141400000444444400
44444444410000000000766670000012222222222222222222222222006766556000124444421000000000144444100000111110000000141000000000000000
44444444410000000000000000000012111111111111111111111111006716556000012222210000000001444444410001444441000000010000000000000000
444444444100011000000000000000110000000000000000000000000067615b6000001111100000000014444444441014444444100000111110000000000000
4444444441651871556000007700000044f4fdfffd44444444444440006766586000000010000000000014444444441014400000000001444441000000000000
44444444416617716665000777000004dfffdfffdf44444444444440006761556000000010000000000014444444441004000000000014444444100000000000
44444444416661166661001777111114fffdfffdff44444444444440000711150000000010000000000014444444441000000000000144400004000000000000
444444444177777777700017775bbb1fffdfffdfff44444444444440000011100000000414000000000014044444041000000000000144000000000000000000
244444444151155111500011115bbb14fdfffdfffd4444444444444000b300000000000444000000000000440004400000000000001400000000000000000000
1444444441555555155000155555551fdfffdfffdf4444444444444b30b300000000000111000000000000000000000000000000001400000000000000000000
0222222220555555555000166666661dfffdfffdff4444444444444b30bbbb000000000000000000000000111110000000000000000100000000000000000000
0122222210655555556000161616161fffdfffdfff4444444444444030b033000000000000000000000001444441000000000000000000000000000000000000
0122222210611111116000166666661ffdfffdfffd222222222222200b3000000000000000000000000014444444100000000000000000000000000000000000
0121111210611111116000155555551fdfffdfffdf22222222222220bb0bb0000000000000000000000014444000000000000000000000000000000000000000
0110000110566666665000155555551dfffdfffdff222222222222203bb330000000000000000000000014440000000000000000000000000000000000000000
1444444441055555550000111111111fffdfffdfff2222222222222000b000000000000000000000000014400000000000000000000000000000000000000000
1444444441000066000011100000000ffdfffdfffd0110000000110001b100000000000000000000000014400000000000000000000000000000000000000000
14444444410006006001000107777777707700077000000000000000013100000000000000000000000001440000000000000000000000000000000000000000
14444444410000006010222017000000706660777000000000000000011100000000000000000000000001400000000000000000000000000000000000000000
144444444100000060712221777aa7aa706601777111111111111110022200000000000000000000000000000000000000000000000000000000000000000000
144444444105550565721112779495497011017775bbb117775aaa10022200000000000000000000000000000000000000000000000000000000000000000000
144444444165550565072227079945997000011115bbb111115aaa10011100000000000000000000000000000000000000000000000000000000000000000000
14444444410616055500727005555555576061555555511555555510011111111011111111111111111111110011111111111111111111100011111000000011
144444444106150111006751011111111110113333333113333333100144444410144444444411444444444101111111111111111111111101fffff100000151
144444444101110000006651000000000000013b333b3113b333b310014444441114444444441144444444411111111111111111111111111151015100111151
02222222200000000000685000000000000001333333311b3b3b3b10014444441114444444441144444444411111fffffffffffffffff11111fffff101fff151
012222221000000000016651000000000000013bbbbb31133333331001444444101444444444114444444441111fffffffffffffffffff1111fffff101fff151
0122222210000000000111110000000000000133333331133333331001444444101444444444114444444441111fffffffffffffffffff111155555101555551
012111121000000000000000000000000000011111111111111111100144444410122222222211222222222115515fff5ffffff5ffff51551011111000111110
01100001100000000000000000000000000000000000000000000000014444441112112221121122222222211551111111111111111111551000100000111110
00011111000000111110000001111100000011111000000000000000014444441112222222221122222222211555555555555555555555551000100001fffff1
00188888100001888881000018888810000188888100000000000000012222221012111111121121111111211555555555555555555555551004140001f111f1
01888888810018888888100188888881001888888810000000000000012222221012000000021120000000211100000000000000000000011004440001155511
018fffff810018fffff810018811188100188111881000000000000001222222100000000066000000000000000000000000000000000000000111000151f151
18fffffff8118fffffff811881888188118818881881000000000000012111121000066006666000000000000000000000000000000000000000000000111110
18fcfffcf8118fcfffcf8118f18881f8118f18881f81000000000000012000021000666606666000000000000000000000000000000000000000000000000000
01fcfdfcf1001fcfdfcf1001ff888ff1001ff888ff10000000000000000000000000666600660000000000000000000000000000000000000000000000000000
011fffff100001fffff110001ff8ff111111ff8ff100000000000000000000000000066000000066000000000000000000000000000000000000000000000000
19979997910019799979910017777799119977777100000000000000000000000000000000000666600000000000000000000000000000000000000000000000
11977777110011777779110199999991001999999910000000000000000000000000006666000666600000000000000000000000000000000000000000000000
01977771f1001f177779101f999999910019999999f1000000000000000000000006666666600066000000000000000000000000000000000000000000000000
001117771000017771110001c99999c0000c99999c10000000000000000000000066666666600000000000000000000000000000000000000000000000000000
0001111100000011111000001111cc100001cc111100000000000000000000000066666666600660000000000000000000000000000000000000000000000000
00011000000000000110000000001110000111000000000000000000000000000066666666606666000000000000000000000000000000000000000000000000
00000111110000000000111110000000000000000000000000000000000000000006666666006666000000000000000000000000000000000000000000000000
00011888881000000011888881000000000000000000000000000000000000000000066666000660000000000000000000000000000000000000000000000000
00188888888100000188888888100000000000000000000000000000000000000000066666000000000000000000000000000000000000000000000000000000
01888888f88100001888888f88100000000000000000000000000000000000000000006660000000000000000000000000000000000000000000000000000000
0188888ffff10000188888ffff100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
18188fffcff100018188fffcff100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101f8ffcffd1000101f8ffcffd10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001ffffff100000001ffffff100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001997771000000019777771000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0001119199f100000019199971100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000111cc19100000001f11ccc1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001cc11c11000000011c11cc110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001c10111000000001c0001c100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001111010000000001110001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000c000000000000000000c4224444424cf42ccccc24c44c00000cc44c0000c44c0000000c
00000000000000000000000000000000000000000000000000ccc000cf000cc00000c00000cc44242222442cfff2244424c444ccccc4cff4c00c2f44ccccccc2
0000000000000000000000000000000000000000000000000c4f4c0c4f000c4c00004c00cc4c2442b8b224c0cf24444224c4222444224fffc00c2f4442244422
0000000000000000000000000000000000000000000000000ccff4c4ff000cf4c00c44cc44424242b8bb22c0c244444442c2244444442f442cc22f4444244222
0000000000000000000000000000000000000000c777cc70c4cf4444ff000cf44cc244224444224bb8b244c0c211444114c2411141114442442244448b242b82
0000000000000000000000000000000000000000c777cc7cc4c4844842000c444224422444444244bbb442c0c1bb441bb42418b1418b24444444444b8b442b8b
0000000000000000000000000000000000000000c777777c44c4bf4b2200c4442222c244444bbb44444422c04b8b44b8b4c24bb444bb24441114112bbb442bbb
0000000000000000000000000000000000000000cccccccc4cc472742200c442bb22c22bbb4b8bff444242c0444ff4444424444fff442441b8b48b2244fff211
0000000000000000000000000000000000000000ccc77ccc4ccb27272b00c42b8b42424b8b4444f7744422c0447f774444c44244f4424224444ff424447f7721
0000000000000000000000000000000000000000ccc77cccc0c4b777b2cc24444444c424444f4417774222c02771771144422444144424444442244447717722
0000000000000000000000000000000000000000cccccccc0c444bbb2244242bb4f10c4444ff417112222c00c217117772244411411422444444244447171772
00000000000000000000000000000000ccccc000ccccccccc4444422224f22b8b4f10fcf4441142222244c000c2777772c422444444422244422224471777177
0000000000000000000000000000000cc7c7cc000bbb00004444422222ccc22221120c424114404444444c0000c27222c0c222222224222244444c7777777777
0000000000000000000000000000000ccc7ccc000bbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000100
0000000000000000000000000000000cc7c7cc00bb1bb00000000000000000000000000000033333330000000033000000444448000800000000000000000710
00000003333333333333333300000000ccccc000bb1bb00000000000000000000000000000003003003000000300300100404040808000000000000000000771
000000033773777373337333000000000ccc000bb1bb000000000000000000000000000000000300300300000300301110444440080000000000000000000771
0000000373337333733373330000000000c0000bb1bb000000007773333333333000000000000300000330000033000100404040808000000000900077377771
00000003777377337333733308888800ccccc0bbbbb0000000007773000330003000000000000300000300000033000000444448000800000009a90073337771
0000000333737333733373338877788cc7c7ccbb1bb0000000007773333333333000000000000303000300cc000030033000300900090000199a999937377771
0123000377337773777377738878788ccc7ccc0bbb0000000000777000000000000000000000030000030c00c000333303003009999900111099999073337771
4567000333333333333333338877788cc7c7cc00c0000600060077733303000033033300003030000003000cc333300303333339090901117009990077373761
89ab0000000000333000000018888811ccccc10ccc00676067607773030333333303033333333333330000000300333303003009999901177009090073337610
cdef0000000000030000000001111100111110ccccc67776777607030333300033330330003000000030000c0300300330003000999011777090009077377100

