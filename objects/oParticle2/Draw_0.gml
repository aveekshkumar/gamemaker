var col = (variable_instance_exists(id, "particle_color")) ? particle_color : c_yellow;
draw_set_color(col);
draw_circle(x, y, 2, false);
draw_set_color(c_white);