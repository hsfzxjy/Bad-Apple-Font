import sys
from os import path
import fontforge
import re


if len(sys.argv) < 3:
    print_message("Error: Missing input and output filenames")
    exit(1)

input_sfd_filename = sys.argv[1]
output_sfd_filename = sys.argv[2]
svg_filenames = sys.argv[3:]

font = fontforge.open(input_sfd_filename)
font.removeLookup("'kern' Horizontal Kerning lookup 1")

glyph_count = 0
for svg_filename in svg_filenames:
    id = int(re.findall(r"(\d+).svg", svg_filename)[0])
    charcode = id + 0xF0000
    glyph = font.createChar(charcode)
    glyph.glyphname = f"Frame{id}"
    glyph.importOutlines(svg_filename, "correctdir")
    glyph.removeOverlap()
    if glyph.foreground.isEmpty():
        pen = glyph.glyphPen()
        print(glyph.unicode, hex(glyph.unicode), "filling empty glyph")
        pen.moveTo((0, 0))
        pen.lineTo((0, 0))
    glyph_count += 1

font.save(output_sfd_filename)

print("Successfully imported %d glyphs: '%s'" % (glyph_count, output_sfd_filename))
