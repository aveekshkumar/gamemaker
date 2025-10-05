/// oBackground Create
gw = 320;
gh = 800;

// scroll speeds
sky_speed     = 0.2;
star_speed    = 0.3;
cloud_speed   = 0.15;
skyline_speed = 0.6;

// night mode flag (toggled externally by oRunner if desired)
night_mode = false;

// ----- stars -----
star_count = 35;
star_x = array_create(star_count);
star_y = array_create(star_count);
for (var i = 0; i < star_count; i++) {
    star_x[i] = irandom_range(0, gw);
    star_y[i] = irandom_range(0, gh);
}

// ----- clouds -----
cloud_count = 6;
cloud = array_create(cloud_count);
for (var c = 0; c < cloud_count; c++) {
    var cx = irandom_range(0, gw);
    var cy = irandom_range(0, gh);
    var cs = irandom_range(20, 42);
    cloud[c] = {x: cx, y: cy, s: cs};
}

// ----- meteors -----
meteor_list  = ds_list_create();
meteor_timer = room_speed * 15;