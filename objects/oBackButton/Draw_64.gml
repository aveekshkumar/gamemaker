// oBackButton Draw GUI Event

var w = width * button_scale;
var h = height * button_scale;

// Glow effect - Duotone aura
var red_col = make_color_rgb(255, 0, 0);
var blue_col = make_color_rgb(0, 100, 255);
var blend_amount = 0.5 + 0.5 * sin(current_time / 600);
var glow_col = merge_color(red_col, blue_col, blend_amount);

draw_set_color(glow_col);
draw_set_alpha(0.2);
draw_rectangle(x - w/2 - 10, y - h/2 - 10, x + w/2 + 10, y + h/2 + 10, false);
draw_set_alpha(1);

// DUOTONE EFFECT - Red to Blue FLOWING
var red_col = make_color_rgb(255, 0, 0);
var blue_col = make_color_rgb(0, 100, 255);

// Animate shift amount (moves left to right)
var shift = sin(current_time / 600) * (w/2);

// Draw button with gradient
for (var px = -w/2; px < w/2; px += 2) {
    var blend_amount = (px + shift + w/2) / w;
    blend_amount = clamp(blend_amount, 0, 1);
    var col = merge_color(red_col, blue_col, blend_amount);
    
    draw_set_color(col);
    draw_rectangle(x + px, y - h/2, x + px + 2, y + h/2, false);
}

// Border
draw_set_color(c_black);
draw_rectangle(x - w/2, y - h/2, x + w/2, y + h/2, true);

// Text
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(x, y, "BACK");
draw_set_halign(fa_left);
draw_set_valign(fa_top);