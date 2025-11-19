/// @description oCoinmac2 - Draw Event
// oMacs_parent의 Draw 이벤트를 호출하여 기본 UI 틀(패널, 아티팩트 등)을 그립니다.
event_inherited();

if (state == CoinMachine2State.IDLE) {
    exit;
}

// --- oCoinmac2 전용 그리기 --- //

#region Game Screen Content
// 게임 화면 중앙 좌표 계산
var _game_screen_x = panel_x + 20;
var _game_screen_y = panel_y + 60;
var _game_screen_w = panel_w - info_panel_width - 50;
var _game_screen_h = panel_h - 80;
var _game_cx = _game_screen_x + _game_screen_w / 2;
var _game_cy = _game_screen_y + _game_screen_h / 2;

var _coin_scale = 2;
var _scaled_sprite_width = sprite_get_width(sCoin) * _coin_scale;
var _total_coins_width = (_scaled_sprite_width + coin_spacing) * coin_count - coin_spacing;
var _start_x = _game_cx - _total_coins_width / 2;

// 코인 애니메이션 또는 결과 표시
if (state == CoinMachine2State.TOSSING) {
    var total_duration = single_coin_toss_duration + (toss_delay_per_coin * (coin_count - 1));
    var time_elapsed = total_duration - toss_timer;

    for (var i = 0; i < coin_count; i++) {
        var coin_start_time = i * toss_delay_per_coin;
        if (time_elapsed >= coin_start_time) {
            var progress = clamp((time_elapsed - coin_start_time) / single_coin_toss_duration, 0, 1);
            var _draw_x = _start_x + i * (_scaled_sprite_width + coin_spacing);

            if (progress >= 1) {
                draw_sprite_ext(sCoin, coin_results[i], _draw_x, _game_cy, _coin_scale, _coin_scale, 0, c_white, 1);
            } else {
                var y_offset = -sin(progress * pi) * 50;
                var coin_draw_y = _game_cy + y_offset;
                var scale_multiplier = 1 + sin(progress * pi) * 0.5;
                var current_scale = _coin_scale * scale_multiplier;
                var num_frames = sprite_get_number(sCoin_spin);
                var image_to_draw = (coin_frame_offsets[i] + progress * num_frames * 10) % num_frames;
                draw_sprite_ext(sCoin_spin, image_to_draw, _draw_x, coin_draw_y, current_scale, current_scale, 0, c_white, 1);
            }
        }
    }
} else if (state == CoinMachine2State.RESULT || state == CoinMachine2State.SETTLEMENT) {
    for (var i = 0; i < coin_count; i++) {
        var _draw_x = _start_x + i * (_scaled_sprite_width + coin_spacing);
        draw_sprite_ext(sCoin, coin_results[i], _draw_x, _game_cy, _coin_scale, _coin_scale, 0, c_white, 1);
    }
}
#endregion

#region Info Panel Buttons
// 정보 패널의 버튼들을 oCoinmac2의 상태에 맞게 그립니다.
var _info_panel_x = panel_x + panel_w - info_panel_width - 20;
var _info_panel_y = panel_y + 60;

if (state == CoinMachine2State.BETTING) {
    draw_custom_button(button_play, button_play.sprite, _info_panel_x, _info_panel_y);
} else if (state == CoinMachine2State.RESULT) {
    draw_custom_button(button_play_again, button_play_again.sprite, _info_panel_x, _info_panel_y);
} else if (state == CoinMachine2State.SETTLEMENT) {
    if (reroll_enabled && !reroll_used_this_turn) {
        draw_custom_button(button_reroll, button_reroll.sprite, _info_panel_x, _info_panel_y);
        draw_custom_button(button_settle, button_settle.sprite, _info_panel_x, _info_panel_y);
    } else {
        draw_custom_button(button_settle_full, button_settle_full.sprite, _info_panel_x, _info_panel_y);
    }
}
#endregion