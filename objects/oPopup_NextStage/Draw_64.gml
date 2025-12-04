/// @description Draw Popup UI

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

// 1. 배경 어둡게 처리 (Dim)
draw_set_alpha(0.7);
draw_set_color(c_black);
draw_rectangle(0, 0, _gui_w, _gui_h, false);
draw_set_alpha(1.0);

// 2. 팝업 창 본체
draw_set_color($2A2A2A); // 어두운 회색
draw_roundrect_ext(x_pos, y_pos, x_pos + width, y_pos + height, 20, 20, false);

draw_set_color(c_white); // 테두리
draw_roundrect_ext(x_pos, y_pos, x_pos + width, y_pos + height, 20, 20, true);

// 3. 텍스트 표시
draw_set_halign(fa_center);
draw_set_valign(fa_top);

// 제목
draw_set_font(font_title);
draw_set_color(c_yellow);
draw_text(x_pos + width / 2, y_pos + 30, "NEXT STAGE");

draw_set_color(c_white);
draw_text(x_pos + width / 2, y_pos + 70, next_stage_name);


// 상세 정보
draw_set_font(mainfont);
draw_set_valign(fa_middle);

var _center_x = x_pos + width / 2;
var _content_y = y_pos + 150;
var _line_height = 40;

draw_text(_center_x, _content_y, "시작 금액: " + string(start_amount));
draw_text(_center_x, _content_y + _line_height, "목표 금액: " + string(target_amount));
draw_text(_center_x, _content_y + _line_height * 2, "기회 횟수: " + string(chance_count));


// 4. 버튼 그리기
var _btn = button_start;
draw_sprite_stretched(_btn.sprite, 0, _btn.x, _btn.y, _btn.w, _btn.h);

draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(_btn.x + _btn.w / 2, _btn.y + _btn.h / 2, _btn.label);

// 정렬 초기화
draw_set_halign(fa_left);
draw_set_valign(fa_top);