/// oBackground Step

// follow runner night toggle if available
var night = instance_exists(oRunner) ? oRunner.night_mode : night_mode;
night_mode = night;

// get global scroll speed (fallback = 1)
var spd = variable_global_exists("scroll_speed") ? global.scroll_speed : 1;

// ----- stars (night) -----
if (night) {
    for (var i = 0; i < star_count; i++) {
        star_y[i] += star_speed * spd * 0.5;
        if (star_y[i] > gh) {
            star_y[i] = -4;
            star_x[i] = irandom_range(0, gw);
        }
    }
}

// ----- clouds (day) -----
if (!night) {
    for (var c = 0; c < cloud_count; c++) {
        var cl = cloud[c];
        cl.y += cloud_speed * spd * 0.8;
        cl.x += sin(current_time / 3000 + c) * 0.1; // gentle sideways drift
        if (cl.y - cl.s > gh) {
            cl.y = -cl.s - 8;
            cl.x = irandom_range(0, gw);
            cl.s = irandom_range(20, 42);
        }
        cloud[c] = cl;
    }
}

// ----- meteors -----
meteor_timer--;
if (meteor_timer <= 0) {
    var count = irandom_range(2, 4);
    for (var m = 0; m < count; m++) {
        var mx = irandom_range(-40, gw + 40);
        var my = -irandom_range(20, 200);
        var mspd = random_range(6, 10);
        var ang = 225 + random_range(-10, 10);
        ds_list_add(meteor_list, {x: mx, y: my, spd: mspd, ang: ang});
    }
    meteor_timer = room_speed * 45;
}

// update meteors
for (var k = ds_list_size(meteor_list) - 1; k >= 0; k--) {
    var met = meteor_list[| k];
    met.x += lengthdir_x(met.spd, met.ang);
    met.y += lengthdir_y(met.spd, met.ang);
    if (met.y > gh + 60 || met.x < -100) ds_list_delete(meteor_list, k);
    else meteor_list[| k] = met;
}