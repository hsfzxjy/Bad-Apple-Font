import fontforge
import sys

font = fontforge.open(sys.argv[1])
output = sys.argv[2]

for x in range(1, 6574):
    font.createChar(0xF0000 + x)

for x in sys.argv[3:]:
    print("Merging", x)
    font.mergeFonts(x, True)

font.save(output)
