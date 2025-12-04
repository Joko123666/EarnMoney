/// @description Draw Game Result UI & Logic

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _mouse_click = mouse_check_button_pressed(mb_left);

// 1. 배경 어둡게 처리 (Dim 처리)
draw_set_alpha(0.7);
draw_set_color(c_black);
draw_rectangle(0, 0, _gui_w, _gui_h, false);
draw_set_alpha(1.0);

// 2. 팝업 창 본체
draw_set_color($2A2A2A); // 어두운 회색 배경
draw_roundrect_ext(x_pos, y_pos, x_pos + width, y_pos + height, 20, 20, false);

draw_set_color(c_white); // 테두리
draw_roundrect_ext(x_pos, y_pos, x_pos + width, y_pos + height, 20, 20, true);

// 3. 텍스트 표시
draw_set_halign(fa_center);
draw_set_valign(fa_top);

// 제목 (승리/패배)
draw_set_font(font_title);
if (is_win) {
    draw_set_color(c_yellow);
    draw_text(x_pos + width / 2, y_pos + 40, "GAME CLEAR!");
} else {
    draw_set_color(c_red);
    draw_text(x_pos + width / 2, y_pos + 40, "GAME OVER");
}

// 상세 정보
draw_set_font(font_main);
draw_set_color(c_white);
draw_set_valign(fa_middle);

var _center_x = x_pos + width / 2;
var _content_y = y_pos + 120; // 시작 위치 약간 위로 조정
var _line_height = 40; // 줄 간격 약간 줄임

draw_text(_center_x, _content_y, "최종 소지금: " + string(final_money));
draw_text(_center_x, _content_y + _line_height, "획득 소울 포인트: " + string(soul_points));

// 통계 정보 추가
draw_set_color(c_ltgray); // 통계는 약간 다른 색으로
draw_text(_center_x, _content_y + _line_height * 2.5, "총 전적: " + string(global.total_wins) + "승 " + string(global.total_losses) + "패");
draw_text(_center_x, _content_y + _line_height * 3.5, "최고 기록: " + string(global.max_consecutive_wins) + "연승 / " + string(global.max_consecutive_losses) + "연패");

// 4. 버튼 그리기 및 로직

// --- 다시하기 버튼 ---
var _btn = button_restart;
var _hover = (_mx >= _btn.x && _mx <= _btn.x + _btn.w && _my >= _btn.y && _my <= _btn.y + _btn.h);

if (_hover) draw_set_color(c_ltgray); // 호버 시 색상 변경
else draw_set_color(c_white);

draw_sprite_stretched_ext(_btn.sprite, 0, _btn.x, _btn.y, _btn.w, _btn.h, _hover ? c_gray : c_white, 1);

draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(_btn.x + _btn.w / 2, _btn.y + _btn.h / 2, _btn.label);

if (_hover && _mouse_click) {
    game_restart();
}

// --- 타이틀로 버튼 ---
_btn = button_title;
_hover = (_mx >= _btn.x && _mx <= _btn.x + _btn.w && _my >= _btn.y && _my <= _btn.y + _btn.h);

if (_hover) draw_set_color(c_ltgray);
else draw_set_color(c_white);

draw_sprite_stretched_ext(_btn.sprite, 0, _btn.x, _btn.y, _btn.w, _btn.h, _hover ? c_gray : c_white, 1);

draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(_btn.x + _btn.w / 2, _btn.y + _btn.h / 2, _btn.label);

if (_hover && _mouse_click) {
    room_goto(Title); // 'Title' 룸 상수가 있다고 가정 (없으면 'Title' 문자열이나 인덱스 확인 필요)
}

// 정렬 초기화
draw_set_halign(fa_left);
draw_set_valign(fa_top);