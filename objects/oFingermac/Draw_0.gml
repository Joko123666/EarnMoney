/// @description oFingermac - Draw Event (Refactored)

// 부모의 Draw 이벤트를 호출하여 기본 UI 패널을 그립니다.
event_inherited();

// IDLE 상태에서는 아무것도 그리지 않습니다.
if (state == FingerMacState.IDLE) {
    exit;
}

// --- 그리기 설정 ---
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// --- 게임 화면 좌표 ---
var _game_screen_x = panel_x + 20;
var _game_screen_y = panel_y + 60;
var _game_screen_w = panel_w - info_panel_width - 50;
var _game_screen_h = panel_h - 80;
var _game_cx = _game_screen_x + _game_screen_w / 2;
var _game_cy = _game_screen_y + _game_screen_h / 2;

// --- 상태별 그리기 --- 

// 손 스프라이트 좌표
var _hand_scale = 3;
var _shown_hand_x = _game_cx - 150;
var _hidden_hand_x = _game_cx + 150;
var _hand_y = _game_cy - 100;

switch (state) {
    case FingerMacState.DEALER_SETUP:
        draw_set_font(fnt_dialogue_main);
        draw_text(_game_cx, _game_cy, "딜러가 손 모양을 정하고 있습니다...");
        break;

    case FingerMacState.PLAYER_CHOICE:
        draw_set_font(fnt_dialogue_main);
        // 안내 문구
        draw_text(_game_cx, _game_cy - 250, "숨겨진 손의 숫자를 맞춰보세요!");
        draw_text(_shown_hand_x, _hand_y - 100, "[ 공개된 손 ]");
        draw_text(_hidden_hand_x, _hand_y - 100, "[ 숨겨진 손 ]");

        // 손 그리기
        draw_sprite_ext(sHand, shown_hand_value, _shown_hand_x, _hand_y, _hand_scale, _hand_scale, 0, c_white, 1);
        draw_sprite_ext(sHand_hidden, 0, _hidden_hand_x, _hand_y, _hand_scale, _hand_scale, 0, c_white, 1);

        // 선택 버튼 및 배당률 정보 그리기
        for (var i = 0; i < array_length(buttons_player_choice); i++) {
            var btn = buttons_player_choice[i];
            // 버튼은 절대 좌표를 사용하므로 base_x, base_y는 0으로 전달
            draw_custom_button(btn, btn.sprite, 0, 0);
            
            // 배당률 표시
            var _payout = (i == shown_hand_value) ? "x2" : "x10";
            draw_text(btn.x + btn.w/2, btn.y - 30, _payout);
        }
        break;

    case FingerMacState.REVEAL:
    case FingerMacState.RESULT:
        draw_set_font(fnt_dialogue_main);
        draw_text(_shown_hand_x, _hand_y - 100, "[ 공개된 손 ]");
        draw_text(_hidden_hand_x, _hand_y - 100, "[ 숨겨진 손 ]");

        // 공개된 손
        draw_sprite_ext(sHand, shown_hand_value, _shown_hand_x, _hand_y, _hand_scale, _hand_scale, 0, c_white, 1);

        // 숨겨진 손 (REVEAL 상태에서 서서히 나타나는 효과)
        var _alpha = (state == FingerMacState.REVEAL) ? 1 - (anim_timer / reveal_duration) : 1;
        draw_sprite_ext(sHand, hidden_hand_value, _hidden_hand_x, _hand_y, _hand_scale, _hand_scale, 0, c_white, _alpha);

        // 결과 메시지
        if (state == FingerMacState.RESULT && anim_timer <= 0) {
            draw_text(_game_cx, _game_cy + 150, "당신의 선택: " + string(player_guess));
            draw_text(_game_cx, _game_cy + 200, "배당률: x" + string(payout_rate));
            draw_text(_game_cx, _game_cy + 250, result_message);
        }
        break;
}

// --- 정보 패널 버튼 그리기 (오른쪽) ---
var _info_panel_x = panel_x + panel_w - info_panel_width - 20;
var _info_panel_y = panel_y + 60;

if (state == FingerMacState.BETTING) {
    draw_custom_button(button_play, button_play.sprite, _info_panel_x, _info_panel_y);
} else if (state == FingerMacState.RESULT && anim_timer <= 0) {
    draw_custom_button(button_play_again, button_play_again.sprite, _info_panel_x, _info_panel_y);
}

// --- 그리기 설정 초기화 ---
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
