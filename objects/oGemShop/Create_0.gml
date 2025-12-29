/// --- oGemShop Create Event ---
/// Loads gems and unlocked colors safely, defines shop list

// --- Safe initialize globals ---
if (!variable_global_exists("total_gems")) global.total_gems = 0;
if (!variable_global_exists("unlocked_colors")) global.unlocked_colors = [];

// --- Load from save.ini ---
if (file_exists("save.ini")) {
    ini_open("save.ini");

    // Gems
    global.total_gems = ini_read_real("PlayerData", "Gems", 0);

    // Unlocked colors
    var color_data = ini_read_string("PlayerData", "UnlockedColors", "");
    if (color_data != "") {
        var list = string_split(color_data, ",");
        global.unlocked_colors = [];
        for (var i = 0; i < array_length(list); i++) {
            var s = string_trim(list[i]);
            if (string_length(s) > 0) {
                array_push(global.unlocked_colors, real(s));
            }
        }
    }
    ini_close();
}

// --- Define gem shop colors ---
gem_colors = [
    c_red, c_orange, c_yellow, c_lime, c_aqua,
    c_blue, c_purple, c_fuchsia
];
gem_prices = [5, 10, 15, 20, 25, 30, 40, 55];
gem_names  = ["Red", "Orange", "Yellow", "Green", "Light Blue", "Dark Blue", "Purple", "Pink"];

gem_index = 0;
fade_alpha = 0;