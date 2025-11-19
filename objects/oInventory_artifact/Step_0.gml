// UI가 활성화되어 있고, 현재 오브젝트가 활성화된 UI 오브젝트가 아니라면 클릭 처리하지 않음
if (global.ui_blocking_input && global.active_ui_object != id) exit;

// =================================================================
// 정보 패널 로직 (마우스 좌클릭)
// =================================================================
if (info_panel_visible && mouse_check_button_pressed(mb_left)) {
    var clicked_on_button = false;

    // 버튼 클릭 확인
    if (check_button_click(button_use, info_panel_x, info_panel_y)) {
        use_artifact();
        clicked_on_button = true;
    } else if (check_button_click(button_sell, info_panel_x, info_panel_y)) {
        sell_artifact();
        clicked_on_button = true;
    } else if (check_button_click(button_close, info_panel_x, info_panel_y)) {
        info_panel_visible = false;
        global.ui_blocking_input = false;
        global.active_ui_object = noone;
        clicked_on_button = true;
    }

    // 정보 패널 외부 클릭 시 닫기 (버튼 클릭이 아닐 경우에만)
    if (!clicked_on_button && !point_in_rectangle(mouse_x, mouse_y, info_panel_x, info_panel_y, info_panel_x + info_panel_width, info_panel_y + info_panel_height)) {
        info_panel_visible = false;
        global.ui_blocking_input = false;
        global.active_ui_object = noone;
    }
    
    // 정보 패널이 활성화된 동안에는 다른 클릭 로직을 실행하지 않음
    exit;
}

// =================================================================
// 정보 패널 열기 (마우스 좌클릭)
// =================================================================
if (mouse_check_button_pressed(mb_left)) {
    var items_per_row = 3;
    var slot_size = 48;
    var padding = 5;

    // 슬롯 위에서 클릭했는지 확인
    for (var i = 0; i < array_length(atti_list); i++) {
        var col = i % items_per_row;
        var row = floor(i / items_per_row);
        var x_slot = x + col * (slot_size + padding);
        var y_slot = y + row * (slot_size + padding);

        if (point_in_rectangle(mouse_x, mouse_y, x_slot, y_slot, x_slot + slot_size, y_slot + slot_size)) {
            if (atti_list[i] != -1) {
                selected_index = i;
                selected_artifact_data = atti_list[i];

                info_panel_visible = true;
                global.ui_blocking_input = true;
                global.active_ui_object = id;
                break; // 슬롯을 찾았으므로 루프 종료
            }
        }
    }
}
