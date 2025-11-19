/// @description oCupmac - Draw Event (Refactored)
event_inherited();

if (state == CupGameState.IDLE) {
    exit;
}

// --- oCupmac 전용 그리기 --- //
// 부모가 그린 UI 위에 이 게임만의 요소를 추가로 그립니다.

#region Game Screen Content
var _game_screen_x = panel_x + 20;
var _game_screen_y = panel_y + 60;
var _game_screen_w = panel_w - info_panel_width - 50;
var _game_screen_h = panel_h - 80;
var _game_cx = _game_screen_x + _game_screen_w / 2;
var _game_cy = _game_screen_y + _game_screen_h / 2;

// 공과 컵 그리기
var cup_with_ball = noone;
for (var i = 0; i < cup_count; i++) {
    if (cups[i].has_ball) {
        cup_with_ball = cups[i];
        break;
    }
}

if (state == CupGameState.SETUP) {
    var progress = 1 - (animation_timer / setup_duration);
    // 공이 나타나는 애니메이션 (가운데 컵 기준)
    var _center_cup_index = floor(cup_count / 2);
    var ball_y = lerp(cups[_center_cup_index].y - 100, cups[_center_cup_index].y, progress);
    draw_sprite(sBall, 0, cups[_center_cup_index].x, ball_y);
} else if ((state == CupGameState.REVEAL || state == CupGameState.RESULT) && cup_with_ball != noone) {
    // 결과 공개 시 공 그리기
    draw_sprite(sBall, 0, cup_with_ball.x, cup_with_ball.y);
}

// 컵 그리기
for (var i = 0; i < cup_count; i++) {
    var cup = cups[i];
    var draw_y = cup.y;
    // 결과 공개 시 선택한 컵은 위로 올라가는 애니메이션
    if ((state == CupGameState.REVEAL || state == CupGameState.RESULT) && cup.id == player_choice) {
         var reveal_progress = 1 - (animation_timer / reveal_duration);
         draw_y -= (cup.has_ball ? 150 : 50) * reveal_progress;
    }
    draw_sprite(sCup, 0, cup.x, draw_y);
}

// 컵 선택 단계에서 컵 위에 숫자 표시
if (state == CupGameState.CHOOSING) {
    // 컵을 x좌표 기준으로 정렬하여 1, 2, 3번을 부여
    var sorted_cups = array_create(cup_count);
    array_copy(sorted_cups, 0, cups, 0, cup_count);
    array_sort(sorted_cups, function(c1, c2) { return c1.x - c2.x; });
    
    for (var i = 0; i < cup_count; i++) {
        var cup = sorted_cups[i];
        draw_set_font(fnt_dialogue_name);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        draw_text(cup.x, cup.y - 80, string(i + 1));
    }
}

// 결과 메시지
if (state == CupGameState.RESULT) {
    draw_set_font(fnt_dialogue_name);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(string_pos("Win", result_message) > 0 ? c_yellow : c_red);
    draw_text(_game_cx, _game_cy - 200, result_message);
}
#endregion

#region Info Panel Buttons
// 정보 패널의 좌표를 가져옵니다.
var _info_panel_x = panel_x + panel_w - info_panel_width - 20;
var _info_panel_y = panel_y + 60;

// 상태에 맞는 액션 버튼을 그립니다.
if (state == CupGameState.BETTING) {
    draw_custom_button(button_play, button_play.sprite, _info_panel_x, _info_panel_y);
} else if (state == CupGameState.CHOOSING) {
    // 컵 선택 버튼들
    draw_custom_button(button_cup_1, button_cup_1.sprite, _info_panel_x, _info_panel_y);
    draw_custom_button(button_cup_2, button_cup_2.sprite, _info_panel_x, _info_panel_y);
    draw_custom_button(button_cup_3, button_cup_3.sprite, _info_panel_x, _info_panel_y);
} else if (state == CupGameState.RESULT) {
    draw_custom_button(button_play_again, button_play_again.sprite, _info_panel_x, _info_panel_y);
}
#endregion
