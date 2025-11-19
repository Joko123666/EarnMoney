/// @description 중단 메뉴 그리기

// 게임이 중단된 상태가 아니면, 아무것도 그리지 않습니다.
if (!is_paused) {
    exit;
}

// --- 화면 전체를 어둡게 덮는 배경 그리기 ---
draw_set_color(c_black);
draw_set_alpha(0.7);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1.0); // 알파 값 초기화

// --- 공통 그리기 속성 설정 ---
draw_set_font(fnt_dialogue_main); // 폰트 설정 (fnt_dialogue_main이 없을 경우, 사용 가능한 폰트로 변경해야 합니다)
draw_set_halign(fa_center);       // 수평 정렬 (중앙)
draw_set_valign(fa_middle);       // 수직 정렬 (중앙)

// --- "Paused" 타이틀 그리기 ---
draw_set_color(c_white);
draw_text(display_get_gui_width() / 2, 100, "Paused");

// --- 버튼 그리기 ---
for (var i = 0; i < array_length(buttons); i++) {
    var btn = buttons[i];
    var btn_x = display_get_gui_width() / 2;
    var btn_y = 200 + (i * 80); // 버튼 간격
    var btn_w = 250;
    var btn_h = 60;

    // 마우스가 위에 있으면 노란색, 아니면 흰색으로 텍스트 색상 설정
    var color = (i == hovered_button) ? c_yellow : c_white;
    
    // 버튼 배경 그리기 (반투명 검은 사각형)
    draw_set_color(c_black);
    draw_set_alpha(0.5);
    draw_rectangle(btn_x - btn_w / 2, btn_y - btn_h / 2, btn_x + btn_w / 2, btn_y + btn_h / 2, false);
    draw_set_alpha(1.0);

    // 버튼 텍스트(label) 그리기
    draw_set_color(color);
    draw_text(btn_x, btn_y, btn.label);
}

// --- 그리기 설정 초기화 ---
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1.0);