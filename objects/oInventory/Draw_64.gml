/// --- oInventory Draw GUI Event ---
var gw = display_get_gui_width();
var gh = display_get_gui_height();

/// Modern glowing inventory with fade animation

var gw = display_get_gui_width();
var gh = display_get_gui_height();

draw_set_alpha(fade_alpha);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Title
draw_set_color(merge_color(c_white, c_aqua, 0.3 + 0.2 * sin(current_time / 400)));
draw_text(gw / 2, gh * 0.15, "🎨 INVENTORY");

// No unlocked colors
if (array_length(global.unlocked_colors) == 0) {
    draw_set_color(c_gray);
    draw_text(gw / 2, gh / 2, "No Colors Unlocked");
} else {
    // Display color options
    for (var i = 0; i < array_length(global.unlocked_colors); i++) {
        var yy = gh * 0.35 + i * 60;
        var col = global.unlocked_colors[i];

        // Color swatch
        draw_set_color(col);
        draw_rectangle(gw / 2 - 120, yy - 20, gw / 2 + 120, yy + 20, false);

        // Outline highlight
        if (i == inv_index) {
            draw_set_color(c_lime);
            draw_rectangle(gw / 2 - 130, yy - 30, gw / 2 + 130, yy + 30, true);
            draw_set_color(merge_color(c_white, col, 0.3));
            draw_text(gw / 2, yy + 35, "Press Enter to Equip");
        }
    }

    // Equipped color section
    draw_set_color(c_white);
    draw_text(gw / 2, gh - 120, "Equipped Color");
    draw_set_color(global.player_color);
    draw_rectangle(gw / 2 - 50, gh - 80, gw / 2 + 50, gh - 60, false);
}

// Footer
draw_set_color(merge_color(c_gray, c_white, 0.3));
draw_text(gw / 2, gh - 40, "↑↓ Move  |  Enter Equip  |  Esc Back");

draw_set_alpha(1);