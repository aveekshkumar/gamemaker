/// --- oSpawner Draw GUI Event ---
/// Displays level/stage completion banners or final victory messages

if (global.banner_visible) {
    var gw = display_get_gui_width();
    var gh = display_get_gui_height();

    // Center setup
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Smooth fade based on timer
    var fade = clamp(global.banner_timer / (room_speed * 2), 0, 1);
    draw_set_alpha(fade);

    // Text color & outline effect
    draw_set_color(c_white);
    draw_text(gw * 0.5, gh * 0.4, global.level_banner);

    // Add subtle glow background behind text
    gpu_set_blendmode(bm_add);
    draw_set_color(make_color_rgb(0, 180, 255));
    draw_text(gw * 0.5 + 2, gh * 0.4 + 2, global.level_banner);
    gpu_set_blendmode(bm_normal);

    draw_set_alpha(1);

    // Reduce timer gradually
    global.banner_timer--;
    if (global.banner_timer <= 0) {
        global.banner_visible = false;
    }
}