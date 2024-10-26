echo "building"
./env/bin/python3 build_sprites.py
python3 ~/Downloads/shrinko8-main\ 2/shrinko8.py catcafe.p8 catcafe-min.p8 --minify-safe-only
/Applications/PICO-8.app/Contents/MacOS/pico8 -x catcafe-min.p8 -export "build/catcafe.p8.png"
echo "done"