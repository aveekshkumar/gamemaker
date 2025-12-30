// oLoginButton Draw GUI Event
draw_sprite(sPresent, 0, x, y - 100);
var button_color = can_claim ? color_available : color_claimed;
var w = width * button_scale;
var h = height * button_scale;

// Draw glowing background if available
if (can_claim) {
    draw_set_color(c_lime);
    draw_set_alpha(0.2);
    draw_rectangle(x - w/2 - 10, y - h/2 - 10, x + w/2 + 10, y + h/2 + 10, false);
    draw_set_alpha(1);
}

// Draw button
draw_set_color(button_color);
draw_rectangle(x - w/2, y - h/2, x + w/2, y + h/2, false);

// Draw border
draw_set_color(c_black);
draw_rectangle(x - w/2, y - h/2, x + w/2, y + h/2, true);

// Draw text
draw_set_color(c_black);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(-1);

if (can_claim) {
    draw_text(x, y, "CLAIM REWARD");
} else {
    draw_text(x, y, "ALREADY CLAIMED");
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);