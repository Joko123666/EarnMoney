/// @description oCoinmac - Draw Event
// oMacs_parent의 Draw 이벤트를 호출하여 기본 UI 틀(패널, 공통 버튼 등)을 그립니다.
event_inherited();

// 부모 Draw에서 IDLE 상태일 때 exit 처리하므로, 여기서는 별도 처리가 필요 없습니다.
if (state == CoinMachineState.IDLE) exit;


// --- oCoinmac 전용 그리기 --- //
// 부모가 그린 UI 위에 이 게임만의 요소를 추가로 그립니다.

#region Game Screen Content
// 부모가 그려준 게임 화면 영역의 좌표를 가져옵니다.
var _game_screen_x = panel_x + 20;
var _game_screen_y = panel_y + 60;
var _game_screen_w = panel_w - info_panel_width - 50;
var _game_screen_h = panel_h - 80;

// 게임 화면 중앙 좌표
var _game_cx = _game_screen_x + _game_screen_w / 2;
var _game_cy = _game_screen_y + _game_screen_h / 2;
var _coin_scale = 4; // 코인 크기

// 여러 코인을 수평으로 정렬하기 위한 계산
var _sprite_w = sprite_get_width(sCoin) * _coin_scale;
var _total_width = (coin_count * _sprite_w) + (max(0, coin_count - 1) * coin_spacing);
var _start_x = _game_cx - _total_width / 2 + _sprite_w / 2;

// 코인 던지는 중일 때 애니메이션 처리
if (state == CoinMachineState.TOSSING) {
    var progress = 1 - (toss_timer / single_coin_toss_duration);
    
    for (var i = 0; i < coin_count; i++) {
        var _draw_x = _start_x + i * (_sprite_w + coin_spacing);
        
        if (progress >= 1) {
            draw_sprite_ext(sCoin, coin_results[i], _draw_x, _game_cy, _coin_scale, _coin_scale, 0, c_white, 1);
        } else {
            var y_offset = -sin(progress * pi) * 70;
            var coin_draw_y = _game_cy + y_offset;
            var scale_multiplier = 1 + sin(progress * pi) * 0.6;
            var current_scale = _coin_scale * scale_multiplier;
            var num_frames = sprite_get_number(sCoin_spin);
            var image_to_draw = (coin_frame_offsets[i] + progress * num_frames * 12) % num_frames;
            draw_sprite_ext(sCoin_spin, image_to_draw, _draw_x, coin_draw_y, current_scale, current_scale, 0, c_white, 1);
        }
    }
} else if (state == CoinMachineState.RESULT || state == CoinMachineState.SETTLEMENT) {
    // 결과 또는 정산 상태일 때 최종 결과 코인 표시
    for (var i = 0; i < coin_count; i++) {
        var _draw_x = _start_x + i * (_sprite_w + coin_spacing);
        draw_sprite_ext(sCoin, coin_results[i], _draw_x, _game_cy, _coin_scale, _coin_scale, 0, c_white, 1);
    }

    // 결과 메시지 표시 (RESULT 상태에서만)
    if (state == CoinMachineState.RESULT) {
        draw_set_font(fnt_dialogue_main);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(_game_cx, _game_cy + 150, result_message);
    }
}
#endregion


#region Info Panel Buttons
// 정보 패널의 좌표를 가져옵니다.
var _info_panel_x = panel_x + panel_w - info_panel_width - 20;
var _info_panel_y = panel_y + 60;

// 상태에 맞는 액션 버튼을 그립니다.
if (state == CoinMachineState.BETTING) {
    draw_custom_button(button_play, button_play.sprite, _info_panel_x, _info_panel_y);
} else if (state == CoinMachineState.RESULT) {
    draw_custom_button(button_play_again, button_play_again.sprite, _info_panel_x, _info_panel_y);
} else if (state == CoinMachineState.SETTLEMENT) {
    if (reroll_enabled && !reroll_used_this_turn) {
        draw_custom_button(button_reroll, button_reroll.sprite, _info_panel_x, _info_panel_y);
        draw_custom_button(button_settle, button_settle.sprite, _info_panel_x, _info_panel_y);
    } else {
        draw_custom_button(button_settle_full, button_settle_full.sprite, _info_panel_x, _info_panel_y);
    }
}
#endregion
