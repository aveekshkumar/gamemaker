// oBackButton Step Event

var button_left = x - width/2;
var button_right = x + width/2;
var button_top = y - height/2;
var button_bottom = y + height/2;

var mouse_over = (mouse_x > button_left && mouse_x < button_right && 
                  mouse_y > button_top && mouse_y < button_bottom);

hover = mouse_over;

if (hover) {
    button_scale = lerp(button_scale, 1.1, 0.1);
} else {
    button_scale = lerp(button_scale, 1, 0.1);
}

if (mouse_over && mouse_check_button_pressed(mb_left)) {
    room_goto(rm_start);
}