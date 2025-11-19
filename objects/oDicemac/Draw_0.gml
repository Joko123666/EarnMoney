/// @description oDicemac - Draw Event (Refactored)
// oMacs_parent의 Draw 이벤트를 호출하여 기본 UI 틀을 그립니다.
event_inherited();

if (state == DiceMachineState.IDLE) {
    exit;
}

// --- oDicemac 전용 그리기 --- //

#region Game Screen Content
// 부모가 그려준 게임 화면 영역의 좌표를 가져옵니다.
var _game_screen_x = panel_x + 20;
var _game_screen_y = panel_y + 60;
var _game_screen_w = panel_w - info_panel_width - 50;
var _game_screen_h = panel_h - 80;
var _game_cx = _game_screen_x + _game_screen_w / 2;
var _game_cy = _game_screen_y + _game_screen_h / 2;

if (state == DiceMachineState.ROLLING) {
    // 롤링 애니메이션: sDice_roll 스프라이트 사용
    var _frame = (get_timer() / 50) mod sprite_get_number(sDice_roll);
    draw_sprite(sDice_roll, _frame, _game_cx, _game_cy);
} else if (state == DiceMachineState.RESULT || state == DiceMachineState.SETTLEMENT) {
    // 최종 결과 주사위 표시
    draw_sprite(sDice, dice_result - 1, _game_cx, _game_cy);
    
    // 결과 메시지 표시
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(_game_cx, _game_cy + 100, result_message);
}
#endregion

#region Info Panel Content
// 정보 패널의 좌표를 가져옵니다.
var _info_panel_x = panel_x + panel_w - info_panel_width - 20;
var _info_panel_y = panel_y + 60;

// 부모가 그리지 않는 추가 정보(게임 규칙)를 그립니다.
draw_set_font(fnt_dialogue_main);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_ltgray);

var _info_text_y = _info_panel_y + 200; // 베팅 UI 아래쪽
draw_text(_info_panel_x + info_panel_width / 2, _info_text_y, "Target: " + string(target_number));
draw_text(_info_panel_x + info_panel_width / 2, _info_text_y + 40, "Payout: " + string(payout_rate) + "x");


// 상태에 맞는 액션 버튼을 그립니다.
if (state == DiceMachineState.BETTING) {
    draw_custom_button(button_play, button_play.sprite, _info_panel_x, _info_panel_y);
} else if (state == DiceMachineState.RESULT) {
    draw_custom_button(button_play_again, button_play_again.sprite, _info_panel_x, _info_panel_y);
} else if (state == DiceMachineState.SETTLEMENT) {
    if (dice_result != target_number && check_artifact("Dice_iron") && !reroll_used_this_turn) {
        draw_custom_button(button_reroll, button_reroll.sprite, _info_panel_x, _info_panel_y);
        draw_custom_button(button_settle, button_settle.sprite, _info_panel_x, _info_panel_y);
    } else {
        draw_custom_button(button_settle_full, button_settle_full.sprite, _info_panel_x, _info_panel_y);
    }
}
#endregion
