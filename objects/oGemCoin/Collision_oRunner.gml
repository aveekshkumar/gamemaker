/// --- oGemCoin Collision with oRunner ---

// Increase gems
other.gems += 1;
global.total_gems += 1;

// Save gems safely
ini_open("save.ini");
ini_write_real("PlayerData", "Gems", global.total_gems);
ini_close();


// --- Spark Effect (for gem pickup) ---
if (!variable_global_exists("spark_system")) {

    // Create system ONLY ONCE
    global.spark_system = part_system_create();
    global.spark_type = part_type_create();

    part_type_shape(global.spark_type, pt_shape_spark);
    part_type_size(global.spark_type, 0.7, 1.2, 0, 0);
    part_type_color2(global.spark_type, c_aqua, c_white);
    part_type_alpha3(global.spark_type, 1, 0.7, 0);
    part_type_speed(global.spark_type, 2, 4, 0, 0);
    part_type_direction(global.spark_type, 0, 360, 0, 0);
    part_type_life(global.spark_type, 12, 18);
}

// Emit particles at the coin location
part_particles_create(global.spark_system, x, y, global.spark_type, 10);

// Destroy gem coin instance
instance_destroy();