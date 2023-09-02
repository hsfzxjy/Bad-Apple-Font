import sys
from os import path
import fontforge


class Font:
    def __init__(self, fontforge_font):
        self.font = fontforge_font
        pass

    @classmethod
    def open_sfd(cls, filename):
        return Font(fontforge.open(filename))

    def save_sfd(self, filename):
        self.font.save(filename)

    def create_char(self, char_code):
        return self.font.createChar(char_code)


class SvgImporter:
    def __init__(self):
        self.remove_overlap = True
        self.import_outlines_flags = "correctdir"
        pass

    def get_glyph_for_svg(self, font, filename):
        char_code = self._get_char_code_from_svg(filename)
        return font.create_char(char_code)

    @staticmethod
    def _get_char_code_from_svg(filename):
        char = path.splitext(path.basename(filename))[0]
        return ord(char)

    def import_outlines_from_svg(self, glyph, filename):
        glyph.importOutlines(filename, self.import_outlines_flags)

        if self.remove_overlap:
            glyph.removeOverlap()


def print_message(message):
    print("")
    print(message)
    print("")


if len(sys.argv) < 3:
    print_message("Error: Missing input and output filenames")
    exit(1)

input_sfd_filename = sys.argv[1]
output_sfd_filename = sys.argv[2]
svg_filenames = sys.argv[3:]

font = Font.open_sfd(input_sfd_filename)
importer = SvgImporter()

glyph_count = 0
for svg_filename in svg_filenames:
    glyph = importer.get_glyph_for_svg(font, svg_filename)
    importer.import_outlines_from_svg(glyph, svg_filename)
    if glyph.foreground.isEmpty():
        pen = glyph.glyphPen()
        print(glyph.unicode, hex(glyph.unicode), "filling empty glyph")
        pen.moveTo((0, 0))
        pen.lineTo((0, 0))
    glyph_count += 1

font.save_sfd(output_sfd_filename)

print_message(
    "Successfully imported %d glyphs: '%s'" % (glyph_count, output_sfd_filename)
)
