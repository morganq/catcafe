import rpack
import json
import shutil
from PIL import Image, ImageDraw

# Create a bunch of rectangles (width, height)
sizes = [(58, 206), (231, 176), (35, 113), (46, 109)]

# Pack
positions = rpack.pack(sizes)



def pack_atlas(img, data):
    slices = sorted(data["meta"]["slices"], key = lambda x:int(x["name"].split(" ")[1]))
    sizes = []
    original_rects = []
    slice_refs = []
    for slice in slices:
        item = slice["keys"][0]
        bounds = item["bounds"]    
        original_rects.append((bounds["x"], bounds["y"], bounds["w"], bounds["h"]))
        sizes.append((bounds["w"], bounds["h"]))
        slice_refs.append(item)
    positions = rpack.pack(sizes, 128, 128)

    # We're all packed! Let's get going
    outimg = img.copy()
    draw = ImageDraw.Draw(outimg)
    draw.rectangle((0, 0, 255, 127), 0)
    for i in range(len(positions)):
        (x, y, w, h) = original_rects[i]
        (px, py) = positions[i]
        print("%d: [%d, %d, %d, %d] -> [%d, %d]" % (i, x,y,w,h,px,py))
        outimg.paste(img.crop((x, y, x + w, y + h)), (px, py))
        outimg.paste(img.crop((x + 128, y, x + w + 128, y + h)), (px + 128, py))
        slice_refs[i]["bounds"] = {"x":px, "y":py, "w":w, "h":h}
    
    return outimg, data
    

if __name__ == "__main__":
    outimg, outslices = pack_atlas(Image.open("sheet.png"), json.load(open("sheet.json")))
    json.dump(outslices, open("sheet_out.json", "w"))
    outimg.save("sheet_out.png")