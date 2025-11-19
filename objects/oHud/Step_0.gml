/// @description oHud - Step Event

// --- Camera Movement ---
var cam = view_camera[0];
var current_cam_y = camera_get_view_y(cam);

// Smoothly move the camera towards the target Y position
if (abs(current_cam_y - camera_y_to) > 1) {
    var new_y = lerp(current_cam_y, camera_y_to, camera_lerp_speed);
    camera_set_view_pos(cam, camera_get_view_x(cam), new_y);
} else {
    camera_set_view_pos(cam, camera_get_view_x(cam), camera_y_to);
}

// --- Scroll Button Click Detection ---
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

var btn_x = (gui_w - scroll_button.w) / 2;
var btn_y;

if (camera_location == CameraLocation.TOP) {
    // Button is at the bottom center
    btn_y = gui_h - scroll_button.h - 10; // 10px padding from bottom
} else { // CameraLocation.BOTTOM
    // Button is at the top center
    btn_y = 10; // 10px padding from top
}

// Check for click
if (mouse_check_button_pressed(mb_left) && 
    point_in_rectangle(mx, my, btn_x, btn_y, btn_x + scroll_button.w, btn_y + scroll_button.h)) {
    
    // Toggle camera location and set new target Y
    if (camera_location == CameraLocation.TOP) {
        camera_location = CameraLocation.BOTTOM;
        camera_y_to = room_bottom_y;
    } else {
        camera_location = CameraLocation.TOP;
        camera_y_to = room_top_y;
    }
}


// --- Existing Code ---

// 게임 오버 팝업이 활성화되어 있을 때만 버튼 클릭 확인
if (show_game_over_popup) {
    // 메인 메뉴로 버튼 클릭 확인
    if (mouse_check_button_pressed(mb_left) && 
        point_in_rectangle(mx, my, button_main_menu.x, button_main_menu.y, button_main_menu.x + button_main_menu.w, button_main_menu.y + button_main_menu.h)) {
        
        // oGame의 게임 오버 상태 초기화
        if (instance_exists(oGame)) {
            oGame.game_over_state = "none";
            oGame.game_over_alpha = 0;
        }
        
        room_goto(Mainmenu);
    }
}

// 게임 오버 상태 확인
if (instance_exists(oGame) && oGame.game_over_state == "active" && !show_game_over_popup) {
    show_game_over_popup = true;
}

if (alart_count > 0)
{
	alart_count--;
}

function set_result(_time, _img)
{
	result_time = _time;
	result_img = _img;
	draw_result = true;
}

function set_coin(_bet)
{
	coin_bet = _bet;
	coin_count = 30;
	coin_speed = 10;
	game_coin = true;
}

function set_alart()
{
	alart_count = 45;
}
