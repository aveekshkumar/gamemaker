/// oDrone Draw (no blend modes, safe everywhere)

// --- read runner glow (if present) ---
var gf = 0;
if (instance_exists(follow_target) && variable_instance_exists(follow_target, "glow_factor")) {
    gf = follow_target.glow_factor;
}

// --- goodbye fade multiplier ---
var fade_mul = (goodbye && !is_undefined(gb_alpha)) ? gb_alpha : 1;

// =========================
// TETHER (only when not saying goodbye)
// =========================
if (!goodbye && instance_exists(follow_target)) {
    var x1 = x, y1 = y;                           // drone end
    var x2 = follow_target.x, y2 = follow_target.y - 10; // runner end

    // defaults if not set in Create
    var base_col   = is_undefined(beam_col)   ? make_color_rgb(150,255,150) : beam_col;
    var base_alpha = is_undefined(beam_alpha) ? 0.45 : beam_alpha;
    var base_w     = is_undefined(beam_width) ? 4    : beam_width;
    var pulse      = is_undefined(beam_pulse) ? 0    : beam_pulse;

    var segs = 8;
    var amp  = 1.5 + 0.5 * sin(pulse); // tiny wiggle
    var lastx, lasty;

    // 3 soft passes, no blend modes needed
    for (var pass_i = 0; pass_i < 3; pass_i++) {
        var a = base_alpha * (0.6 - pass_i * 0.18);
        a *= (1.0 + 0.40 * gf); // brighter with runner glow
        if (a <= 0) continue;

        var w = base_w + (2 - pass_i);

        draw_set_alpha(clamp(a, 0, 1));
        draw_set_colour(base_col);

        lastx = x1; lasty = y1;
        for (var i = 1; i <= segs; i++) {
            var t  = i / segs;
            var px = lerp(x1, x2, t);
            var py = lerp(y1, y2, t);

            // perpendicular wiggle
            var dx = x2 - x1, dy = y2 - y1;
            var len = max(1, point_distance(x1, y1, x2, y2));
            var nx = -dy / len, ny = dx / len;
            var wob = amp * sin(pulse + t * 6.283185); // 2π * t
            px += nx * wob; py += ny * wob;

            draw_line_width(lastx, lasty, px, py, w);
            lastx = px; lasty = py;
        }
    }

    // end nodes
    draw_set_alpha(0.55);
    draw_set_colour(base_col);
    draw_circle(x1, y1, 3, true);
    draw_circle(x2, y2, 3, true);
    draw_set_alpha(1);
    draw_set_colour(c_white);
}

// =========================
// Goodbye sparkle trail
// =========================
if (goodbye) {
    var trail_col = is_undefined(beam_col) ? make_color_rgb(150,255,150) : beam_col;
    for (var s = 0; s < 3; s++) {
        var ta = max(0, (fade_mul - s * 0.25)) * 0.6;
        draw_set_alpha(ta);
        draw_set_colour(merge_color(trail_col, c_white, 0.3));
        draw_circle(x, y + 6 * s, 2, true);
    }
    draw_set_alpha(1);
}

// =========================
// Shadow
// =========================
draw_set_colour(c_black);
draw_set_alpha(0.30 * fade_mul);
draw_ellipse(x - 6, y + 10, x + 6, y + 12, false);
draw_set_alpha(1);

// =========================
// Body (brightens with glow, fades on goodbye)
// =========================
var body_outer = merge_color(make_color_rgb(180,240,255), c_white, 0.40 * gf);
var body_inner = merge_color(make_color_rgb( 80,160,255), c_white, 0.50 * gf);
var body_scale = 1.0 + 0.08 * gf;

draw_set_alpha(fade_mul);
draw_set_colour(body_outer);
draw_circle(x, y, 6 * body_scale, true);
draw_set_colour(body_inner);
draw_circle(x, y, 4 * body_scale, true);
draw_set_alpha(1);

// =========================
 // Rotating ring dots
// =========================
var a2 = (current_time / 10) mod 360;
draw_set_alpha(fade_mul);
draw_set_colour(merge_color(make_color_rgb(120,200,255), c_white, 0.35 * gf));
for (var k = 0; k < 360; k += 45) {
    var px2 = x + lengthdir_x(9, k + a2);
    var py2 = y + lengthdir_y(5, k + a2);
    draw_circle(px2, py2, 1.5, true);
}
draw_set_alpha(1);
draw_set_colour(c_white);