// oBackButton Draw GUI Event

var w = width * button_scale;
var h = height * button_scale;

// Glow effect
draw_set_color(c_lime);
draw_set_alpha(0.2);
draw_rectangle(x - w/2 - 10, y - h/2 - 10, x + w/2 + 10, y + h/2 + 10, false);
draw_set_alpha(1);

// Draw button
draw_set_color(color_available);
draw_rectangle(x - w/2, y - h/2, x + w/2, y + h/2, false);

// Border
draw_set_color(c_black);
draw_rectangle(x - w/2, y - h/2, x + w/2, y + h/2, true);

// Text
draw_set_color(c_black);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(x, y, "BACK");
draw_set_halign(fa_left);
draw_set_valign(fa_top);