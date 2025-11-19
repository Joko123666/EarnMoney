// ▒ 인벤토리 변수 초기화
atti_list = array_create(6, -1); // -1은 빈 슬롯을 의미합니다.
selected_index = -1;
sprite_background = sBox;
sprite_artifact = sArtifact;

// 정보 패널 관련 변수
info_panel_visible = false;
selected_artifact_data = -1;
info_panel_width = 300;
info_panel_height = 250;
info_panel_x = 0;
info_panel_y = 0;

// 정보 패널 내부 버튼 정의 (균형 잡힌 배치)
var _button_w = 80;
var _button_h = 40;
var _button_y = info_panel_height - 55; // 모든 버튼의 y 위치
var _button_gap = 10;
var _total_button_width = (_button_w * 3) + (_button_gap * 2); // 버튼 3개와 사이 간격
var _button_start_x = (info_panel_width - _total_button_width) / 2;

button_use = { x: 0, y: 0, rel_x: _button_start_x, rel_y: _button_y, w: _button_w, h: _button_h, label: "사용", sprite: sButton };
button_sell = { x: 0, y: 0, rel_x: _button_start_x + _button_w + _button_gap, rel_y: _button_y, w: _button_w, h: _button_h, label: "판매", sprite: sButton };
button_close = { x: 0, y: 0, rel_x: _button_start_x + (_button_w + _button_gap) * 2, rel_y: _button_y, w: _button_w, h: _button_h, label: "닫기", sprite: sButton };


/// @function find_artifact_data(name)
/// @description 이름으로 global.artifact_list에서 아티팩트 데이터를 찾습니다.
function find_artifact_data(name) {
    for (var i = 0; i < array_length(global.artifact_list); i++) {
        if (global.artifact_list[i].name == name) {
            return global.artifact_list[i];
        }
    }
    return -1; // 찾지 못한 경우
}

/// @function add_artifact(name)
/// ▒ 아티팩트를 이름으로 추가
function add_artifact(name) {
    var _artifact_data = find_artifact_data(name);
    if (_artifact_data == -1) {
        show_debug_message("경고: " + name + " 아티팩트를 찾을 수 없습니다.");
        return;
    }

    for (var i = 0; i < array_length(atti_list); i++) {
        if (atti_list[i] == -1) {
            atti_list[i] = _artifact_data;
            break;
        }
    }
}

/// @function has_artifact(name)
/// ▒ 해당 아티팩트가 존재하는지 확인
function has_artifact(name) {
    for (var i = 0; i < array_length(atti_list); i++) {
        if (atti_list[i] != -1 && atti_list[i].name == name) {
            return true;
        }
    }
    return false;
}

/// @function swap_artifacts(index1, index2)
/// ▒ 두 슬롯의 아티팩트를 교환
function swap_artifacts(index1, index2) {
    var tmp = atti_list[index1];
    atti_list[index1] = atti_list[index2];
    atti_list[index2] = tmp;
}

/// @function sell_artifact()
/// @description 선택된 아티팩트를 판매합니다.
function sell_artifact() {
    if (selected_index != -1 && atti_list[selected_index] != -1) {
        var _artifact = atti_list[selected_index];
        oGame.lose_token += _artifact.selling_price;
        atti_list[selected_index] = -1; // 슬롯 비우기
        selected_index = -1; // 선택 해제
        
        // 정보 패널 닫기 및 UI 상태 복원
        info_panel_visible = false;
        global.ui_blocking_input = false;
        global.active_ui_object = noone;
    }
}

/// @function use_artifact()
/// @description 선택된 아티팩트를 사용합니다.
function use_artifact() {
    if (selected_index != -1 && atti_list[selected_index] != -1) {
        var _artifact = atti_list[selected_index];
        
        if (!_artifact.usable) {
            show_message("이 아이템은 사용할 수 없습니다: " + _artifact.name);
            return;
        }

        // 아티팩트 효과 적용
        switch (_artifact.name) {
            case "Lucky_Clover":
                show_message("행운이 가득한 기분이다!");
                break;
            case "Magic_Dice":
                show_message("다음 슬롯머신은 무조건 성공할 것 같다!");
                break;
            default:
                show_message("아직 효과가 구현되지 않았습니다: " + _artifact.name);
                break;
        }
        
        // 1회용 아이템인 경우 사용 후 제거
        atti_list[selected_index] = -1;
        selected_index = -1;
        
        // 정보 패널 닫기 및 UI 상태 복원
        info_panel_visible = false;
        global.ui_blocking_input = false;
        global.active_ui_object = noone;
    }
}

/// @function is_full()
/// @description 인벤토리가 가득 찼는지 확인합니다.
function is_full() {
    for (var i = 0; i < array_length(atti_list); i++) {
        if (atti_list[i] == -1) {
            return false; // 빈 슬롯이 하나라도 있으면 false 반환
        }
    }
    return true; // 빈 슬롯이 없으면 true 반환
}

// 테스트용 초기 아이템 추가
add_artifact("Coin_gold");
add_artifact("Lucky_Clover");