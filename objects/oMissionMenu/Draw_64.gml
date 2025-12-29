/// oMissionMenu → Draw GUI Event (2025 compatible + smaller text)

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

// layout positions
var start_x = gui_w * 0.1;
var start_y = gui_h * 0.1;
var line_gap = gui_h * 0.08;

// dynamic scale for text
var scale = gui_h / 800.0;

// use matrix for safe transform
var mat = matrix_build(start_x, start_y, 0, 0, 0, 0, scale, scale, 1);
matrix_set(matrix_world, mat);

draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_color(c_white);

// title
draw_text(0, 0, "MISSIONS:");

// missions
for (var i = 0; i < array_length(global.missions); i++) {
    var m = global.missions[i];
    var y_pos = 40 + i * 60;
    var col = c_white;

    if (m.completed && !m.claimed) col = c_lime;
    else if (m.claimed) col = c_gray;

    draw_set_color(col);
    draw_text(20, y_pos, m.name)
}

// footer
draw_set_color(c_white);
draw_text(0, 240, "Total Gems: " + string(global.gems));
draw_text(0, 280, "Press ESC to return");

// reset matrix
matrix_set(matrix_world, matrix_build_identity());