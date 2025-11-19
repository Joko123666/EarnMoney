
/// @description oHud - Create Event

// Existing variables
moneyalart = false;
alart_count = 0;
game_coin = false;
coin_count = 0;
coin_speed = 0;
coin_bet = 0;
x_var = 0;
y_var = 0;
draw_result = false;
result_img = "defalt";
result_time = 0;
show_game_over_popup = false;
popup_width = 300;
popup_height = 200;
button_main_menu = { x: 0, y: 0, w: 180, h: 50, label: "메인 메뉴로" };

// --- Camera Control Variables ---

// Enum to define camera positions
enum CameraLocation {
    TOP,
    BOTTOM
}

// Camera state and position variables
camera_location = CameraLocation.TOP; // Start at the top
camera_y_to = camera_get_view_y(view_camera[0]); // Target Y position
camera_lerp_speed = 0.1; // Smoothing speed for camera movement

// Define the Y coordinates for top and bottom views
// These might need adjustment based on your room size and layout.
// Assuming a 1600x1600 room and a standard 16:9 viewport.
var _view_h = camera_get_view_height(view_camera[0]);
room_top_y = 0;
room_bottom_y = 1400 - _view_h;

// --- Scroll Button Properties ---
// Using a single struct for the button, its position and sprite will change.
scroll_button = {
    w: 64, // width
    h: 64, // height
    sprite: sIcon, // The sprite containing the arrow icons
    up_index: 2,   // Sprite index for the up arrow
    down_index: 3  // Sprite index for the down arrow
};



