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
    let font = Font::from_ref(font_ref);
    let mut buffer = GlyphBuffer::from_ref(buf_ref);
    // Get buffer as string
    let buf_u8: Vec<u8> = buffer.glyphs.iter().map(|g| g.codepoint as u8).collect();
    let str_buf = String::from_utf8_lossy(&buf_u8);

    let dot_cnt = str_buf.chars().filter(|c| *c == '.').count() as u32;
    if dot_cnt > 0 {
        debug(&format!("dot count: {}", dot_cnt));

        let first_dot = str_buf.as_bytes().iter().position(|c| *c == b'.').unwrap();
        debug(&format!("First dot: {first_dot}"));
        let run_length = str_buf[first_dot..]
            .as_bytes()
            .iter()
            .position(|c| *c != b'.')
            .unwrap_or_else(|| str_buf[first_dot..].as_bytes().len())
            as u32;
        debug(&format!("Run length: {run_length}"));

        const OFFSET: u32 = 0xF0000;
        const FRAMES: u32 = 6573;
        const END: u32 = OFFSET + FRAMES;

        let glyph = if run_length > END {
            "FIN.".to_string()
        } else {
            char::from_u32(run_length - 1 + OFFSET).unwrap().to_string()
        };
        let before = &str_buf[..first_dot];
        let after = &str_buf[first_dot + (run_length as usize)..];
        let res_str = format!("{before}{glyph}{after}");
        // debug(&res_str);
        buffer.glyphs = res_str
            .chars()
            .enumerate()
            .map(|(ix, x)| Glyph {
                codepoint: x as u32,
                flags: 0,
                x_advance: 0,
                y_advance: 0,
                cluster: ix as u32,
                x_offset: 0,
                y_offset: 0,
            })
            .collect();
    } else {
        debug("No match");
        debug(&str_buf);
    }

    for item in buffer.glyphs.iter_mut() {
        // Map character to glyph
        item.codepoint = font.get_glyph(item.codepoint, 0);
        // Set advance width
        item.x_advance = font.get_glyph_h_advance(item.codepoint);
    }
    // Buffer is written back to HB on drop
    1
}
