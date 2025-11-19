/// @description oRoulettemac - Draw Event (Refactored)

// 부모의 Draw 이벤트를 호출하여 기본 UI 패널과 공통 버튼을 그립니다.
event_inherited();

// IDLE 상태에서는 아무것도 그리지 않습니다.
if (state == RouletteState.IDLE) {
    exit;
}

// --- oRoulettemac 전용 그리기 --- //

#region Game Screen Content (Roulette)
// 부모가 그려준 게임 화면 영역의 좌표를 가져옵니다.
var _game_screen_x = panel_x + 20;
var _game_screen_y = panel_y + 60;
var _game_screen_w = panel_w - info_panel_width - 50;
var _game_screen_h = panel_h - 80;
var _game_cx = _game_screen_x + _game_screen_w / 2;
var _game_cy = _game_screen_y + _game_screen_h / 2;
var _radius = min(_game_screen_w, _game_screen_h) / 2 - 20;

draw_set_font(fnt_dialogue_name);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// 룰렛 판 그리기
var _current_angle = roulette_angle;
for (var i = 0; i < 8; i++) {
    var _segment_size = segment_sizes[i];
    var _color = (i % 2 == 0) ? #B71C1C : #1A237E; // 어두운 빨강/파랑
    
    draw_primitive_begin(pr_trianglefan);
    draw_vertex_color(_game_cx, _game_cy, _color, 1);
    for (var j = 0; j <= _segment_size; j += 5) { // 5도 단위로 부드럽게
        var _vx = _game_cx + lengthdir_x(_radius, _current_angle + j);
        var _vy = _game_cy + lengthdir_y(_radius, _current_angle + j);
        draw_vertex_color(_vx, _vy, _color, 1);
    }
    draw_primitive_end();

    // 룰렛 판 숫자
    var _text_angle = _current_angle + _segment_size / 2;
    var _text_x = _game_cx + lengthdir_x(_radius * 0.8, _text_angle);
    var _text_y = _game_cy + lengthdir_y(_radius * 0.8, _text_angle);
    draw_set_color(c_white);
    draw_text(_text_x, _text_y, string(i + 1));
    
    _current_angle += _segment_size;
}

// 포인터 그리기 (상단)
draw_set_color(c_yellow);
draw_triangle(_game_cx - 15, _game_screen_y + 5, _game_cx + 15, _game_screen_y + 5, _game_cx, _game_screen_y + 30, false);
draw_set_color(c_white);

// 결과 메시지 그리기
if (state == RouletteState.RESULT) {
    draw_set_font(fnt_dialogue_main);
    draw_text(_game_cx, _game_cy + _radius + 40, result_message);
}
#endregion

#region Info Panel Content
// 정보 패널의 좌표를 가져옵니다.
var _info_panel_x = panel_x + panel_w - info_panel_width - 20;
var _info_panel_y = panel_y + 60;

// 상태에 맞는 액션 버튼을 그립니다.
if (state == RouletteState.BETTING) {
    draw_custom_button(button_play, button_play.sprite, _info_panel_x, _info_panel_y);
} else if (state == RouletteState.RESULT) {
    draw_custom_button(button_play_again, button_play_again.sprite, _info_panel_x, _info_panel_y);
}

// 배당률 정보 그리기
draw_set_font(fnt_dialogue_main);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_ltgray);
var _rate_y = _info_panel_y + 250;
var _rate_x = _info_panel_x + 20;
for (var i = 0; i < 4; i++) {
    var str1 = string(i+1) + ": x" + string(reward_rates[i]);
    var str2 = string(i+5) + ": x" + string(reward_rates[i+4]);
    draw_text(_rate_x, _rate_y + i * 30, str1);
    draw_text(_rate_x + 150, _rate_y + i * 30, str2);
}

#endregion

// 그리기 설정 초기화
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
