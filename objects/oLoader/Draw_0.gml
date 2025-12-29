/// --- oLoader Draw Event ---
/// Dynamic gradient background + smooth circular loader

var gw = display_get_gui_width();
var gh = display_get_gui_height();
var cx = gw * 0.5;
var cy = gh * 0.5;

// --- Animated Background Gradient ---
var t = current_time / 800.0;
var bg_r = 20 + sin(t) * 8;
var bg_g = 22 + sin(t + 1) * 8;
var bg_b = 28 + sin(t + 2) * 8;
draw_clear_alpha(make_color_rgb(bg_r, bg_g, bg_b), 1);

// Add this right after the background draw_clear_alpha() line:
var pulse = 0.4 + 0.3 * sin(current_time / 200);
draw_set_alpha(pulse);
draw_set_color(make_color_rgb(40, 220, 120)); // mint glow
draw_circle(cx, cy, radius + 60, false);
draw_set_alpha(1);

// --- Circle background track ---
draw_set_color(ring_bg);
draw_circle(cx, cy, radius, false);

// --- Main progress ring ---
draw_set_color(ring_fg);
var ang_end = start_ang + (progress * 360);
var steps = 180;
var thickness = 6; // adjust for style

for (var t = -thickness / 2; t <= thickness / 2; t++) {
    var prev_x = cx + lengthdir_x(radius + t, start_ang);
    var prev_y = cy + lengthdir_y(radius + t, start_ang);
    for (var i = start_ang; i <= ang_end; i += 360 / steps) {
        var xx = cx + lengthdir_x(radius + t, i);
        var yy = cy + lengthdir_y(radius + t, i);
        draw_line(prev_x, prev_y, xx, yy);
        prev_x = xx;
        prev_y = yy;
    }
}

// --- Glow effect ---
draw_set_alpha(glow_alpha * 0.3);
draw_set_color(ring_fg);
draw_circle(cx, cy, radius + 10, false);
draw_set_alpha(1);

// --- Loading text ---
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(cx, cy + radius + 40, "Loading... " + string_format(progress * 100, 0, 0) + "%");

// --- Studio name ---
var glow_col = merge_color(c_lime, c_white, studio_glow);
draw_set_color(glow_col);
draw_text(cx, cy + radius + 80, "Aviki.Co");

// --- Fade overlay ---
if (fade_alpha > 0) {
    draw_set_alpha(fade_alpha);
    draw_set_color(c_black);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);
}