/// @description oUI_money - Draw GUI Event

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

// --- Left Panel (Player Info) ---
var _info_panel_x = _padding;
var _info_panel_y = _padding;
var _info_panel_w = 200;
// 한글 주석: 모든 정보를 표시하기 위해 높이를 늘립니다.
var _info_panel_h = 145; 

// Draw Panel Background
draw_set_color(_panel_color);
draw_set_alpha(_panel_alpha);
draw_rectangle(_info_panel_x, _info_panel_y, _info_panel_x + _info_panel_w, _info_panel_y + _info_panel_h, false);
draw_set_alpha(1);

// Draw Panel Border
draw_set_color(_border_color);
draw_rectangle(_info_panel_x, _info_panel_y, _info_panel_x + _info_panel_w, _info_panel_y + _info_panel_h, true);

// Draw Text
draw_set_font(mainfont);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(_text_color);

// Player Money
// 한글 주석: display_money 값을 정수로 반올림하여 표시합니다.
draw_text(_info_panel_x + _info_panel_w / 2, _info_panel_y + 20, "Player money");
draw_text(_info_panel_x + _info_panel_w / 2, _info_panel_y + 40, string(round(display_money)) + " D");
// 한글 주석: Player money 옆에 sIcon의 4번째 이미지를 그립니다.
var _player_money_str = string(round(display_money)) + " D";
var _player_money_str_width = string_width(_player_money_str);
var _player_money_icon_x = (_info_panel_x + _info_panel_w / 2) + _player_money_str_width / 2 + (sprite_get_width(sIcon) / 2) + 5;
var _player_money_icon_y = _info_panel_y + 40;
draw_sprite(sIcon, 4, _player_money_icon_x, _player_money_icon_y);

// Chances
draw_text(_info_panel_x + _info_panel_w / 2, _info_panel_y + 70, "Chances Left: " + string(oGame.chance_last));

// Target Amount
draw_text(_info_panel_x + _info_panel_w / 2, _info_panel_y + 95, "Target: " + string(oGame.target_amount));

// Lose Tokens
draw_text(_info_panel_x + _info_panel_w / 2, _info_panel_y + 120, "Lose Tokens: " + string(oGame.lose_token));
// 한글 주석: Lose Tokens 옆에 sIcon의 5번째 이미지를 그립니다.
var _lose_token_str = "Lose Tokens: " + string(oGame.lose_token);
var _lose_token_str_width = string_width(_lose_token_str);
var _lose_token_icon_x = (_info_panel_x + _info_panel_w / 2) + _lose_token_str_width / 2 + (sprite_get_width(sIcon) / 2) + 5;
var _lose_token_icon_y = _info_panel_y + 120;
draw_sprite(sIcon, 5, _lose_token_icon_x, _lose_token_icon_y);


// --- 금액 변화량 텍스트 그리기 ---
// 한글 주석: 애니메이션이 진행 중일 때만 (알파값이 0보다 클 때) 텍스트를 그립니다.
if (change_alpha > 0) {
    var _text = "";
    var _color = c_white;
    
    // 한글 주석: 변화량이 양수일 때와 음수일 때 텍스트와 색상을 다르게 설정합니다.
    if (change_amount > 0) {
        _text = "+" + string(change_amount);
        _color = c_lime; // 밝은 녹색
    } else {
        _text = string(change_amount);
        _color = c_red;   // 빨간색
    }
    
    // 한글 주석: 텍스트에 적용될 최종 투명도를 계산합니다. (1을 넘지 않도록)
    var _alpha = min(1, change_alpha);
    
    // 한글 주석: 계산된 위치, 색상, 투명도로 변화량 텍스트를 그립니다.
    draw_set_font(mainfont); // 폰트 설정
    draw_set_halign(fa_left); // 정렬 설정
    draw_set_valign(fa_middle);
    draw_text_color(_info_panel_x + _info_panel_w + _padding, _info_panel_y + 40 + change_y_offset, _text, _color, _color, _color, _color, _alpha);
}

// --- Reset Draw Settings ---
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);

#endregion