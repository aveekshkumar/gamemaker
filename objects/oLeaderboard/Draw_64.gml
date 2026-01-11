var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();
var save_file = game_save_id + "_leaderboard.ini";

// Reload scores fresh every frame
ds_list_clear(leaderboard_scores);
ini_open(save_file);
for (var i = 1; i <= 5; i++) {
    var score_val = ini_read_real("Leaderboard", "Score" + string(i), 0);
    if (score_val > 0) {
        ds_list_add(leaderboard_scores, score_val);
    }
}
ini_close();

// Background
draw_set_color(c_black);
draw_rectangle(0, 0, gui_width, gui_height, false);

// Title
draw_set_color(c_yellow);
draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_text_transformed(gui_width / 2, 40, "🏆 TOP 5 SCORES 🏆", 2, 2, 0);

// Score list
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var score_start_y = 140;
var score_spacing = 60;

if (ds_list_size(leaderboard_scores) == 0) {
    draw_text(gui_width / 2, gui_height / 2, "No scores yet!\nPlay and die to get on the leaderboard!");
} else {
    for (var i = 0; i < ds_list_size(leaderboard_scores); i++) {
        var y_pos = score_start_y + (i * score_spacing);
        var score_val = leaderboard_scores[| i];
        
        // Rank number (gold for 1st, silver for 2nd, bronze for 3rd)
        switch(i) {
            case 0: draw_set_color(#FFD700); break;
            case 1: draw_set_color(#C0C0C0); break;
            case 2: draw_set_color(#CD7F32); break;
            default: draw_set_color(c_white); break;
        }
        
        draw_text_transformed(gui_width / 2 - 100, y_pos, "#" + string(i + 1), 1.5, 1.5, 0);
        
        // Score value (white)
        draw_set_color(c_white);
        draw_text_transformed(gui_width / 2 + 100, y_pos, string(score_val), 1.5, 1.5, 0);
    }
}

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