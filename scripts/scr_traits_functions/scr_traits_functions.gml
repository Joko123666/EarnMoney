/// @function traits_init()
/// @description Initializes the global trait data structures.
function traits_init() {
    // Load all traits from the data script
    global.all_traits = scr_traits_data();
    
    // Sort traits by traits_num for ordered display
    array_sort(global.all_traits, function(trait1, trait2) {
        return trait1.traits_num - trait2.traits_num;
   });
   
   // Initialize player's traits map, preventing memory leaks on reset
   if (variable_global_exists("player_traits")) {
	   // If it exists, it must be a ds_map from a previous init, so destroy it 
	   ds_map_destroy(global.player_traits);
   }
   // Now, create it fresh   
   global.player_traits = ds_map_create();
}

/// @function add_player_trait(trait_name)
/// @description Adds a trait to the player's collection or levels it up.
/// @param {string} trait_name The name of the trait to add (e.g., "start_money").
function add_player_trait(trait_name) {
    show_debug_message("DEBUG: add_player_trait called for: " + trait_name);
    var _current_level = get_player_trait_level(trait_name);
    
    // Find the trait's max level from the master list
    var _max_level = 0;
    for (var i = 0; i < array_length(global.all_traits); i++) {
        if (global.all_traits[i].name == trait_name) {
            _max_level = global.all_traits[i].traits_level;
            break;
        }
    }
    show_debug_message("DEBUG: _current_level: " + string(_current_level) + " | _max_level: " + string(_max_level));
    show_debug_message("DEBUG: Condition result: " + string(_max_level > 0 && _current_level < _max_level));
    
    // Add or level up the trait if not at max level
    if (_max_level > 0 && _current_level < _max_level) {
        ds_map_set(global.player_traits, trait_name, _current_level + 1);
        show_debug_message("DEBUG: Trait Added/Leveled Up: " + trait_name + " | New Level: " + string(_current_level + 1) + " | global.player_traits after update: " + string(global.player_traits));
    } else {
        show_debug_message("Trait '" + trait_name + "' is already at max level or does not exist.");
    }
}

/// @function get_player_trait_level(trait_name)
/// @description Gets the current level of a specific trait for the player.
/// @param {string} trait_name The name of the trait to check.
/// @return {real} The current level of the trait (0 if not acquired).
function get_player_trait_level(trait_name) {
    if (!variable_global_exists("player_traits")) {
        return 0;
    }
    var _level = global.player_traits[? trait_name];
    if (is_undefined(_level)) {
        return 0;
    }
    return _level;
}
