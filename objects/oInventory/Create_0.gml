/// --- oInventory Create Event ---
/// Loads unlocked colors safely and prepares visuals

inv_index = 0;
fade_alpha = 0;

// --- Load unlocked colors ---
if (!variable_global_exists("unlocked_colors")) global.unlocked_colors = [];
if (!variable_global_exists("player_color")) global.player_color = c_white;

// --- Load from save.ini ---
if (file_exists("save.ini")) {
    ini_open("save.ini");
    var color_data = ini_read_string("PlayerData", "UnlockedColors", "");
    global.player_color = ini_read_real("PlayerData", "PlayerColor", c_white);
    ini_close();

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
}