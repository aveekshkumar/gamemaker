if (mouse_check_button_pressed(mb_left)) {
    // Check if Rama button clicked
    if (mouse_x >= rama_button_x && mouse_x <= rama_button_x + rama_button_w &&
        mouse_y >= rama_button_y && mouse_y <= rama_button_y + rama_button_h) {
        global.selected_character = "rama";
    }
    
    // Check if Krishna button clicked
    if (mouse_x >= krishna_button_x && mouse_x <= krishna_button_x + krishna_button_w &&
        mouse_y >= krishna_button_y && mouse_y <= krishna_button_y + krishna_button_h) {
        global.selected_character = "krishna";
    }
}