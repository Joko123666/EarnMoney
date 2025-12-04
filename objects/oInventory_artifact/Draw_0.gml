draw_set_font(mainfont);

// ▒ Draw Event - 인벤토리 슬롯 및 아티팩트 UI 그리기
var items_per_row = 3;
var slot_size = 48;
var padding = 5;

for (var i = 0; i < array_length(atti_list); i++) {
    var col = i % items_per_row;
    var row = floor(i / items_per_row);

    var x_slot = x + col * (slot_size + padding);
    var y_slot = y + row * (slot_size + padding);

    

    draw_sprite_stretched(sBox, 2, x_slot, y_slot, slot_size, slot_size);

    // ▒ 슬롯에 아티팩트가 있으면 그리기
    if (atti_list[i] != -1) {
        var _artifact = atti_list[i];
        draw_sprite(sArtifact, _artifact.artifact_num, x_slot + slot_size / 2, y_slot + slot_size / 2);
    }
}

// ▒ 정보 패널 그리기
if (info_panel_visible) {
    // 그리드 크기 계산
    var grid_width = items_per_row * (slot_size + padding) - padding;
    
    // 패널 위치 계산: 그리드 중앙 상단
    info_panel_x = x + (grid_width / 2) - (info_panel_width / 2);
    info_panel_y = y - info_panel_height - 10; // 10은 그리드와의 간격

    // 버튼들의 절대 좌표 업데이트
    button_use.x = info_panel_x + button_use.rel_x;
    button_use.y = info_panel_y + button_use.rel_y;
    button_sell.x = info_panel_x + button_sell.rel_x;
    button_sell.y = info_panel_y + button_sell.rel_y;
    button_close.x = info_panel_x + button_close.rel_x;
    button_close.y = info_panel_y + button_close.rel_y;

    // 정보 패널 배경 그리기
    draw_sprite_stretched(sBox, 0, info_panel_x, info_panel_y, info_panel_width, info_panel_height);

    if (selected_artifact_data != -1) {
        // 아티팩트 이름
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_text(info_panel_x + info_panel_width / 2, info_panel_y + 20, selected_artifact_data.display_name);

        // 아티팩트 설명
        draw_set_halign(fa_left);
        draw_text_ext(info_panel_x + 20, info_panel_y + 60, selected_artifact_data.description, 20, info_panel_width - 40);

        // 판매 가격 표시
        draw_set_halign(fa_center);
        draw_set_color(c_yellow);
        draw_text(info_panel_x + info_panel_width / 2, info_panel_y + info_panel_height - 80, "판매 가격: " + string(selected_artifact_data.selling_price) + " G");
        draw_set_color(c_white);
    }

    // 버튼 그리기
    draw_custom_button(button_use, button_use.sprite, info_panel_x, info_panel_y);
    draw_custom_button(button_sell, button_sell.sprite, info_panel_x, info_panel_y);
    draw_custom_button(button_close, button_close.sprite, info_panel_x, info_panel_y);
}

#region Test vision
// 클릭 가능 영역 시각화 (디버그용)
draw_set_alpha(0.5); // 반투명 설정
draw_set_color(c_red);

// 인벤토리 슬롯 클릭 범위 (우클릭)
for (var i = 0; i < array_length(atti_list); i++) {
    var col = i % items_per_row;
    var row = floor(i / items_per_row);

    var x_slot = x + col * (slot_size + padding);
    var y_slot = y + row * (slot_size + padding);
    draw_rectangle(x_slot, y_slot, x_slot + slot_size, y_slot + slot_size, true);
}

// 정보 패널 내부 버튼 클릭 범위
if (info_panel_visible) {
    var buttons = [button_use, button_sell, button_close];
    for (var i = 0; i < array_length(buttons); i++) {
        var btn = buttons[i];
        draw_rectangle(btn.x, btn.y, btn.x + btn.w, btn.y + btn.h, true);
    }
}

draw_set_alpha(1); // 알파값 복원
#endregion
