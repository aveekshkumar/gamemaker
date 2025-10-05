// Breathing scale
var s = base_scale + pulse_amp * sin(pulse_t);

// Gem tint (icy cyan)
var gem_col = make_color_rgb(120, 220, 255);

// Coin sprite tinted & scaled
draw_sprite_ext(sprite_index, image_index, x, y, s, s, 0, gem_col, 1);

// Soft glow rings
var t = (sin(pulse_t) + 1) * 0.5;
draw_set_alpha(glow_alpha + t * 0.10);
draw_set_colour(gem_col);
for (var i = 1; i <= glow_rings; i++) {
    var r = (sprite_width * s * 0.5) + i * glow_spread;
    draw_circle(x, y, r, false);
}
draw_set_alpha(1);
draw_set_colour(c_white);

// Sparkle star (rotates slowly)
var ang = current_time * 0.18 mod 360;
var r1 = 9 * s;
var r2 = 5 * s;

draw_set_alpha(0.85);
draw_set_colour(gem_col);
// cross
draw_line_width(x - r1, y, x + r1, y, 1);
draw_line_width(x, y - r1, x, y + r1, 1);
// diagonals (rotate by ang)
var dx = lengthdir_x(r2, ang);
var dy = lengthdir_y(r2, ang);
draw_line_width(x - dx, y - dy, x + dx, y + dy, 1);
draw_set_alpha(1);
draw_set_colour(c_white);