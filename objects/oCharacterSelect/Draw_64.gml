// Draw title
draw_text(160, 100, "CHARACTER");
draw_text(160, 150, "PICK");

// Draw Rama button
draw_rectangle(rama_button_x, rama_button_y, rama_button_x + rama_button_w, rama_button_y + rama_button_h, false);
draw_set_color(c_blue);
draw_rectangle(rama_button_x, rama_button_y, rama_button_x + rama_button_w, rama_button_y + rama_button_h, false);
draw_set_color(c_white);
draw_text(rama_button_x + 35, rama_button_y + 45, "RAMA");

// Draw Krishna button
draw_set_color(c_aqua);
draw_rectangle(krishna_button_x, krishna_button_y, krishna_button_x + krishna_button_w, krishna_button_y + krishna_button_h, false);
draw_set_color(c_white);
draw_text(krishna_button_x + 5, krishna_button_y + 45, "KRISHNA");

draw_set_color(c_white);