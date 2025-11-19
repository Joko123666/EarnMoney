// 반투명한 검은색 박스 그리기
draw_set_color(c_black);
draw_set_alpha(0.7);
draw_rectangle(box_x, box_y, box_x + box_width, box_y + box_height, false);
draw_set_alpha(1.0); // 알파값 초기화

// 악마 초상화 그리기
if (sprite_exists(portrait_sprite)) {
    draw_sprite(portrait_sprite, 0, box_x + 80, box_y + 100);
}

// 악마 이름 그리기
draw_set_font(fnt_dialogue_name); // 이름용 폰트 (미리 생성 필요)
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_yellow);
draw_text(box_x + 180, box_y + 20, demon_name);

// 대사 내용 그리기 (타이핑 효과 적용된 텍스트)
draw_set_font(fnt_dialogue_main); // 대사용 폰트 (미리 생성 필요)
draw_set_color(c_white);
// draw_text_ext는 박스 너비에 맞춰 자동으로 줄바꿈을 해줍니다.
draw_text_ext(box_x + 180, box_y + 60, display_text, 30, box_width - 200);