draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_text(room_width/2, room_height/2 - 60, "GAME OVER");
draw_text(room_width/2, room_height/2 - 20, "Final Score: " + string(final_score));
draw_text(room_width/2, room_height/2 + 20, "Time: " + string(final_minutes) + ":" + string(final_seconds));
draw_text(room_width/2, room_height/2 + 60, "Press R to Restart");