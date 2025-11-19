/// @description oMultiplymac - Draw Event (Refactored)

// 부모의 Draw 이벤트를 호출하여 기본 UI 패널을 그립니다.
event_inherited();

// IDLE 상태에서는 아무것도 그리지 않습니다.
if (state == MultiplyMacState.IDLE) {
    exit;
}

// --- 그리기 설정 ---
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fnt_dialogue_name);

// --- 게임 화면 좌표 ---
var _game_screen_x = panel_x + 20;
var _game_screen_y = panel_y + 60;
var _game_screen_w = panel_w - info_panel_width - 50;
var _game_screen_h = panel_h - 80;
var _game_cx = _game_screen_x + _game_screen_w / 2;
var _game_cy = _game_screen_y + _game_screen_h / 2;

// --- 상태별 그리기 --- 
switch (state) {
    case MultiplyMacState.SPINNING:
        // 두 개의 숫자가 빠르게 변하는 것을 보여줍니다.
        var _num1 = irandom_range(1, 9);
        var _num2 = irandom_range(1, 9);
        draw_text(_game_cx - 100, _game_cy, string(_num1));
        draw_text(_game_cx, _game_cy, "x");
        draw_text(_game_cx + 100, _game_cy, string(_num2));
        break;

    case MultiplyMacState.RESULT:
        // 최종 결과를 보여줍니다.
        draw_text(_game_cx - 100, _game_cy, string(number1));
        draw_text(_game_cx, _game_cy, "x");
        draw_text(_game_cx + 100, _game_cy, string(number2));
        draw_text(_game_cx, _game_cy + 50, "= " + string(game_result));
        
        // 결과 메시지
        if (anim_timer <= 0) {
            draw_set_font(fnt_dialogue_main);
            draw_text(_game_cx, _game_cy + 150, result_message);
        }
        break;
}

// --- 정보 패널 버튼 그리기 ---
var _info_panel_x = panel_x + panel_w - info_panel_width - 20;
var _info_panel_y = panel_y + 60;

if (state == MultiplyMacState.BETTING) {
    draw_custom_button(button_play, button_play.sprite, _info_panel_x, _info_panel_y);
} else if (state == MultiplyMacState.RESULT && anim_timer <= 0) {
    draw_custom_button(button_play_again, button_play_again.sprite, _info_panel_x, _info_panel_y);
}

// --- 그리기 설정 초기화 ---
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
