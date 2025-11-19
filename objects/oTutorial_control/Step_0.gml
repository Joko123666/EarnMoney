/// @description 튜토리얼 진행 로직

// 한글 주석: 튜토리얼이 활성 상태이고, 특정 트리거를 기다리지 않으며, 대화 상자가 없을 때 다음 단계를 진행합니다.
if (is_active && !is_waiting_for_trigger && !instance_exists(dialogue_instance)) {
    advance_tutorial();
}

// 한글 주석: 트리거를 기다리는 상태일 때의 로직입니다.
if (is_waiting_for_trigger) {
    switch (active_trigger_id) {
        case "coinmac_button_click":
            // 한글 주석: oCoinmac 오브젝트가 클릭되었는지 확인합니다.
			// 실제 클릭 처리는 oCoinmac 오브젝트의 Mouse 이벤트에서 아래와 같이 처리해주는 것이 좋습니다.
			// if (instance_exists(oTutorial_control)) { oTutorial_control.is_waiting_for_trigger = false; }
            break;
            
        case "check_game_result":
            // 한글 주석: 게임(oGame)의 결과(승리/패배)를 확인합니다.
            if (instance_exists(oCoinmac_tutorial) && oCoinmac_tutorial.is_tutorial_game_over) { // oGame에 튜토리얼 게임 종료 변수가 있다고 가정
                is_waiting_for_trigger = false;
                active_trigger_id = "";
                if (oCoinmac_tutorial.tutorial_result == "win") {
                    // 한글 주석: 승리했을 경우, "player_win" ID를 가진 스텝으로 이동합니다.
                    current_step = find_step_by_id("player_win") - 1; // advance_tutorial에서 ++ 되므로 1을 빼줍니다.
					show_debug_message("Trigger met: check_game_result (Win)");
                } else {
                    // 한글 주석: 패배했을 경우, "player_lose" ID를 가진 스텝으로 이동합니다.
                    current_step = find_step_by_id("player_lose") - 1; // advance_tutorial에서 ++ 되므로 1을 빼줍니다.
					show_debug_message("Trigger met: check_game_result (Lose)");
                }
				// is_tutorial_game_over 변수를 다시 false로 설정하여 반복 진행을 방지합니다.
				oCoinmac_tutorial.is_tutorial_game_over = false;
            }
            break;
    }
}

// 한글 주석: 연출 효과를 위한 알파값 보간
if (effect_alpha != effect_target_alpha) {
    effect_alpha = lerp(effect_alpha, effect_target_alpha, 0.1);
	if (abs(effect_alpha - effect_target_alpha) < 0.01) {
		effect_alpha = effect_target_alpha;
	}
}
