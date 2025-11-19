/// @description 보상 생성 및 자기 파괴

// 한글 주석: 플레이어가 선택한 항목의 정보를 가져옵니다.
var _choice = choices[selected_choice];

// 한글 주석: '포기'를 선택했는지 확인합니다.
if (variable_struct_exists(_choice, "is_decline") && _choice.is_decline) {
    // 아무것도 하지 않고 창을 닫습니다.
} 
// 한글 주석: 선택한 것이 아티팩트인지 확인합니다.
else if (_choice.is_artifact) {
    // 한글 주석: 아티팩트 인벤토리 오브젝트가 있는지 확인합니다.
    if (instance_exists(oInventory_artifact)) {
        // 한글 주석: 인벤토리에 아티팩트를 추가합니다.
        oInventory_artifact.add_artifact(_choice.name);
        show_message(_choice.name + " 을(를) 획득했습니다!");
    } else {
        show_debug_message("ERROR: oInventory_artifact 인스턴스가 존재하지 않습니다.");
    }
} 
// 한글 주석: 도박 기계를 선택한 경우입니다.
else {
    // 한글 주석: 슬롯이 가득 찼는지 확인합니다.
    if (slots_full) {
        show_message("슬롯이 가득 차 있어 기계를 설치할 수 없습니다.");
    } 
    // 한글 주석: 슬롯에 여유가 있는 경우, 기계를 설치합니다.
    else if (target_slot != -1) {
        var _target_pos = oGame.mac_slots[target_slot];

        // 한글 주석: 해당 슬롯에 이미 다른 기계가 있는지 확인하고, 있다면 파괴합니다.
        if (instance_exists(_target_pos.instance_id)) {
            instance_destroy(_target_pos.instance_id);
        }

        // 한글 주석: 선택된 도박 기계 인스턴스를 목표 위치에 생성합니다.
        var _new_mac = instance_create_layer(_target_pos.x, _target_pos.y, "Instances", _choice.obj_id);

        // 한글 주석: 새로 생성된 기계의 ID를 oGame의 슬롯 정보에 업데이트합니다.
        _target_pos.instance_id = _new_mac;
    } else {
        show_debug_message("ERROR: 유효하지 않은 target_slot으로 머신을 생성하려고 했습니다.");
    }
}

// 한글 주석: UI 입력 독점을 해제합니다.
if (global.active_ui_object == id) {
    global.ui_blocking_input = false;
    global.active_ui_object = noone;
}

// 한글 주석: 보상 선택 창(oPrize 자기 자신)을 파괴합니다.
instance_destroy();