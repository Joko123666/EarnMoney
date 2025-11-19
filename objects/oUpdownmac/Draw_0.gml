/// @description oUpdownmac - Draw Event
event_inherited();

if (state == UpdownMachineState.IDLE) {
    exit;
}

// --- oUpdownmac 전용 그리기 --- //

#region Game Screen Content (Override)
var _game_screen_x = 250; 
var _game_screen_y = 80;  
var _game_screen_w = 700; 
var _game_screen_h = 700; 
var _game_screen_color = #1A1A1A;
draw_set_color(_game_screen_color);
draw_roundrect_ext(_game_screen_x, _game_screen_y, _game_screen_x + _game_screen_w, _game_screen_y + _game_screen_h, 10, 10, false);
draw_set_color(c_black);
draw_roundrect_ext(_game_screen_x, _game_screen_y, _game_screen_x + _game_screen_w, _game_screen_y + _game_screen_h, 10, 10, true);

var _game_cx = _game_screen_x + _game_screen_w / 2;
var _game_cy = _game_screen_y + _game_screen_h / 2;
var _dice_spacing = 150;

if (state >= UpdownMachineState.ROLLING) {
    var _d1x = _game_cx - _dice_spacing;
    draw_sprite_ext(sDice, dice1_value - 1, _d1x, _game_cy, dice1_scale, dice1_scale, 0, c_white, 1);
    
    var _d2x = _game_cx + _dice_spacing;
    draw_sprite_ext(sDice, dice2_value - 1, _d2x, _game_cy, dice2_scale, dice2_scale, 0, c_white, 1);

    draw_set_font(fnt_dialogue_main);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    var _text_y_offset = 100;

    if (reveal_step >= 1) { draw_text(_d1x, _game_cy + _text_y_offset, string(dice1_value)); }
    if (reveal_step >= 2) { draw_text(_d2x, _game_cy + _text_y_offset, string(dice2_value)); }
    if (reveal_step >= 3) {
        draw_set_font(fnt_dialogue_name);
        draw_text(_game_cx, _game_cy, "+");
        draw_text(_game_cx, _game_cy + 50, "=");
        draw_text(_game_cx, _game_cy + 100, string(dice_sum));
    }
}

if (state == UpdownMachineState.RESULT) {
    draw_set_font(fnt_dialogue_name);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(result_message == "You Win!" ? c_yellow : c_red);
    draw_text(_game_cx, _game_cy - 200, result_message);
}
#endregion

#region Info Panel Content (Override)
// 게임 정보 (배당률) 다시 그리기
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_ltgray);
var _info_text_x = 1025 + 15;
var _info_text_y = 331 + 15;

if (state < UpdownMachineState.CHOOSING) {
    draw_text(_info_text_x, _info_text_y, "Payouts:");
    draw_text(_info_text_x, _info_text_y + 40, "Up/Down: " + string(payout_down) + "x");
    draw_text(_info_text_x, _info_text_y + 80, "Seven: " + string(payout_seven) + "x");
}

// 버튼 다시 그리기
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

if (state == UpdownMachineState.BETTING) {
    draw_sprite_stretched(sButton, 0, button_play.x, button_play.y, button_play.w, button_play.h);
    draw_text(button_play.x + button_play.w/2, button_play.y + button_play.h/2, button_play.label);
} else if (state == UpdownMachineState.CHOOSING) {
    // 선택 버튼들
    draw_sprite_stretched(sButton, 0, button_down.x, button_down.y, button_down.w, button_down.h);
    draw_text(button_down.x + button_down.w/2, button_down.y + button_down.h/2, button_down.label);
    
    draw_sprite_stretched(sButton, 0, button_seven.x, button_seven.y, button_seven.w, button_seven.h);
    draw_text(button_seven.x + button_seven.w/2, button_seven.y + button_seven.h/2, button_seven.label);

    draw_sprite_stretched(sButton, 0, button_up.x, button_up.y, button_up.w, button_up.h);
    draw_text(button_up.x + button_up.w/2, button_up.y + button_up.h/2, button_up.label);
} else if (state == UpdownMachineState.RESULT) {
    draw_sprite_stretched(sButton, 0, button_play_again.x, button_play_again.y, button_play_again.w, button_play_again.h);
    draw_text(button_play_again.x + button_play_again.w/2, button_play_again.y + button_play_again.h/2, button_play_again.label);
}
#endregion

// 그리기 설정 초기화
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
