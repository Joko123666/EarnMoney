/// @description oOEmac - Draw Event (Refactored)

// 부모(oMacs_parent)의 Draw 이벤트를 호출하여 기본 UI 패널을 그립니다.
event_inherited();

// IDLE 상태에서는 아무것도 그리지 않고 종료합니다.
if (state == OEmacState.IDLE) {
    exit;
}

// --- 그리기 설정 ---
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// --- 게임 화면 좌표 설정 ---
var _game_screen_x = panel_x + 20;
var _game_screen_y = panel_y + 60;
var _game_screen_w = panel_w - info_panel_width - 50;
var _game_screen_h = panel_h - 80;
var _game_cx = _game_screen_x + _game_screen_w / 2;
var _game_cy = _game_screen_y + _game_screen_h / 2;

// --- 주사위 및 컵 그리기 ---
var _dice_scale = 2;
var _dice_gap = 100; // 주사위 사이 간격
var _dice1_x = _game_cx - _dice_gap;
var _dice2_x = _game_cx + _dice_gap;
var _dice_y = _game_cy;

// 컵의 Y 좌표 계산 (애니메이션용)
var _cup_start_y = _game_cy - 300; // 컵이 애니메이션을 시작하는 Y 위치
var _cup_end_y = _game_cy;       // 컵이 주사위를 덮는 최종 Y 위치
var _cup_draw_y = _cup_end_y;

// ROLLING 상태: 컵이 내려오는 애니메이션
if (state == OEmacState.ROLLING) {
    var _progress = 1 - (anim_timer / cup_anim_duration);
    _cup_draw_y = lerp(_cup_start_y, _cup_end_y, _progress); // lerp로 부드러운 움직임 구현
    draw_sprite(sCup, 0, _game_cx, _cup_draw_y);
}
// CHOOSING 상태: 컵이 주사위를 덮고 있음
else if (state == OEmacState.CHOOSING) {
    draw_sprite(sCup, 0, _game_cx, _cup_end_y);
    
    // 홀/짝 선택 버튼 그리기 (절대 좌표 사용)
    draw_custom_button(button_choose_odd, button_choose_odd.sprite, 0, 0);
    draw_custom_button(button_choose_even, button_choose_even.sprite, 0, 0);

    // 안내 메시지
    draw_set_font(fnt_dialogue_main);
    draw_text(_game_cx, _game_cy + 200, "결과가 홀일까요, 짝일까요?");
}
// PRE_REVEAL 상태: 컵이 닫힌 채로 잠시 대기
else if (state == OEmacState.PRE_REVEAL) {
    draw_sprite(sCup, 0, _game_cx, _cup_end_y);
}
// REVEAL 상태: 컵이 올라가는 애니메이션
else if (state == OEmacState.REVEAL) {
    var _progress = 1 - (anim_timer / cup_anim_duration);
    _cup_draw_y = lerp(_cup_end_y, _cup_start_y, _progress);
    draw_sprite(sCup, 0, _game_cx, _cup_draw_y);
    
    // 주사위 결과 표시
    draw_sprite_ext(sDice, dice_results[0] - 1, _dice1_x, _dice_y, _dice_scale, _dice_scale, 0, c_white, 1);
    draw_sprite_ext(sDice, dice_results[1] - 1, _dice2_x, _dice_y, _dice_scale, _dice_scale, 0, c_white, 1);
}
// 그 외 상태 (BETTING, RESULT 등): 주사위와 컵(열린 상태)을 보여줌
else {
    // 컵 (열린 상태, 위쪽에 위치)
    draw_sprite(sCup, 0, _game_cx, _cup_start_y);
    
    // 주사위 (결과 또는 기본 눈)
    draw_sprite_ext(sDice, dice_results[0] - 1, _dice1_x, _dice_y, _dice_scale, _dice_scale, 0, c_white, 1);
    draw_sprite_ext(sDice, dice_results[1] - 1, _dice2_x, _dice_y, _dice_scale, _dice_scale, 0, c_white, 1);

    // RESULT 상태일 때 결과 메시지 표시
    if (state == OEmacState.RESULT) {
        draw_set_font(fnt_dialogue_main);
        // 주사위 합계 표시
        draw_text(_game_cx, _game_cy + 150, "합계: " + string(dice_sum));
        
        // 최종 결과 메시지 (딜레이 후 표시)
        if (anim_timer <= 0) {
            draw_text(_game_cx, _game_cy + 200, result_message);
        }
    }
}


// --- 정보 패널 버튼 그리기 (오른쪽) ---
var _info_panel_x = panel_x + panel_w - info_panel_width - 20;
var _info_panel_y = panel_y + 60;

if (state == OEmacState.BETTING) {
    draw_custom_button(button_play, button_play.sprite, _info_panel_x, _info_panel_y);
} else if (state == OEmacState.RESULT && anim_timer <= 0) {
    draw_custom_button(button_play_again, button_play_again.sprite, _info_panel_x, _info_panel_y);
}


// --- 그리기 설정 초기화 ---
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);