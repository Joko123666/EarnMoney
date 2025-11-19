
var _centerx = display_get_gui_width()/2;
var _centery = display_get_gui_height()/2;
var _bottom = display_get_gui_height();
var _right = display_get_gui_width();

if (alart_count > 0)	//Empty Money Alart
{
	var _width = 128;
	var _height = 64;
	draw_rectangle(_centerx-_width/2, _centery-_height/2, _centerx+_width/2, _centery+_height/2, 0 );
	draw_text(_centerx, _centery, "Not Enough Money");
}



if (show_game_over_popup) {
    var _cx = display_get_gui_width() / 2;
    var _cy = display_get_gui_height() / 2;
    
    var _popup_x = _cx - popup_width / 2;
    var _popup_y = _cy - popup_height / 2;
    
    // 팝업 배경
    draw_set_color(c_black);
    draw_set_alpha(0.8);
    draw_rectangle(_popup_x, _popup_y, _popup_x + popup_width, _popup_y + popup_height, false);
    draw_set_alpha(1);
    
    // "Game Over" 텍스트
    draw_set_font(font_main);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(_cx, _popup_y + 50, "Game Over");
    
    // 메인 메뉴로 버튼
    button_main_menu.x = _cx - button_main_menu.w / 2;
    button_main_menu.y = _cy + 20;
    
    var _btn = button_main_menu;
    var _color = c_white;
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);

    if (point_in_rectangle(mx, my, _btn.x, _btn.y, _btn.x + _btn.w, _btn.y + _btn.h)) {
        _color = c_yellow;
    }
    
    draw_sprite_stretched(sButton, 0, _btn.x, _btn.y, _btn.w, _btn.h);
    draw_set_color(_color);
    draw_text(_btn.x + _btn.w / 2, _btn.y + _btn.h / 2, _btn.label);
    
    // 그리기 설정 초기화
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

#region UI Elements

// Get GUI dimensions
var _gui_width = display_get_gui_width();
var _gui_height = display_get_gui_height();

// Colors and Alpha
var _text_color = c_white;
var _panel_color = c_black;
var _panel_alpha = 0.5;
var _border_color = c_dkgray;

// General Padding
var _padding = 10;

// --- Reset Draw Settings ---
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);

#endregion

// --- Camera Scroll Button ---
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();
var btn_x = (gui_w - scroll_button.w) / 2;
var btn_y;
var btn_sprite_index;

if (camera_location == CameraLocation.TOP) {
    // Show Down Arrow at the bottom
    btn_y = gui_h - scroll_button.h - 10;
    btn_sprite_index = scroll_button.down_index;
} else { // CameraLocation.BOTTOM
    // Show Up Arrow at the top
    btn_y = 10;
    btn_sprite_index = scroll_button.up_index;
}

draw_sprite(scroll_button.sprite, btn_sprite_index, btn_x, btn_y);
