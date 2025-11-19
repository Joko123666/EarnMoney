
/// @description 다음 튜토리얼 스텝 처리 (User Event 0)

// 모든 스텝을 완료했으면 종료
if (!is_active || current_step >= array_length(tutorial_data.tutorial_steps)) {
    is_active = false;
    exit;
}

// 현재 스텝 가져오기
var _step_data = tutorial_data.tutorial_steps[current_step];
var _type = _step_data.type;

// 다음 스텝으로 미리 이동
current_step++;

// 스텝 타입에 따라 분기
if (_type == "dialogue") {
    // 대화 상자 생성
    dialogue_instance = instance_create_layer(0, 0, "Instances", oDialogueBox);
    dialogue_instance.text = _step_data.text;
    
    // 스피커 정보가 있으면 설정
    if (variable_struct_exists(_step_data, "speaker")) {
        dialogue_instance.speaker = _step_data.speaker;
    }
    
} else if (_type == "trigger") {
    // 트리거 대기 상태로 설정
    is_waiting_for_trigger = true;
    active_trigger_id = _step_data.trigger_id;
    
    // 각 트리거에 대한 주석화된 가이드
    switch (active_trigger_id) {
        case "use_coin_machine":
            // TODO: 플레이어가 코인 기계를 사용했는지 확인하는 로직을 oCoinmac의 Step 이벤트 등에서 처리하고,
            // 완료 시 'with (oTutorial_control) { event_user(1, "use_coin_machine"); }'를 호출해야 합니다.
            break;
        case "use_dice_machine":
            // TODO: 플레이어가 주사위 기계를 사용했는지 확인하고, 완료 시 event_user(1, "use_dice_machine")를 호출하세요.
            break;
        case "use_all_machines":
            // TODO: 플레이어가 모든 기계를 사용했는지 확인하고, 완료 시 event_user(1, "use_all_machines")를 호출하세요.
            break;
        case "end_tutorial":
            // TODO: 튜토리얼 종료 시 필요한 로직 (예: 방 이동)을 처리하세요.
            show_message("튜토리얼이 종료되었습니다!");
            is_active = false; // 튜토리얼 종료
            break;
    }
}
