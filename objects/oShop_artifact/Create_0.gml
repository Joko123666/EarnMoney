// =================================================================
// 상점 기본 설정
// =================================================================
display_slots = 3; // 진열대 칸 수 (나중에 업그레이드로 이 값을 늘릴 수 있음)
reroll_cost = 1;  // '갱신'에 필요한 비용

// =================================================================
// 상점 상태 변수
// =================================================================
shop_slots = array_create(display_slots, -1); // 현재 진열된 상품 정보를 담을 배열
selected_slot_index = -1; // 플레이어가 구매를 위해 선택한 슬롯의 인덱스

// 아티팩트 정보 패널 관련 변수
show_info_panel = false;
selected_artifact_data = -1; // 선택된 아티팩트의 데이터 (struct)

// 정보 패널의 위치 및 크기 (임시 설정, 나중에 중앙 정렬로 변경 가능)
info_panel_width = 250;
info_panel_height = 200;
info_panel_x = (display_get_gui_width() / 2) - (info_panel_width / 2);
info_panel_y = (display_get_gui_height() / 2) - (info_panel_height / 2);

// 구매 버튼 정의 (정보 패널 내에서의 상대 좌표)
purchase_button = { x: info_panel_x + 50, y: info_panel_y + info_panel_height - 50, rel_x: 50, rel_y: info_panel_height - 50, w: 150, h: 40, label: "구매" };



// =================================================================
// 상점 기능 함수 정의
// =================================================================

/// @function restock_shop()
/// @description 상품 진열대를 비우고 마스터 리스트에서 랜덤 상품으로 다시 채웁니다.
function restock_shop() {
    // 선택 상태 초기화
    selected_slot_index = -1;
    
    // 기존 상품 비우기
    for (var i = 0; i < display_slots; i++) {
        shop_slots[i] = -1;
    }

    // 새로운 상품 진열하기
    var _master_list_copy = array_create(array_length(global.artifact_list));
    array_copy(_master_list_copy, 0, global.artifact_list, 0, array_length(global.artifact_list)); // 중복 방지를 위해 마스터 리스트 복사
    
    for (var i = 0; i < display_slots; i++) {
        if (array_length(_master_list_copy) > 0) {
            var _random_index = irandom(array_length(_master_list_copy) - 1);
            shop_slots[i] = _master_list_copy[_random_index];
            array_delete(_master_list_copy, _random_index, 1); // 뽑힌 아이템은 복사본에서 제거
        }
    }
}

// =================================================================
// 상점 생성 시 첫 상품 진열
// =================================================================
restock_shop();