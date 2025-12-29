/// oFirework Create
x = irandom_range(40, room_width - 40);
y = irandom_range(80, 200);

rise_speed = random_range(-6, -9); // shoot upward
spark_count = irandom_range(18, 26);
life = 0;
explode_time = irandom_range(25, 35);
color_main = choose(c_yellow, c_aqua, c_red, c_fuchsia, c_lime);
particles = [];

for (var i = 0; i < spark_count; i++) {
    var ang = irandom(360);
    var spd = random_range(2, 4);
    array_push(particles, [0, 0, lengthdir_x(spd, ang), lengthdir_y(spd, ang)]);
}