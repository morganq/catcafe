pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- catcafe
-- by morganquirk

cartdata("catcafe_0")

SPRITE_META_STR = "0b004b0a0a7f7f02070502020b0a4b0a0a7f7f02070502020b144b0a0a7f7f02070502020b1e4b0a0a7f7f02070502020b284b0a0a7f7f02070502020b324b0a0a7f7f02070502020b3c4b0a0a7f7f02070502020b464b0a0a7f7f02070502020b504b0a0a7f7f02070502020b594b0b0a7f7f03070502020b644b0a0a7f7f02070502020b6e4b0a0a7f7f02070502020b005f0a0a7f7f02070502020b00550a0a7f7f02070502020b0a550a0a7f7f02070502020b14550a0a7f7f02070502020b0a5f0a0a7f7f02070502020b145f0a0a7f7f02070502020b64550a0a7f7f02070502020b1e550a077f7f02040502020b28550a077f7f02040502020b32550a077f7f02040502020b3c550a077f7f02040502020b46550a077f7f02040502020b50550a077f7f02040502020b5a550a077f7f02040502020b180d07097f7f00030605010b1f0d070b7f7d000c0600070b260d07057f8100020600040b2d0d0d167f7f000f0c06070400100d0d040d10090b04001d031004031d0c100b0f1b0b0d7f7f00000a0a020b3a0d0e0d7f7f00040d0802040f280505041428050704192805060b50080b0e7f7f01090804050b5b080e0e7f7f03090704050b69080b0e7f7f0109080405047e75020b047d75010b047879050704717907070b3a1a0d0d7f7f01040b0802041a1c0d080b1e240d0d7f7f00040c08020b2b240d0d7f7f00040c08020b002d0a0f7f7f0004090a020b0a2f0c0e7f7f00080905020b1631090c7f7e0007080502046c7b050504557b040504597b0405045d7b050504627b050504677b05050462760505041f310b0d0b75080b0d7f7f0108080405044b760a0a04467d050304417d0503043c79050704377905070b75150b0d7f7f01080804050434790307042b7d090304267d0503045d760505041f7a070604187a07060b003c0a0f7f7f0004090a020475220b060475280b05046a220b05046a270b08045f220b05045f270b050454220b0904542b0b0a0b38270b0e7f7f01080805060b0a3d08097f7f00050703020b123d070c7f7e010a0402050b6e550a0a7f7f02070502020b2a310d0d7f7f00040c08020476680a0d046c680a0d0462680a0d0458680a0d044e680a0d0444680a0d043a680a0d0430680a0d0b193e08077f7f00040702020b48160a107f7f0004090b020b261207057f7b00080600040b0000090e7f7f00040709020b09000b0b7f7f00040a06020b14000b0b7f7f00040a06020b1f00090b7f7f00050805020b2800070b7f7f00050605020b2f00090b7f7f00050805020b3735070e7f7f010a0403050b43270b107f7f00060a09050b3e3e07057f7f00000604050b3e3707077f7f00020604010b453707077f7f00020604010b4c3707077f7f0002060401"

#include util.lua
#include viewer.lua

__gfx__
11111111011111111111111111111110011111111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000
14444441014444444441144444444410111111111111111111111110000000000000000000000000000000000000000000000000000000000000000000000000
14444441114444444441144444444411111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000
14444441114444444441144444444411111fffffffffffffffff1111000000000000000000000000000000000000000000000000000000000000000000000000
1444444101444444444114444444441111fffffffffffffffffff111000000000000000000000000000000000000000000000000000000000000000000000000
1444444101444444444114444444441111fffffffffffffffffff111000000000000000000000000000000000000000000000000000000000000000000000000
144444410122222222211222222222115515fff5ffffff5ffff51551000000000000000000000000000000000000000000000000000000000000000000000000
14444441112112221121122222222211551111111111111111111551000000000000000000000000000000000000000000000000000000000000000000000000
14444441112222222221122222222211555555555555555555555551000000000000000000000000000111110000000011111000000011111000000011111000
122222210121111111211211111112115555555555555555555555510000000000000000000000000018888810000011888881000001888881000001fffff100
12222221012000000021120000000211100000000000000000000011000000000000000000000000018888888100018888888810001888888810001fffffff10
12222221000000000000000000000000000000000000000000000000000000000000000000000000018fffff81001888888f8810001881118810001fffffff10
1211112100000000000000000000000000000000000000000000000000000000000000000000000018fffffff810188888ffff10018818881881001fbfffbf10
1200002100000000000000001111111000000001111100111111111110011111111111100000000018fcfffcf8118188fffcff10018f18881f81001fbfdfbf10
00000000000000000000000015fff51010000010101011ddddddddddd1144444444444410000000001fcfdfcf100101f8ffcffd1001ff888ff100001fffff100
0000000000000000000000001fffff1110000011010111ddddddddddd11222222222222100000000001fffff10000001ffffff100001ff8ff100001667f76610
ddddddddddddd555555555001fffff1110000010101011ddddddddddd11444444444444100000000019799979100000177777100001977777910016666766661
dfffffffffffd577777775001fffff11100000110101114ddddddddd41144444444444410000000019977777991000019997710001999999999101f6667666f1
dffdddddddffd5777777750015fff5111000000111110144444444444114444444444441000000001f9777779f1000001919710001f9999999f1001ccccccc10
dfdddddddddfd577777775002111112110000010101011222222222221122222222222210000000001c77777c10000001f1c1000001c99999c100001cc1cc100
dfdddddddddfd5777777750012000211000000110101114444444444411444444444444100000000001cc1cc1000000001ccc1000001cc1cc100000111011100
dfdddddddddfd5777777750011000111000000101010114cc2882bff411222222222222100000000001110111000000001111100000111011100000011111000
dfdddddddddfd5777777750000000001000000110101114cc2882bff4101111111111110011111111000000000000000000000000000000000000001fffff100
dfdddddddddfd5777777750000000001000000000000014cc2882bff410120000000021014244442410000000000000000000000000000000000001fffffff10
dfdddddddddfd5777777750000000000000000000000014cc2882bff410120000000021014244442410000000000000000000000000000000000001fffffff10
dfdddddddddfd5777777750000000000000000000000014222222222410120000000021014244442410000000000000000000000000000000000001fffffff10
dffdddddddffd5555555550000000000000000000000014444444444410111111111110014244442410000000000000000000000000000000000001fffffff10
dfffffffffffd000022222220000000000000000000001498c22cb994104444444444410142444424100000000000000000000000000000000000001fffff100
ddddddddddddd000211111112011111111111110000001498c22cb99410444444444441014244442410000000000000000000000000000000000001666666610
2225555555555552111111111215555555555550000001498c2cb299410444444444441014244442410000000000000000000000000000000000016666666661
222ffffffffffff2111111111215555555555550000001498c2cb29941044444444444101424444241000000000000000000000000000000000001f6666666f1
242ffffffffffff21111111112155555555555500000014222222222410444444444441014244442410000000000000000000000000000000000001c66666c10
242ffffffffffff211111111121555555555555000000144444444444104444444444410142444424100000000000000000000000000000000000001cc1cc100
242ffffffffffff21111111112155555555555500000014111111111410444444444441012222222210000000000000000000000000000000000000111011100
242ffffffffffff21111111112111111111111100000011000000000110222222222221001111111100000000000000000000000000000111000000000000000
242ffffffffffff21111111112011111111111100000000000000000000222222222210001200002100000011111000000111110000001141100000011111000
242ffffffffffff21111111112000011111111111111111111111111000222222222210001200002100000144444100001444441000014444410000144444100
242ffffffffffff21111111112000044444444444444444444444444000111111111110001200002100001444444410014444444100144444441001444444410
242ffffffffffff21111111112000044444444444444444444444444000110000000110000000000000000440004400004400044000044000440000400444400
242ffffffffffff11111111111000014444444444444444444444444000111110000001111100000000014000000041000000000000000000000000000044400
242ffffffffffff66677776776777644444444444444444444444444001111111000014444410000000014000000041000111110000001111100000000000000
242ffffffffffff77767777676666614444444444444444444444444006111116000144444441000000014000000041001444441000014444410000011111000
242ffffffffffff66776776776777644444444444444444444444444116766556111444444444100000014000000041014444444100144414441000144444100
24222222222222277676666666676644444444444444444444444444106766556011444444444100000000000000000004444444000044141440001444444410
11111111111111167676677766767622222222222222222222222222016766556101444444444100000000011111000000000000000004141400000444444400
11111111100000000000677760666012222222222222222222222222006766556001244444442100000000144444100000000000000000141000000000000000
44444444410000000000766670000012222222222222222222222222006766556000124444421000000001444444410000000000000000010000000000000000
44444444410000000000000000000012111111111111111111111111006716556000012222210000000014444444441000000000000000000000000000000000
444444444100011000000000000000110000000000000000000000000067615b6000001111100000000014444444441000000000000000000000000000000000
4444444441651871556000007700000044f4fdfffd01111111111100006766586000000010000000000014444444441000000000000000000000000000000000
44444444416617716665000777000004dfffdfffdf14444444444410006761556000000010000000000014444444441000000000000000000000000000000000
44444444416661166661001777111114fffdfffdff14444444444410000711150000000010000000000014044444041000000000000000000000000000000000
444444444177777777700017775bbb1fffdfffdfff14444444444410000011100000000414000000000000440004400000000000000000000000000000000000
244444444151155111500011115bbb14fdfffdfffd1444444444441000b300000000000444000000000000000000000000000000000000000000000000000000
1444444441555555155000155555551fdfffdfffdf1444444444441b30b300000000000111000000000000000000000000000000000000000000000000000000
0222222220555555555000166666661dfffdfffdff1444444444441b30bbbb011111000000110000000000000000000000000000000000000000000000000000
0122222210655555556000161616161fffdfffdfff1444444444441030b0331fffff100001510111110000000000000000000000000000000000000000000000
0122222210611111116000166666661ffdfffdfffd022222222222000b3000151015101111511fffff1000000000000000000000000000000000000000000000
0121111210611111116000155555551fdfffdfffdf01222222222100bb0bb01fffff11fff1511f111f1000000000000000000000000000000000000000000000
0110000110566666665000155555551dfffdfffdff012222222221003bb3301fffff11fff1511155511000000000000000000000000000000000000000000000
1444444441055555550000111111111fffdfffdfff0121111111210000b00015555511555551151f151000000000000000000000000000000000000000000000
1444444441000066000011100000000ffdfffdfffd0110000000110001b100011111001111100111110000000000000000000000000000000000000000000000
14444444410006006001000107777777700000000000000000000000013100000100000000000000000000000000000000000000000000000000000000000000
14444444410000006010222017000000700000000000000000000000011100000100000000000000000000000000000000000000000000000000000000000000
144444444100000060712221777aa7aa700000000000000000000000022200004140000000000000000000000000000000000000000000000000000000000000
14444444410555056572111277949549700000000000000000000000022200004440000000000000000000000000000000000000000000000000000000000000
14444444416555056507222707994599700000000000000000000000011100001110000000000000000000000000000000000000000000000000000000000000
14444444410616055500727005555555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
14444444410615011100675101111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
14444444410111000000665100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02222222200000000000685000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01222222100000000001665100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01222222100000000001111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01211112100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01100001100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000011010000001101000000110100000011010000001101000000110100000011010000001101000000110100000000000000000000000000000
00000000000000124141000012414100001241410000124141000012414100001241410000124141000012414100001241410000011010000001101000000000
00000110100000144441000014444100001444410000144441000014444100001444410000144441000014444100001444410000124141000012414100000000
0000124141010014a4a1010014a4a1010014a4a1010014a4a1010014a4a1010014a4a1010014a4a1010014a4a1010014a4a10100144441010014444100000000
0101144441141114444114111444411411144441141114444114111444411411144441141114444114111444411411144441141114a4a1141114a4a100000000
141444a4a11444442210144444221014444422101444442210144444221014444422101444442210144444221014444422101444444441144444444100000000
14442444410144444100014444410001444441000144424100014442410001444441000144444100014444410001444441000144442210014444221000000000
01444222101442121410164212410001644145100121641210154114210001451124101442112410144112141001442141000014241100001424110000000000
01444646101615151161011551161001511161001510161151016161151001610161001651001561165101516101615116100015616100001566100000000000
00111111000101010010000110010000100010000100010010001010010000100010000110000110011000101000101001000001101000000111000000000000
00011010000001101000000110100000000110100000011010000001101000000010000000001000000010100000000010000000011010000010000000000000
00124141000012414100001241410001001241410010124141010012414100000141100000114110000161411000010141100000124141000141000000000000
001444410000144441000014444100141114444101411444411411144441010114a441010164a441010142a441011614a4410000144441001410000000000000
0114a4a4100114a4a4100114a4a410144424a4a1144424a4a1144424a4a11616244410161142441016114244101611424410010014a4a1001441110000000000
141244410014144221101414444510144224444112442444411444244441144424a441144442a441144442a441144442a4411411144441001442241000000000
14446251001444244251144422110016226222611624622261164462226116446244411644624441164462444116446244411444442210011442444100000000
0142241000014444161001444441000111111110011111111001111111100111111110011111111001111111100111111110144444441016424a4a4100000000
01444100000144410100014441161000000000000000000000000000000000000000000000000000000000000000000000000144111561011424441000000000
01615100000152100000015210010000000000000000000000000000000000000000000000000000000000000000000000000152100110000146251000000000
00101000000011000000001100000000000000000000000000000000000000000000000000000000000000000000000000000011000000000011110000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000110100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001241410000011010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01001444410100124141010001101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
141114a4a11411144441141112414100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1444444441144444a4a1144444444100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01444422100144444441014444a4a100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00141116101442142210144444444100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00152101001615151610165146221000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000110000001010101000110111100000000000000000000000000000c000000000000000000c4224444424cf42ccccc24c44c00000cc44c0000c44c0000000c
00000000000000000000000000000000000000000000000000ccc000cf000cc00000c00000cc44242222442cfff2244424c444ccccc4cff4c00c2f44ccccccc2
0000000000000000000000000000000000000000000000000c4f4c0c4f000c4c00004c00cc4c2442b8b224c0cf24444224c4222444224fffc00c2f4442244422
0000000000000000000000000000000000000000000000000ccff4c4ff000cf4c00c44cc44424242b8bb22c0c244444442c2244444442f442cc22f4444244222
000000000000000000000000000000000000000000000000c4cf4444ff000cf44cc244224444224bb8b244c0c211444114c2411141114442442244448b242b82
000000000000000000000000000000000000000000000000c4c4844842000c444224422444444244bbb442c0c1bb441bb42418b1418b24444444444b8b442b8b
00000000000000000000000000000000000000000000000044c4bf4b2200c4442222c244444bbb44444422c04b8b44b8b4c24bb444bb24441114112bbb442bbb
0000000000000000000000000000000000000000000000004cc472742200c442bb22c22bbb4b8bff444242c0444ff4444424444fff442441b8b48b2244fff211
0000000000000000000000000000000000000000000000004ccb27272b00c42b8b42424b8b4444f7744422c0447f774444c44244f4424224444ff424447f7721
000000000000000000000000000000000000000000000000c0c4b777b2cc24444444c424444f4417774222c02771771144422444144424444442244447717722
0000000000000000000000000000000000000000000000000c444bbb2244242bb4f10c4444ff417112222c00c217117772244411411422444444244447171772
000000000000000000000000000000000000000000000000c4444422224f22b8b4f10fcf4441142222244c000c2777772c422444444422244422224471777177
0000000000000000000000000000000000000000000000004444422222ccc22221120c424114404444444c0000c27222c0c222222224222244444c7777777777
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100
00000000000000000000000000000000000000000000000000000000000000000000000000033333330000000000000000333330000000000000000000000710
00000000000000000000000000000000000000000000000000000000000000000000000000003003003000000000000100303030000000000000000000000771
00000000000000000000000000000000000000000000000000000000000000000000000000000300300300000000001110333330000000000000000000000771
00000000000000000000000000000000000000000000000000007773333333333000000000000300000330000000000100303030000000000000900077377771
00000000000000000000000008888800ccccc0000000000000007773000330003000000000000300000300000000000000333330000000000009a90073337771
0000000000000000000000008877788cc7c7cc000000000000007773333333333000000000000303000300cc000030033000300900090000199a999937377771
0123000000000000000000008878788ccc7ccc00000000000000777000000000000000000000030000030c00c000333303003009999900111099999073337771
4567000000000000000000008877788cc7c7cc00c0000600060077733303000033033300003030000003000cc333300303333339090901117009990077373761
89ab0000000000000000000018888811ccccc10ccc00676067607773030333333303033333333333330000000300333303003009999901177009090073337610
cdef0000000000000000000001111100111110ccccc67776777607030333300033330330003000000030000c0300300330003000999011777090009077377100

