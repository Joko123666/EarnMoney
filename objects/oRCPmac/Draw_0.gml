/// @description oRCPmac - Draw Event
// oMacs_parent의 Draw 이벤트를 호출하여 기본 UI 틀(패널, 공통 버튼 등)을 그립니다.
event_inherited();

// 부모 Draw에서 IDLE 상태일 때 exit 처리하므로, 여기서는 별도 처리가 필요 없습니다.
if (state == RCPMachineState.IDLE) exit;


// --- oRCPmac 전용 그리기 --- //

#region Game Screen Content
// 부모가 그려준 게임 화면 영역의 좌표를 가져옵니다.
var _game_screen_x = panel_x + 20;
var _game_screen_y = panel_y + 60;
var _game_screen_w = panel_w - info_panel_width - 50;
var _game_screen_h = panel_h - 80;
var _game_cx = _game_screen_x + _game_screen_w / 2;
var _game_cy = _game_screen_y + _game_screen_h / 2;

// 플레이어와 컴퓨터의 선택 그리기
if (state != RCPMachineState.BETTING) {
    if (player_choice != -1) {
        draw_sprite_ext(sRCP, player_choice, _game_cx - 100, _game_cy, player_sprite_scale, player_sprite_scale, 0, c_white, 1);
    }
    if (computer_choice != -1) {
        draw_sprite_ext(sRCP, computer_choice, _game_cx + 100, _game_cy, computer_sprite_scale, computer_sprite_scale, 180, c_white, 1);
    }
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(_game_cx, _game_cy, "VS");
}

// 결과 메시지
if (state == RCPMachineState.RESULT) {
    draw_set_font(fnt_dialogue_name);
    draw_set_halign(fa_center);
    draw_text(_game_cx, _game_cy - 150, result_message);
}
#endregion

#region Info Panel Content
// 정보 패널의 좌표를 가져옵니다.
var _info_panel_x = panel_x + panel_w - info_panel_width - 20;
var _info_panel_y = panel_y + 60;

// 게임 정보 그리기
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_ltgray);
var _info_text_x = _info_panel_x + 20;
var _info_text_y = _info_panel_y + 250; // 위치 조정
draw_text(_info_text_x, _info_text_y, "Win: " + string(win_payout) + "x");
draw_text(_info_text_x, _info_text_y + 30, "Draw: " + string(draw_payout) + "x");

// 상태별 액션 버튼 그리기
if (state == RCPMachineState.BETTING) {
    draw_custom_button(button_play, button_play.sprite, _info_panel_x, _info_panel_y);
} else if (state == RCPMachineState.CHOOSING) {
    draw_custom_button(button_rock, button_rock.sprite, _info_panel_x, _info_panel_y);
    draw_custom_button(button_paper, button_paper.sprite, _info_panel_x, _info_panel_y);
    draw_custom_button(button_scissors, button_scissors.sprite, _info_panel_x, _info_panel_y);
} else if (state == RCPMachineState.RESULT) {
    draw_custom_button(button_play_again, button_play_again.sprite, _info_panel_x, _info_panel_y);
}
#endregion
