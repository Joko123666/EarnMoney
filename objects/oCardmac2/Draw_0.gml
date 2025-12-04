/// @description oCardmac2 - Draw Event
event_inherited();
if (state == CardMac2State.IDLE) exit;

// --- 그리기 설정 및 좌표 ---
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _game_screen_x = panel_x + 20;
var _game_screen_y = panel_y + 60;
var _game_screen_w = panel_w - info_panel_width - 50;
var _game_screen_h = panel_h - 80;
var _game_cx = _game_screen_x + _game_screen_w / 2;
var _game_cy = _game_screen_y + _game_screen_h / 2;

// --- 정보 패널 기준 좌표 (버튼 위치 계산용) ---
var _info_panel_x = panel_x + panel_w - info_panel_width - 20;
var _info_panel_y = panel_y + 60;

// --- 카드 위치 정의 ---
var _player_card_x = _game_cx;
var _player_card_y = _game_cy + 100;
var _dealer_card_x = _game_cx;
var _dealer_card_y = _game_cy - 100;

// --- 상태별 그리기 --- 
switch (state) {
    case CardMac2State.DEALING:
        var _progress = 1 - (anim_timer / deal_duration);
        // 딜러 카드 (뒷면) 애니메이션
        var _dealer_start_y = _dealer_card_y - 150;
        draw_sprite(sCard_back, 0, _dealer_card_x, lerp(_dealer_start_y, _dealer_card_y, _progress));
        // 플레이어 카드 (앞면) 애니메이션
        var _player_start_y = _player_card_y + 150;
        draw_sprite(sCard_front, player_card_value - 1, _player_card_x, lerp(_player_start_y, _player_card_y, _progress));
        break;

    case CardMac2State.PLAYER_CHOICE:
    case CardMac2State.REVEAL:
    case CardMac2State.RESULT:
        // --- 카드 및 라벨 그리기 ---
        draw_set_font(fnt_dialogue_main);
        draw_text(_player_card_x, _player_card_y + 80, "PLAYER");
        draw_text(_dealer_card_x, _dealer_card_y - 80, "DEALER");

        // 플레이어 카드 (항상 앞면)
        draw_sprite(sCard_front, player_card_value - 1, _player_card_x, _player_card_y);

        // 딜러 카드 (상태에 따라 앞/뒷면 변경)
        var _dealer_sprite = sCard_back;
        var _dealer_frame = 0;
        var _dealer_x_scale = 1;

        if (state == CardMac2State.REVEAL) {
            var _flip_progress = (1 - (anim_timer / reveal_duration)) * 2;
            if (_flip_progress <= 1) {
                _dealer_x_scale = 1 - _flip_progress;
            } else {
                _dealer_x_scale = _flip_progress - 1;
                _dealer_sprite = sCard_front;
                _dealer_frame = dealer_card_value - 1;
            }
        } else if (state == CardMac2State.RESULT) {
            _dealer_sprite = sCard_front;
            _dealer_frame = dealer_card_value - 1;
        }
        draw_sprite_ext(_dealer_sprite, _dealer_frame, _dealer_card_x, _dealer_card_y, _dealer_x_scale, 1, 0, c_white, 1);

        // --- 추가 정보 그리기 ---
        if (state == CardMac2State.PLAYER_CHOICE) {
            // 동적 배당률 표시 (상대 좌표 계산)
            draw_set_font(fnt_dialogue_name);
            var _high_x = _info_panel_x + button_choice_high.rel_x;
            var _high_y = _info_panel_y + button_choice_high.rel_y;
            draw_text(_high_x + button_choice_high.w/2, _high_y - 25, "x" + string(payout_high));
            
            var _low_x = _info_panel_x + button_choice_low.rel_x;
            var _low_y = _info_panel_y + button_choice_low.rel_y;
            draw_text(_low_x + button_choice_low.w/2, _low_y - 25, "x" + string(payout_low));
            
            var _same_x = _info_panel_x + button_choice_same.rel_x;
            var _same_y = _info_panel_y + button_choice_same.rel_y;
            draw_text(_same_x + button_choice_same.w/2, _same_y - 25, "x" + string(payout_same));
        } else if (state == CardMac2State.RESULT && anim_timer <= 0) {
            // 최종 결과 메시지
            draw_set_font(fnt_dialogue_main);
            draw_text(_game_cx, _game_cy, result_message);
        }
        break;
}

// --- 정보 패널 UI 그리기 (오른쪽) ---
switch (state) {
    case CardMac2State.PLAYER_CHOICE:
        draw_custom_button(button_choice_high, button_choice_high.sprite, _info_panel_x, _info_panel_y);
        draw_custom_button(button_choice_low, button_choice_low.sprite, _info_panel_x, _info_panel_y);
        draw_custom_button(button_choice_same, button_choice_same.sprite, _info_panel_x, _info_panel_y);
        break;
    case CardMac2State.RESULT:
        if (anim_timer <= 0) {
            draw_custom_button(button_play_again, button_play_again.sprite, _info_panel_x, _info_panel_y);
        }
        break;
}

// 그리기 설정 초기화
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);