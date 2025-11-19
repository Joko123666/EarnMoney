/// @description oMacs_parent - Step Event (Common Logic)

// --- 아티팩트 이펙트 관리 ---
for (var i = array_length(artifact_effects) - 1; i >= 0; i--) {
    var _effect = artifact_effects[i];
    _effect.timer -= delta_time / 1000000;
    if (_effect.timer <= 0) {
        array_delete(artifact_effects, i, 1);
    }
}

// 다른 UI가 활성화되어 있으면 이 오브젝트의 Step 이벤트를 실행하지 않습니다.
// 자식 오브젝트에서 event_inherited()를 호출하면 이 코드가 가장 먼저 실행됩니다.
if (global.ui_blocking_input && global.active_ui_object != id) exit;

// --- 상태별 공통 로직 ---
switch (state) {
    case MacState.IDLE:
        // IDLE 상태에서 오브젝트를 클릭하면 베팅 UI를 엽니다.
        if (mouse_check_button_pressed(mb_left) && 
            point_in_rectangle(mouse_x, mouse_y, bbox_left, bbox_top, bbox_right, bbox_bottom)) {
            
            // 상태를 BETTING으로 변경합니다.
            // 이 state 변수는 각 자식 오브젝트의 Create 이벤트에서 정의된 enum을 사용합니다.
            state = 1; // 일반적으로 BETTING 상태는 1입니다.
            
            // 다른 UI와의 상호작용을 막습니다.
            global.ui_blocking_input = true;
            global.active_ui_object = id;

            // --- 장착된 관련 아티팩트 목록 채우기 ---
            array_resize(equipped_artifacts, 0); // 기존 목록 비우기
            if (instance_exists(oInventory_artifact)) {
                with (oInventory_artifact) {
                    // 인벤토리의 모든 아티팩트를 순회
                    for (var i = 0; i < array_length(atti_list); i++) {
                        var _artifact = atti_list[i];
                        if (_artifact == -1) continue; // 빈 슬롯 건너뛰기

                        // 이 머신과 관련된 아티팩트인지 확인
                        for (var j = 0; j < array_length(other.relevant_artifacts); j++) {
                            if (_artifact.name == other.relevant_artifacts[j]) {
                                // 관련 아티팩트라면, 장착 목록에 추가
                                array_push(other.equipped_artifacts, _artifact);
                                break; // 다음 인벤토리 슬롯으로
                            }
                        }
                    }
                }
            }
            
            // --- 패시브 아티팩트 효과 적용 ---
            // 1. 기능 플래그 초기화
            reroll_enabled = false;
            
            // 2. PASSIVE 트리거를 가진 아티팩트 효과 적용
            apply_artifacts("PASSIVE", { machine: id });
        }
        break;

    // UI가 열려있는 모든 상태 (BETTING, RESULT 등)
    default:
        // 닫기 버튼을 누르면 IDLE 상태로 돌아가고 UI를 닫습니다.
        if (check_button_click(button_internal_close, 0, 0)) {
            state = MacState.IDLE; // IDLE 상태로
            global.ui_blocking_input = false; // UI 잠금 해제
            global.active_ui_object = noone;  // 활성 UI 오브젝트 초기화
            
            // 알람 0을 실행하여 게임 상태를 초기화합니다.
            // 각 자식 오브젝트의 Alarm 0 이벤트가 실행됩니다.
            alarm[0] = 1; 
            
            // 이후의 자식 Step 코드를 실행하지 않고 즉시 종료합니다.
            exit; 
        }
        break;
}