/// @description 튜토리얼 연출 및 UI 그리기

// 한글 주석: effect_alpha 값을 사용하여 화면 전체에 어두운 효과를 줍니다.
if (effect_alpha > 0) {
    draw_set_color(c_black);
    draw_set_alpha(effect_alpha);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1); // 한글 주석: 알파값을 원래대로 되돌립니다.
}

// 한글 주석: 화면 강조(하이라이트) 효과를 처리합니다.
if (highlight_mode != "none") {
    var _width = display_get_gui_width();
    var _height = display_get_gui_height();
    var _mid_x = _width / 2;

    draw_set_color(c_black);
    draw_set_alpha(0.5); // 한글 주석: 반투명한 검은색으로 어둡게 만듭니다.

    switch (highlight_mode) {
        case "left":
            // 한글 주석: 화면의 오른쪽 절반을 어둡게 하여 왼쪽을 강조합니다.
            draw_rectangle(_mid_x, 0, _width, _height, false);
            break;
        case "right":
            // 한글 주석: 화면의 왼쪽 절반을 어둡게 하여 오른쪽을 강조합니다.
            draw_rectangle(0, 0, _mid_x, _height, false);
            break;
    }

    draw_set_alpha(1); // 한글 주석: 알파값을 원래대로 되돌립니다.
}