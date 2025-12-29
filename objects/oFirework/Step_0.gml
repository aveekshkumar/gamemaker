/// oFirework Step

y += rise_speed;
rise_speed *= 0.92; // slow rise
life++;

if (life >= explode_time) {
    // Start explosion
    for (var i = 0; i < array_length(particles); i++) {
        var p = particles[i];
        p[0] += p[2];
        p[1] += p[3];
        p[3] += 0.15; // gravity
        p[2] *= 0.97;
        p[3] *= 0.97;
        particles[i] = p;
    }

    if (life > explode_time + 45) instance_destroy();
}