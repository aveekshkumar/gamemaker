/// --- oPlayerPreview Draw Event ---
/// Draw player with current color

// Get current color
var col = global.unlocked_colors[cycle_index];

// Draw player sprite with tint
draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, 0, col, 1);

// UI text
draw_set_halign(fa_center);
draw_set_color(c_lime);
draw_text(x, y + 80, "Preview Mode");
draw_text(x, y + 110, "← / →  Cycle Colors");
draw_text(x, y + 140, "ESC to return");