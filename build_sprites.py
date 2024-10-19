import json
import shutil
from PIL import Image

palette = "0XX34X6789abXXefXX1X2X5XXXXXcXXd"

#SPRITE_META_STR = "000008087f7f80800000080008087f7f78800000100008087f7f70800000180008087f7f68800000200008087f7f60800000280008087f7f58800000300008087f7f50800000380008087f7f48800000400008087f7f40800000480008087f7f38800000500008087f7f30800000580008087f7f28800000600008087f7f20800000680008087f7f18800000700008087f7f10800000780008087f7f08800000000808087f7f80780000080808087f7f78780000100808087f7f70780000180808057f7c687b0000200808057f7c607b0000280808057f7c587b0000300808057f7c507b0000380808057f7c487b0000400808057f7c407b0000480808057f7c387b0000180d070e7f7f000706041f0d070f7f7f00080406260d07097f7c000706042d0d0d167f7f000c0c0900100d0d7f7f807000000d10090b7f7f73700000001d03107f7f80630000031d0c107f7f7d6300000f1b0b0d7f7f716500003a0d0e0d7f7f01030b080f2805057f7f71580000142805077f7f6c580000192805067f7f6758000050080b0e7f7f010808055b080e0e7f7f0308070569080b0e7f7f010808057e75020b7f7f020b00007d75010b7f7f030b0000787905077f7f08070000717907077f7f0f0700003a1a0d0d7f7f01030a091a1c0d087f7f666400001e240d0d7f7f00030c092b240d0d7f7f00030c09002d0a197f7f000308150a2f0c0e7f7f765100001631090c7f7f000608056c7b05057f7f14050000557b04057f7f2b050000597b04057f7f270500005d7b05057f7f23050000627b05057f7f1e050000677b05057f7f19050000627605057f7f1e0a00001f310b0d7f7f614f000075080b0d7f7f010808044b760a0a7f7f350a0000467d05037f7f3a030000417d05037f7f3f0300003c7905077f7f44070000377905077f7f4907000075150b0d7f7f01080804347903077f7f4c0700002b7d09037f7f55030000267d05037f7f5a0300005d7605057f7f230a00001f7a07067f7f61060000187a07067f7f68060000"
#SPRITE_META_STR = "040000080804080008080410000808041800080804200008080428000808043000080804380008080440000808044800080804500008080458000808046000080804680008080470000808047800080804000808080408080808041008080806180808057f7c06200808057f7c06280808057f7c06300808057f7c06380808057f7c06400808057f7c06480808057f7c08180d070e00070604081f0d070f000804060a260d07097f7c00070604082d0d0d16000c0c090400100d0d040d10090b04001d031004031d0c10040f1b0b0d083a0d0e0d01030b08040f280505041428050704192805060850080b0e010808050a5b080e0e7f7f030807050869080b0e01080805047e75020b047d75010b04787905070471790707083a1a0d0d01030a09041a1c0d08081e240d0d00030c09082b240d0d00030c0908002d0a1900030815040a2f0c0e081631090c00060805046c7b050504557b040504597b0405045d7b050504627b050504677b05050462760505041f310b0d0875080b0d01080804044b760a0a04467d050304417d0503043c79050704377905070875150b0d010808040434790307042b7d090304267d0503045d760505041f7a070604187a0706"

def get_collision_for_sprite(im, bounds):
    x1, x2, y1, y2 = 128,0,128,0
    has_collision = False
    height = 0
    for y in range(bounds["y"], bounds["y"] + bounds["h"]):
        for x in range(bounds["x"], bounds["x"] + bounds["w"]):
            pix = im.getpixel((x + 128, y))
            if pix > 0:
                height = max(pix - 31,0)
                x1 = min(x1, x)
                x2 = max(x2, x)
                y1 = min(y1, y)
                y2 = max(y2, y)
                has_collision = True

    if not has_collision:
        return None
    out = (x1 - bounds["x"], y1 - bounds["y"], max(x2 - x1,0), max(y2 - y1,0), height)
    return out

def generate_sprite_meta(im, f):
    s = ""
    with open(f) as fh:
        data = json.load(fh)
        slices = sorted(data["meta"]["slices"], key = lambda x:int(x["name"].split(" ")[1]))
        for slice in slices:
            print(slice["name"])
            item = slice["keys"][0]
            bounds = item["bounds"]
            offset = None
            collision = get_collision_for_sprite(im, bounds)
            if "pivot" in item:
                offset = slice["keys"][0]["pivot"]
            s += encode(bounds, offset, collision)
    return s

def generate_gfx(im):
    s = ""
    for y in range(128):
        for x in range(128):
            pix = im.getpixel((x,y))
            if pix > 31:
                raise Exception("Hit an invalid color: %d" % pix)
            else:
                if palette[pix] == "X":
                    raise Exception("Hit an invalid color: %d" % pix)
                else:
                    s += palette[pix]
        s += "\n"
    return s
    
def encode(bounds, offset, collision):
    length = 4
    str = "{0:02x}{1:02x}{2:02x}{3:02x}".format(
                bounds["x"], bounds["y"], bounds["w"], bounds["h"],
            )    
    if collision and not offset:
        offset = {"x":0, "y":0}
    if offset:
        str += "{0:02x}{1:02x}".format(
            offset["x"] + 127, offset["y"] + 127
        )
        length += 2
    if collision:
        str += "{0:02x}{1:02x}{2:02x}{3:02x}{4:02x}".format(
            collision[0] - offset["x"], collision[1] - offset["y"], collision[2], collision[3], collision[4]
        )
        length += 5

    str = "{0:02x}".format(length) + str

    print(str)

    return str

def modify_cart(template, out, image_str, meta_str):
    shutil.copyfile(out, out + ".bak")
    with open(template, "r") as fh:
        lines = [l.strip() for l in fh.readlines()]

    def replace_line(search, new):
            lines[lines.index(search)] = new

    replace_line("-- sprite_meta", "SPRITE_META_STR = \"%s\"" % meta_str)
    replace_line("-- gfx", "__gfx__\n%s" % image_str)

    with open(out, "w") as fh:
        fh.writelines([l + "\n" for l in lines])        

if __name__ == "__main__":
    with Image.open("sheet.png") as im:
        image_str = generate_gfx(im)
        meta_str = generate_sprite_meta(im, "sheet.json")
    modify_cart("catcafe_template.p8","catcafe.p8", image_str, meta_str)
    modify_cart("viewer_template.p8","viewer.p8", image_str, meta_str)