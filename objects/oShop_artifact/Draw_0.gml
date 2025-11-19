// UI 위치 및 크기 변수
var _slot_size = 64;
var _slot_gap = 16;

draw_set_font(font_main); // (가정) 전역 폰트 사용
draw_set_halign(fa_center);
draw_set_valign(fa_top);

// ----------------- 상품 슬롯 그리기 -----------------
for (var i = 0; i < display_slots; i++) {
    var _slot_x = x + i * (_slot_size + _slot_gap);
    
    // 슬롯 배경 그리기
    draw_sprite_stretched(sBox, 0, _slot_x, y, _slot_size, _slot_size);
    
    var _item = shop_slots[i];
    if (_item != -1) {
        // 상품 스프라이트 그리기
		var _artifact = shop_slots[i];
		draw_sprite(sArtifact, _artifact.artifact_num, _slot_x + _slot_size / 2, y + _slot_size / 2);
                
        // 가격 표시
        draw_set_color(c_yellow);
        draw_text(_slot_x + _slot_size / 2, y + _slot_size + 5, string(_item.purchase_price) + " LT");
        draw_set_color(c_white);
    }
}

// ----------------- 갱신 버튼 그리기 -----------------
var _reroll_button_x = x + (display_slots * (_slot_size + _slot_gap)) / 2 - 50;
var _reroll_button_y = y + _slot_size + 48;
draw_sprite_stretched(sBox, 0, _reroll_button_x, _reroll_button_y, 100, 32);
draw_set_valign(fa_middle);
draw_text(_reroll_button_x + 50, _reroll_button_y + 16, "갱신 (" + string(reroll_cost) + " LT)");

// ----------------- 아티팩트 정보 패널 그리기 -----------------
if (show_info_panel) {
    // 정보 패널 배경 그리기
    draw_sprite_stretched(sBox, 0, info_panel_x, info_panel_y, info_panel_width, info_panel_height);

    // 아티팩트 이름
    draw_set_halign(fa_center);
    draw_text(info_panel_x + info_panel_width / 2, info_panel_y + 10, selected_artifact_data.display_name);

    // 아티팩트 설명
    draw_set_halign(fa_left);
    draw_text_ext(info_panel_x + 10, info_panel_y + 40, selected_artifact_data.description, 16, info_panel_width - 20);

    // 아티팩트 가격
    draw_set_halign(fa_center);
    draw_set_color(c_yellow);
    draw_text(info_panel_x + info_panel_width / 2, info_panel_y + info_panel_height - 80, "가격: " + string(selected_artifact_data.purchase_price) + " LT");
    draw_set_color(c_white);

    // 구매 버튼 그리기
    // 한글 주석: draw_custom_button 함수가 상대 좌표를 이용해 절대 좌표를 계산하므로, 여기서는 기본 위치만 전달합니다.
    draw_custom_button(purchase_button, sButton, info_panel_x, info_panel_y);
}

#region Test vision
// 클릭 가능 영역 시각화 (디버그용)
draw_set_alpha(0.5); // 반투명 설정
draw_set_color(c_red);

// 상품 슬롯 클릭 범위
for (var i = 0; i < display_slots; i++) {
    var _slot_x = x + i * (_slot_size + _slot_gap);
    draw_rectangle(_slot_x, y, _slot_x + _slot_size, y + _slot_size, true);
}

// 갱신 버튼 클릭 범위
draw_rectangle(_reroll_button_x, _reroll_button_y, _reroll_button_x + 100, _reroll_button_y + 32, true);

// 정보 패널의 구매 버튼 클릭 범위
if (show_info_panel) {
    draw_rectangle(purchase_button.x, purchase_button.y, purchase_button.x + purchase_button.w, purchase_button.y + purchase_button.h, true);
}

draw_set_alpha(1); // 알파값 복원
#endregion

// 그리기 설정 초기화
draw_set_halign(fa_left);
draw_set_valign(fa_top);