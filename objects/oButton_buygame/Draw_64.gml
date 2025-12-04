/// @description Draw Popup (Confirm)

if (state == "confirm") {
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    
    // 1. 배경 Dim 처리
    draw_set_alpha(0.6);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    draw_set_alpha(1.0);
    
    // 2. 팝업 창 그리기
    var _px = (_gui_w - popup_w) / 2;
    var _py = (_gui_h - popup_h) / 2;
    
    draw_set_color(#2A2A2A); // 배경색
    draw_roundrect_ext(_px, _py, _px + popup_w, _py + popup_h, 20, 20, false);
    draw_set_color(c_white); // 테두리
    draw_roundrect_ext(_px, _py, _px + popup_w, _py + popup_h, 20, 20, true);
    
    // 3. 텍스트
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_font(fnt_dialogue_main);
    draw_set_color(c_white);
    
    draw_text(_px + popup_w / 2, _py + 40, "새 미니게임을 구매하시겠습니까?");
    draw_text(_px + popup_w / 2, _py + 90, "비용: " + string(cost) + " 패배 토큰");
    draw_text(_px + popup_w / 2, _py + 130, "(현재 보유: " + string(oGame.lose_token) + ")");
    
    // 4. 버튼 그리기
    var _btn_y = _py + popup_h - 80;
    var _yes_x = _px + 50;
    var _no_x = _px + popup_w - 50 - button_no.w;
    
    // Yes 버튼
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    var _yes_hover = (_mx >= _yes_x && _mx <= _yes_x + button_yes.w && _my >= _btn_y && _my <= _btn_y + button_yes.h);
    
    draw_sprite_stretched_ext(button_yes.sprite, 0, _yes_x, _btn_y, button_yes.w, button_yes.h, _yes_hover ? c_ltgray : c_white, 1);
    draw_set_valign(fa_middle);
    draw_set_color(c_black); // 버튼 텍스트는 검정
    draw_text(_yes_x + button_yes.w / 2, _btn_y + button_yes.h / 2, button_yes.label);
    
    // No 버튼
    var _no_hover = (_mx >= _no_x && _mx <= _no_x + button_no.w && _my >= _btn_y && _my <= _btn_y + button_no.h);
    
    draw_sprite_stretched_ext(button_no.sprite, 0, _no_x, _btn_y, button_no.w, button_no.h, _no_hover ? c_ltgray : c_white, 1);
    draw_set_color(c_black);
    draw_text(_no_x + button_no.w / 2, _btn_y + button_no.h / 2, button_no.label);
    
    // 복구
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}