/// oCoin Draw

// compute breathing scale (smooth sine)
var s = base_scale + pulse_amp * sin(pulse_t);

// draw the coin scaled (visual-only, collision stays normal)
draw_sprite_ext(sprite_index, image_index, x, y, s, s, 0, c_white, 1);

// OPTIONAL soft golden glow (no blend mode needed)
var t = (sin(pulse_t) + 1) * 0.5; // 0..1 for slight glow breathing
var gold = make_color_rgb(255, 215, 80);
draw_set_alpha(glow_alpha + t * 0.10); // breathe the glow a little

for (var i = 1; i <= glow_rings; i++) {
    var r = (sprite_width * s * 0.5) + i * glow_spread;
    draw_set_colour(gold);
    draw_circle(x, y, r, false);
}

draw_set_alpha(1);
draw_set_colour(c_white);