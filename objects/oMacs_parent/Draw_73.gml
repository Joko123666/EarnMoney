/// @description oMacs_parent - Draw End Event (Rule Popup)

if (show_rule_popup) {
    draw_set_color(c_black);
    draw_set_alpha(0.95); // 배경을 조금 더 어둡게
    var _popup_w = 600;
    var _popup_h = 400;
    var _popup_x = panel_x + (panel_w - _popup_w) / 2;
    var _popup_y = panel_y + (panel_h - _popup_h) / 2;
    
    // 팝업 배경 그리기
    draw_roundrect_ext(_popup_x, _popup_y, _popup_x + _popup_w, _popup_y + _popup_h, 20, 20, false);
    draw_set_color(c_white);
    draw_roundrect_ext(_popup_x, _popup_y, _popup_x + _popup_w, _popup_y + _popup_h, 20, 20, true);
    
    // 텍스트 그리기
    draw_set_alpha(1.0);
    draw_set_font(fnt_dialogue_main); // 한글 폰트 사용
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    
    draw_text(_popup_x + _popup_w/2, _popup_y + 20, "- 게임 규칙 -");
    
    draw_set_halign(fa_left);
    draw_text_ext(_popup_x + 30, _popup_y + 70, rule_description, 30, _popup_w - 60);
    
    // 닫기 버튼 그리기 (업데이트된 좌표 사용)
    // Step 이벤트에서 좌표가 업데이트되지만, 혹시 모르니 여기서도 그리기 전에 한 번 더 확인 가능
    // 하지만 Step이 먼저 실행되므로 button_rule_close에는 올바른 좌표가 있어야 함.
    draw_custom_button(button_rule_close, button_rule_close.sprite, 0, 0); // 절대 좌표 그리기
    
    // 닫기 버튼 텍스트 (X)
    draw_set_color(c_black);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(button_rule_close.x + button_rule_close.w/2, button_rule_close.y + button_rule_close.h/2, "X");
}

// 그리기 설정 초기화
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);