// Move particle
x += lengthdir_x(speed, direction);
y += lengthdir_y(speed, direction);

// Fade out
lifetime--;
image_alpha = (lifetime / 30) * 0.8;

// Destroy when done
if (lifetime <= 0) {
    instance_destroy();
}