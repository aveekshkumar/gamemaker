/// oDrone Draw

// --- Read glow factor from runner (0..1) ---
var gf = 0;
if (instance_exists(follow_target)) gf = follow_target.glow_factor;

// --- TETHER (draw first so the drone is on top) ---
if (instance_exists(follow_target)) {
    var x1 = x, y1 = y;                           // drone end
    var x2 = follow_target.x, y2 = follow_target.y - 6; // runner end

    // light green base color, boosted by glow
    var base_beam = beam_col; // set in Create (e.g., make_color_rgb(150,255,150))
    var beam_col_boost = merge_color(base_beam, c_white, 0.50 * gf);

    // gentle wavy ribbon made of short segments
    var segs = 8;                         // segment count
    var amp  = 1.5 + 0.5 * sin(beam_pulse); // tiny wave amplitude
    var lastx, lasty;

    // draw a few passes for a soft look
    for (var pass_i = 0; pass_i < 3; pass_i++) {
        var a = beam_alpha * (0.6 - pass_i * 0.18); // fades per layer
        a *= (1.0 + 0.40 * gf);                     // brighten with glow
        if (a <= 0) continue;

        var w = beam_width + (2 - pass_i);          // slightly thicker inner pass

        draw_set_alpha(clamp(a, 0, 1));
        draw_set_colour(beam_col_boost);

        lastx = x1; lasty = y1;
        for (var i = 1; i <= segs; i++) {
            var t  = i / segs;
            var px = lerp(x1, x2, t);
            var py = lerp(y1, y2, t);

            // perpendicular wiggle for energy feel
            var dx = x2 - x1, dy = y2 - y1;
            var len = max(1, point_distance(x1, y1, x2, y2));
            var nx = -dy / len, ny = dx / len;      // unit perpendicular
            var wob = amp * sin(beam_pulse + t * 6.283185); // 2π * t
            px += nx * wob;
            py += ny * wob;

            draw_line_width(lastx, lasty, px, py, w);
            lastx = px; lasty = py;
        }
    }

    // soft end nodes
    draw_set_alpha(0.55 * (1.0 + 0.35 * gf));
    draw_set_colour(beam_col_boost);
    draw_circle(x1, y1, 3, false);
    draw_circle(x2, y2, 3, false);

    draw_set_alpha(1);
    draw_set_colour(c_white);
}

// --- Drone shadow (ground it) ---
draw_set_colour(c_black);
draw_set_alpha(0.30);
draw_ellipse(x - 6, y + 10, x + 6, y + 12, false);
draw_set_alpha(1);

// --- Drone body (brightens with glow) ---
var body_outer = merge_color(make_color_rgb(180,240,255), c_white, 0.40 * gf);
var body_inner = merge_color(make_color_rgb( 80,160,255), c_white, 0.50 * gf);
var body_scale = 1.0 + 0.08 * gf;

draw_set_colour(body_outer);
draw_circle(x, y, 6 * body_scale, false);
draw_set_colour(body_inner);
draw_circle(x, y, 4 * body_scale, false);
draw_set_colour(c_white);

// --- Rotating ring dots ---
var a2 = (current_time / 10) mod 360;
draw_set_colour(merge_color(make_color_rgb(120,200,255), c_white, 0.35 * gf));
for (var k = 0; k < 360; k += 45) {
    var px2 = x + lengthdir_x(9, k + a2);
    var py2 = y + lengthdir_y(5, k + a2);
    draw_circle(px2, py2, 1.5, false);
}
draw_set_colour(c_white);

if (instance_exists(follow_target) && follow_target.burst_active) {
    gf = clamp(gf + 0.6, 0, 1); // temporarily boost brightness
}