#![feature(slice_group_by)]

mod harfbuzz_wasm;
use crate::harfbuzz_wasm::{debug, Font, Glyph, GlyphBuffer};
use wasm_bindgen::prelude::*;

#[wasm_bindgen]
pub fn shape(
    _shape_plan: u32,
    font_ref: u32,
    buf_ref: u32,
    _features: u32,
    _num_features: u32,
) -> i32 {
    const DOT_CODEPOINT: u32 = 46;
    const OFFSET: u32 = 0xF0000;

    let font = Font::from_ref(font_ref);
    let mut buffer = GlyphBuffer::from_ref(buf_ref);

    buffer.glyphs = buffer
        .glyphs
        .group_by(|a, b| a.codepoint == DOT_CODEPOINT && b.codepoint == DOT_CODEPOINT)
        .map(|s| -> Glyph {
            let first = unsafe { s.get_unchecked(0) };
            debug(&first.codepoint.to_string());
            let mut g = if first.codepoint != DOT_CODEPOINT {
                first.clone()
            } else {
                Glyph {
                    codepoint: OFFSET + s.len() as u32,
                    flags: 0,
                    x_advance: 0,
                    y_advance: 0,
                    cluster: 0,
                    x_offset: 0,
                    y_offset: 0,
                }
            };
            g.codepoint = font.get_glyph(g.codepoint, 0);
            g.x_advance = font.get_glyph_h_advance(g.codepoint);
            g
        })
        .collect();
    // Buffer is written back to HB on drop
    1
}
