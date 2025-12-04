/// @description Initialize the Traits System

// Make this manager persistent across rooms
persistent = true;

// Initialize all trait data and player trait storage
traits_init();

// --- For Testing Purposes --- 
// Add some traits to the player by default.
// You can remove or modify these calls later.
// show_debug_message("--- Initializing Default Player Traits for Testing ---");
// add_player_trait("start_money"); // Add level 1 of start_money
// add_player_trait("start_money"); // Add level 2 of start_money
// add_player_trait("stage_money"); // Add level 1 of stage_money
// add_player_trait("reward_SP");   // Add level 1 of reward_SP
// show_debug_message("--- Player Traits Initialized ---");