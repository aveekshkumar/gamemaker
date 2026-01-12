var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();

// Background
draw_set_color(c_black);
draw_rectangle(0, 0, gui_width, gui_height, false);

// Title
draw_set_color(c_yellow);
draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_text_transformed(gui_width / 2, 40, "📊 STATISTICS 📊", 2, 2, 0);

// Stats display
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_font(-1);

var stat_y = 140;
var stat_spacing = 60;

// Best Score
draw_text(gui_width / 2, stat_y, "Best Score");
draw_set_color(c_yellow);
draw_text_transformed(gui_width / 2, stat_y + 25, string(global.best_score), 1.8, 1.8, 0);

// Games Played
draw_set_color(c_white);
draw_text(gui_width / 2, stat_y + stat_spacing, "Games Played");
draw_set_color(c_lime);
draw_text_transformed(gui_width / 2, stat_y + stat_spacing + 25, string(global.games_played), 1.8, 1.8, 0);

// Total Coins Earned
draw_set_color(c_white);
draw_text(gui_width / 2, stat_y + (stat_spacing * 2), "Total Coins Earned");
draw_set_color(c_aqua);
draw_text_transformed(gui_width / 2, stat_y + (stat_spacing * 2) + 25, string(global.total_coins), 1.8, 1.8, 0);

// Total Gems Collected
draw_set_color(c_white);
draw_text(gui_width / 2, stat_y + (stat_spacing * 3), "Total Gems Collected");
draw_set_color(c_fuchsia);
draw_text_transformed(gui_width / 2, stat_y + (stat_spacing * 3) + 25, string(global.total_gems), 1.8, 1.8, 0);

// Total Playtime (convert seconds to hours:minutes:seconds)
var total_seconds = global.total_playtime;
var hours = floor(total_seconds / 3600);
var minutes = floor((total_seconds mod 3600) / 60);
var seconds = floor(total_seconds mod 60);
var playtime_str = string(hours) + "h " + string(minutes) + "m " + string(seconds) + "s";

draw_set_color(c_white);
draw_text(gui_width / 2, stat_y + (stat_spacing * 4), "Total Playtime");
draw_set_color(c_orange);
draw_text_transformed(gui_width / 2, stat_y + (stat_spacing * 4) + 25, playtime_str, 1.8, 1.8, 0);

// Back button
draw_set_color(c_gray);
draw_rectangle(40, back_button_y, 40 + back_button_width, back_button_y + back_button_height, false);
draw_set_color(c_white);
draw_rectangle(40, back_button_y, 40 + back_button_width, back_button_y + back_button_height, true);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(40 + back_button_width / 2, back_button_y + back_button_height / 2, "BACK");

// Instructions
draw_set_color(c_aqua);
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_text(gui_width / 2, gui_height - 20, "Press ESC or click BACK to return");

draw_set_halign(fa_left);
draw_set_valign(fa_top);