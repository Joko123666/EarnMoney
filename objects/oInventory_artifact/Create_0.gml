// ▒ 인벤토리 변수 초기화
// 기본 슬롯 6개 + 특성 보너스 (레벨당 1개 추가 가정)
var _base_slots = 6;
var _bonus_slots = get_player_trait_level("passive_inventorysize"); 
var _total_slots = _base_slots + _bonus_slots;

atti_list = array_create(_total_slots, -1); // -1은 빈 슬롯을 의미합니다.
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

        var _destroyed_count = 0;
        var _effect_applied = false;

        // 아티팩트 효과 적용
        switch (_artifact.name) {
            // --- 소모품 (재화 획득) ---
            case "Common_goldfreg":
                oGame.Player_money += 20;
                _effect_applied = true;
                break;
            case "Common_goldcard":
                oGame.Player_money += 40;
                _effect_applied = true;
                break;
                
            // --- 블랙 시리즈 (머신 파괴 및 보상) ---
            case "Coin_black":
            case "Dice_black":
            case "Cup_black":
            case "Ball_black":
            case "Card_black":
            case "Hand_black":
                var _target_type = "";
                if (_artifact.name == "Coin_black") _target_type = "Coin";
                else if (_artifact.name == "Dice_black") _target_type = "Dice";
                else if (_artifact.name == "Cup_black") _target_type = "Cup";
                else if (_artifact.name == "Ball_black") _target_type = "Ball";
                else if (_artifact.name == "Card_black") _target_type = "Card";
                else if (_artifact.name == "Hand_black") _target_type = "Hand";

                if (_target_type != "") {
                    // 1. 배치된 머신 중 해당 타입 파괴
                    for (var i = 0; i < array_length(oGame.mac_slots); i++) {
                        var _slot = oGame.mac_slots[i];
                        if (instance_exists(_slot.instance_id) && _slot.instance_id.mac_type == _target_type) {
                            instance_destroy(_slot.instance_id);
                            _slot.instance_id = noone;
                            _destroyed_count++;
                        }
                    }
                    
                    // 2. 파괴된 머신 수 * 100D 지급
                    // (아티팩트 자체도 파괴되므로 최소 1개 취급? -> 설명엔 "이 아티팩트와... 파괴한 게임의 수" 라고 되어있음. 
                    // 보통 이런 로그라이크에선 게임기 파괴 보상만 카운트하므로 게임기만 카운트하고 + 자체 보상 100을 더할지 결정 필요.
                    // 설명: "이 아티팩트와 ... 게임을 파괴하고 파괴한 게임의 수 만큼 100D" -> 게임기만 카운트하는 것이 자연스러움)
                    
                    if (_destroyed_count > 0) {
                        oGame.Player_money += _destroyed_count * 100;
                        show_message(string(_destroyed_count) + "개의 게임기가 파괴되어 " + string(_destroyed_count * 100) + "D를 획득했습니다.");
                        _effect_applied = true;
                    } else {
                         show_message("파괴할 수 있는 게임기가 없습니다.");
                         // 효과가 없으므로 아이템 소모 안 함
                         return;
                    }
                }
                break;
                
            default:
                show_message("아직 효과가 구현되지 않았습니다: " + _artifact.name);
                return; // 구현되지 않은 경우 소모 방지
        }
        
        if (_effect_applied) {
            // 1회용 아이템인 경우 사용 후 제거
            atti_list[selected_index] = -1;
            selected_index = -1;
            
            // 정보 패널 닫기 및 UI 상태 복원
            info_panel_visible = false;
            global.ui_blocking_input = false;
            global.active_ui_object = noone;
        }
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
// add_artifact("Coin_gold");
// add_artifact("Lucky_Clover");
