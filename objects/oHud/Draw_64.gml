
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
