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

// 인터랙션 쿨타임 감소
if (interact_cooldown > 0) interact_cooldown -= delta_time / 1000000;

// --- 상태별 공통 로직 ---
switch (state) {
    case MacState.IDLE:
        // IDLE 상태에서 오브젝트를 클릭하면 베팅 UI를 엽니다.
        // 쿨타임이 없을 때만 작동
        if (interact_cooldown <= 0 && mouse_check_button_pressed(mb_left) && 
            point_in_rectangle(mouse_x, mouse_y, bbox_left, bbox_top, bbox_right, bbox_bottom)) {
            
            // 상태를 BETTING으로 변경합니다.
            // 이 state 변수는 각 자식 오브젝트의 Create 이벤트에서 정의된 enum을 사용합니다.
            state = 1; // 일반적으로 BETTING 상태는 1입니다.
            
            // 다른 UI와의 상호작용을 막습니다.
            global.ui_blocking_input = true;
            global.active_ui_object = id;
            
            // --- 특성 적용: passive_maxbet (베팅 상한 증가) ---
            // 기본 max_bet은 자식 객체의 Create에서 설정되므로, 여기서는 특성 추가분만 더해줍니다.
            // 주의: 이 로직이 반복 호출되면 max_bet이 계속 늘어날 수 있으므로, 
            // 원래의 max_bet 값을 저장해두거나(base_max_bet), 
            // 초기화 시(Alarm 0) 리셋하는 로직이 필요합니다.
            // 여기서는 단순하게 고정값(100 등)에 더하는 방식 대신, 자식 객체의 기본 설정을 존중하기 위해
            // 별도의 base_max_bet 변수를 사용하지 않고, 
            // "매번 UI 열 때마다 자식 객체가 설정한 기본값 + 특성값"으로 재계산하는 것이 안전합니다.
            
            // 하지만 자식 객체의 Create 이후 max_bet을 건드리는 곳이 여기뿐이라면,
            // 간단하게 Alarm 0 (초기화)에서 max_bet을 원래대로 돌려놓는 것이 좋습니다.
            // 혹은 더 안전하게:
            // max_bet = 100 + (get_player_trait_level("passive_maxbet") * 10); 
            // 이렇게 하드코딩하면 자식별로 다른 max_bet을 가질 수 없게 됩니다.
            
            // 해결책: 자식 객체의 Alarm 0에서 max_bet을 리셋하도록 권장하고,
            // 여기서는 특성 값을 더해줍니다. (단, 중복 적용 방지를 위해 Alarm 0에서 초기화 필수)
            
            // 더 나은 해결책: 자식 객체들은 보통 Create에서 max_bet = 100; 처럼 설정합니다.
            // 그러므로 여기서 max_bet += ... 을 하면 계속 늘어납니다.
            // 따라서 자식 객체의 Alarm 0이 호출될 때(UI 닫힐 때) 변수들이 초기화되는지 확인해야 합니다.
            // 확인 결과: oCoinmac, oDicemac 등의 Alarm 0은 보통 비어있거나 간단한 초기화만 합니다.
            
            // 안전한 구현: 
            // 1. 자식 객체의 기본 max_bet을 알 수 없으므로, 잠정적으로 100이라고 가정하거나
            // 2. 이펙트 적용 전에 base_max_bet을 기록합니다.
            
            if (!variable_instance_exists(id, "base_max_bet")) {
                base_max_bet = max_bet; // 최초 1회 기본값 저장
            }
            
            // 기본값 + 특성 보너스로 재설정
            var _bonus_max_bet = get_player_trait_level("passive_maxbet") * 10;
            max_bet = base_max_bet + _bonus_max_bet;


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
        // 룰 팝업 처리
        if (show_rule_popup) {
            var _popup_w = 600;
            var _popup_h = 400;
            var _popup_x = panel_x + (panel_w - _popup_w) / 2;
            var _popup_y = panel_y + (panel_h - _popup_h) / 2;
            
            button_rule_close.x = _popup_x + _popup_w - 40;
            button_rule_close.y = _popup_y + 10;
            
            if (check_button_click(button_rule_close, 0, 0)) {
                show_rule_popup = false;
            }
        }

        // 룰 설명 버튼 처리
        if (check_button_click(button_rule, 0, 0)) {
            show_rule_popup = !show_rule_popup;
        }

        // 닫기 버튼을 누르면 IDLE 상태로 돌아가고 UI를 닫습니다.
        if (check_button_click(button_internal_close, 0, 0)) {
            state = MacState.IDLE; // IDLE 상태로
            global.ui_blocking_input = false; // UI 잠금 해제
            global.active_ui_object = noone;  // 활성 UI 오브젝트 초기화
            show_rule_popup = false; // 팝업 닫기
            
            // 쿨타임 설정 및 입력 클리어 (점멸 방지)
            interact_cooldown = 0.2; 
            mouse_clear(mb_left);
            
            // 알람 0을 실행하여 게임 상태를 초기화합니다.
            // 각 자식 오브젝트의 Alarm 0 이벤트가 실행됩니다.
            alarm[0] = 1; 
            
            // 이후의 자식 Step 코드를 실행하지 않고 즉시 종료합니다.
            exit; 
        }
        break;
}
