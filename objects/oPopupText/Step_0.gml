/// --- oPopupText Step Event ---
/// Float upward and fade out smoothly
y -= rise_speed;
image_alpha -= fade_speed;
image_xscale = 1 + (1 - image_alpha) * scale_pop;

if (image_alpha <= 0) instance_destroy();