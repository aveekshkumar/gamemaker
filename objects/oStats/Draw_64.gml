var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);

// Title
draw_text_transformed(gui_width/2, 50, "📊 STATISTICS 📊", 2, 2, 0);

// Stats display
var stat_y = 150;
var stat_spacing = 60;

// Best Score (Yellow)
draw_set_color(c_yellow);
draw_text(100, stat_y, "Best Score: " + string(global.best_score));

// Games Played (Lime)
draw_set_color(c_lime);
draw_text(100, stat_y + stat_spacing, "Games Played: " + string(global.games_played));

// Total Coins (Aqua)
draw_set_color(c_aqua);
draw_text(100, stat_y + stat_spacing*2, "Total Coins: " + string(global.total_coins));

// Total Gems (Fuchsia)
draw_set_color(c_fuchsia);
draw_text(100, stat_y + stat_spacing*3, "Total Gems: " + string(global.total_gems));

// Playtime (Orange)
var hours = global.total_playtime div 3600;
var minutes = (global.total_playtime mod 3600) div 60;
var seconds = global.total_playtime mod 60;
draw_set_color(c_orange);
draw_text(100, stat_y + stat_spacing*4, "Playtime: " + string(hours) + "h " + string(minutes) + "m " + string(seconds) + "s");

// Back button
draw_set_color(c_white);
draw_rectangle(40, 500, 160, 550, false);
draw_set_color(c_black);
draw_text(50, 510, "BACK");

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);