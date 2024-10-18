import json
import shutil
from PIL import Image

palette = "0XX34X6789abXXefXX1X2X5XXXXXcXXd"

def get_collision_for_sprite(im, bounds):
    x1, x2, y1, y2 = 128,0,128,0
    for y in range(bounds["y"], bounds["y"] + bounds["h"]):
        for x in range(bounds["x"], bounds["x"] + bounds["w"]):
            pix = im.getpixel((x + 128, y))
            if pix > 0:
                x1 = min(x1, x)
                x2 = max(x2, x)
                y1 = min(y1, y)
                y2 = max(y2, y)

    out = (x1 - bounds["x"], y1 - bounds["y"], max(x2 - x1,0), max(y2 - y1,0))
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
            offset = {"x": 0, "y": 0}
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
    print("x: %d, y: %d, w: %d, h: %d, ox: %d, oy: %d, cx: %d, cy: %d, cw: %d, ch: %d" % (
        bounds["x"], bounds["y"], bounds["w"], bounds["h"],
        offset["x"] + 127, offset["y"] + 127,
        collision[0] - offset["x"], collision[1] - offset["y"], collision[2], collision[3]
    ))
    return "{0:02x}{1:02x}{2:02x}{3:02x}{4:02x}{5:02x}{6:02x}{7:02x}{8:02x}{9:02x}".format(
        bounds["x"], bounds["y"], bounds["w"], bounds["h"],
        offset["x"] + 127, offset["y"] + 127,
        collision[0] - offset["x"], collision[1] - offset["y"], collision[2], collision[3]
        )

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