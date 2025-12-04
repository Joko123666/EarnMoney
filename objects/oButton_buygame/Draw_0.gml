/// @description Draw Button

// IDLE 상태일 때만 버튼을 그립니다.
// CONFIRM 상태일 때도 버튼은 배경에 남아있어야 하므로 계속 그립니다.

draw_self(); // 버튼 스프라이트 그리기

// 텍스트 그리기
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fnt_dialogue_name);
draw_set_color(c_white);

// 버튼 중앙에 텍스트 배치
draw_text(x + sprite_width / 2, y + sprite_height / 2, label);

// 비용 표시 (5LT)
draw_set_color(c_yellow);
draw_text(x + sprite_width / 2, y + sprite_height / 2 + 20, "5 LT");

// 토큰 부족 시 빨간색 표시 등 시각적 피드백 추가 가능
if (oGame.lose_token < cost) {
    draw_set_color(c_red);
    draw_text(x + sprite_width / 2, y + sprite_height / 2 + 40, "(부족)");
}