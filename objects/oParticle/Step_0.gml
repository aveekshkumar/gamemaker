// Fade out
image_alpha -= fade_speed;
life_timer--;

// Destroy when faded or timer runs out
if image_alpha <= 0 || life_timer <= 0 {
    instance_destroy();
}