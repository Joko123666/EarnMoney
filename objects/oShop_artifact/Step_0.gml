// 마우스 왼쪽 버튼이 눌렸을 때만 실행
if (!mouse_check_button_pressed(mb_left)) {
    return;
}

// UI가 활성화되어 있고, 현재 오브젝트가 활성화된 UI 오브젝트가 아니라면 클릭 처리하지 않음
if (global.ui_blocking_input && global.active_ui_object != id) exit;

// ----------------- 정보 패널이 활성화된 경우 -----------------
if (show_info_panel) {
    // 구매 버튼 클릭 확인
    if (check_button_click(purchase_button, info_panel_x, info_panel_y)) {
        if (selected_artifact_data != -1) {
            // 1. 인벤토리 공간 확인 (oInventory_artifact에 is_full() 함수 필요)
            if (oInventory_artifact.is_full()) {
                show_message("인벤토리가 가득 찼습니다.");
                return;
            }
            
            // 2. 돈 확인
            if (oGame.lose_token < selected_artifact_data.purchase_price) {
                show_message("돈이 부족합니다.");
                return;
            }

            // 3. 구매 처리
            oGame.lose_token -= selected_artifact_data.purchase_price;
            oInventory_artifact.add_artifact(selected_artifact_data.name);
            
            // 4. 구매된 상품 제거 및 선택 해제
            shop_slots[selected_slot_index] = -1;
            selected_slot_index = -1;
            selected_artifact_data = -1;
            show_info_panel = false; // 정보 패널 닫기
            global.ui_blocking_input = false;
            global.active_ui_object = noone;
            show_dialogue("shop_buy"); // (선택) 구매 시 악마 대사 출력
            return;
        }
    }

    // 정보 패널 외부 클릭 시 닫기
    if (mouse_check_button_pressed(mb_left) && 
        !point_in_rectangle(mouse_x, mouse_y, info_panel_x, info_panel_y, info_panel_x + info_panel_width, info_panel_y + info_panel_height)) {
        
        show_info_panel = false;
        selected_slot_index = -1;
        selected_artifact_data = -1;
        global.ui_blocking_input = false;
        global.active_ui_object = noone;
        return; // 외부 클릭 처리 후 더 이상 진행하지 않음
    }
}

// ----------------- 정보 패널이 비활성화된 경우 (기존 상점 로직) -----------------
else {
    // UI 위치 계산을 위한 변수
    var _slot_size = 64;
    var _slot_gap = 16;
    var _reroll_button_x = x + (display_slots * (_slot_size + _slot_gap)) / 2 - 50;
    var _reroll_button_y = y + _slot_size + 48;

    // ----------------- 갱신 버튼 클릭 확인 -----------------
    if (point_in_rectangle(mouse_x, mouse_y, _reroll_button_x, _reroll_button_y, _reroll_button_x + 100, _reroll_button_y + 32)) {
        if (oGame.lose_token >= reroll_cost) {
            oGame.lose_token -= reroll_cost;
            restock_shop();
            show_dialogue("shop_reroll"); // (선택) 갱신 시 악마 대사 출력
        } else {
            show_message("돈이 부족하여 갱신할 수 없습니다.");
        }
        return; // 다른 클릭 처리 방지
    }

    // ----------------- 상품 슬롯 클릭 확인 -----------------
    var clicked_on_slot = false;
    for (var i = 0; i < display_slots; i++) {
        var _slot_x = x + i * (_slot_size + _slot_gap);
        if (point_in_rectangle(mouse_x, mouse_y, _slot_x, y, _slot_x + _slot_size, y + _slot_size)) {
            if (shop_slots[i] != -1) {
                selected_slot_index = i;
                selected_artifact_data = shop_slots[i]; // 아티팩트 데이터 저장

                // 정보 패널 위치 계산 (클릭한 아이템 상단에 표시)
                var _clicked_slot_x = x + selected_slot_index * (_slot_size + _slot_gap);
                var _clicked_slot_y = y;
                info_panel_x = _clicked_slot_x + (_slot_size / 2) - (info_panel_width / 2);
                info_panel_y = _clicked_slot_y - info_panel_height - 10; // 10픽셀 패딩

                show_info_panel = true; // 정보 패널 활성화
                global.ui_blocking_input = true;
                global.active_ui_object = id;
                clicked_on_slot = true;
            }
        }
    }

    // ----------------- UI 외부 클릭 시 선택 해제 -----------------
    if (!clicked_on_slot) {
        selected_slot_index = -1;
    }
}
