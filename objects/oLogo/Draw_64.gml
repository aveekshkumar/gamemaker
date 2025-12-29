/// --- oLogo Draw GUI Event ---
var gw = display_get_gui_width();
var gh = display_get_gui_height();

// Background
draw_set_color(make_color_rgb(15, 18, 22));
draw_rectangle(0, 0, gw, gh, false);

// Glow behind text
var glow_col = merge_color(c_white, c_lime, 0.5);
draw_set_alpha(alpha * 0.4);
draw_set_color(glow_col);
draw_circle(gw/2, gh/2 + 4, 120, false);

// Studio Name
draw_set_alpha(alpha);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_transformed(gw/2, gh/2, "Aviki.Co", 2, 2, 0);

// Optional “Presents” text
draw_set_color(c_ltgray);
draw_set_alpha(alpha * 0.7);
draw_text(gw/2, gh/2 + 80, "presents");

// Reset alpha
draw_set_alpha(1);