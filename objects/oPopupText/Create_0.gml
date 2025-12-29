/// --- oPopupText Create Event ---
/// Initialize popup behavior
if (!variable_instance_exists(self, "text")) text = "!";
if (!variable_instance_exists(self, "color")) color = c_white;

image_alpha  = 1;      // start fully visible
image_xscale = 1;      // base scale
rise_speed   = 0.8;    // how fast it floats upward
fade_speed   = 0.02;   // how fast it fades
scale_pop    = 0.3;    // “pop” amount for visual feel