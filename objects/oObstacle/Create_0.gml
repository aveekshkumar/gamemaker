scroll_speed = 6;

// Lane system
lane_x[0] = 80;
lane_x[1] = 160; 
lane_x[2] = 240;

lane = irandom(2);
x = lane_x[lane];
y = -64;

depth = -5;

// Random height
var height_choice = irandom(2);
switch(height_choice) {
    case 0: image_yscale = 1; break;
    case 1: image_yscale = 2; break;
    case 2: image_yscale = 3; break;
}

// Spawn a warning indicator
var warning = instance_create_layer(x, 0, "Instances", oWarning);
warning.linked_obstacle = id;

dodge_counted = false;