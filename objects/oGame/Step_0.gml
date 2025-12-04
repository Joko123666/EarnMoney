/// @description oGame - Step Event

// 게임 오버 연출 처리
if (game_over_state != "none") {
    switch (game_over_state) {
        case "show_result_popup": // 1. 결과 팝업 표시 (이미 생성됨, 대기)
            if (round_result_confirmed) { // 팝업에서 버튼 클릭 시
                game_over_state = "dialogue";
                
                // 실패 대사 출력 (JSON 키 포맷에 맞게 수정: "stage_X_lose")
                var fail_dialogue_key = "stage_" + string(current_stage_index) + "_lose";
                
                // 만약 해당 스테이지 패배 대사가 없으면 기본 실패 대사 사용 (안전장치)
                // 하지만 현재 JSON 구조상 stage_1_lose 등이 있으므로 그대로 사용
                show_dialogue(fail_dialogue_key); 
                
                round_result_confirmed = false; // 리셋
            }
            break;

        case "dialogue": // 2. 악마의 대사 출력
            // 대화가 끝나기를 기다림
            if (!instance_exists(oDialogueBox)) {
                // 대화 종료 후 Dead 이미지 표시 상태로 전환
                game_over_state = "show_dead_image";
                game_over_timer = 2 * room_speed; // 약 2초간 이미지 표시
            }
            break;
            
        case "show_dead_image": // 3. Dead 이미지 표시
            game_over_timer--;
            if (game_over_timer <= 0) {
                game_over_state = "show_popup";
                
                // 결과창이 뜰 때 소울 포인트 계산 (현재는 스테이지 수만큼 획득)
                global.Soulpoint += current_stage_index;
            }
            break;
            
        case "show_popup": // 4. 최종 게임 오버 결과창 (oPopup_GameResult)
            if (!instance_exists(oPopup_GameResult)) {
                var _popup = instance_create_layer(0, 0, "Instances", oPopup_GameResult);
                _popup.is_win = false;
                _popup.final_money = Player_money;
                
                // 소울 포인트 계산 (스테이지 수 * 10 등 로직 구체화 가능, 여기선 단순화)
                var _earned_sp = current_stage_index * 1; 
                _popup.soul_points = _earned_sp;
                global.Soulpoint += _earned_sp;
            }
            break;
            
        case "red_screen": // (레거시 상태 유지)
            game_over_timer--;
            if (game_over_timer <= 0) {
                game_over_state = "fade_to_black";
            }
            break;
            
        case "fade_to_black": // (레거시 상태 유지)
            game_over_alpha = min(1, game_over_alpha + 0.02);
            if (game_over_alpha >= 1) {
                game_over_state = "show_popup";
            }
            break;
    }
    // 게임 오버 연출 중에는 플레이 시간을 측정하지 않음
} else {
    // 게임이 진행 중이고 게임 오버 상태가 아닐 때 플레이 시간 증가
    if (start_game_state) {
        global.session_play_time += delta_time / 1000000;
    }
}

if (game_over_state != "none") exit; // 게임 오버 연출 중에는 다른 로직을 실행하지 않음

// 스테이지 클리어 연출 처리
if (stage_clear_state != "none") {
    switch (stage_clear_state) {
        case "show_result_popup": // 1. 라운드 결과 팝업 표시
             if (round_result_confirmed) { // "다음 라운드로" 버튼 클릭 시
                stage_clear_state = "dialogue";
                
                // 성공 대사 출력 (JSON 키 포맷에 맞게 수정: "stage_X_win")
                var success_dialogue_key = "stage_" + string(current_stage_index) + "_win";
                show_dialogue(success_dialogue_key);
                
                round_result_confirmed = false; // 리셋
            }
            break;

        case "dialogue": // 2. 악마의 칭찬/다음 단계 예고 대사
            // 대화가 끝나기를 기다림
            if (!instance_exists(oDialogueBox)) {
                // 대화가 끝나면 다음 스테이지 팝업 띄우기 (순서 변경됨)
                
                current_stage_index++;
                var next_stage_name = "Stage" + string(current_stage_index);
                
                if (variable_struct_exists(global.stage_list, next_stage_name)) {
                    var next_stage_data = variable_struct_get(global.stage_list, next_stage_name);
                    
                    var _popup = instance_create_layer(0, 0, "Instances", oPopup_NextStage);
                    
                    // --- 특성 적용: 스테이지 시작 자금 및 기회 ---
                    var _trait_stage_money = get_player_trait_level("stage_money") * (current_stage_index * 5);
                    var _trait_stage_chance = get_player_trait_level("stage_chance"); // 레벨만큼 기회 추가
                    
                    _popup.next_stage_name = next_stage_data.display_name;
                    _popup.start_amount = next_stage_data.start_amount + _trait_stage_money; // 보너스 적용된 금액 표시
                    _popup.target_amount = next_stage_data.target_amount;
                    _popup.chance_count = next_stage_data.chance_count + _trait_stage_chance; // 보너스 적용된 기회 표시
                    
                    stage_clear_state = "show_next_stage_popup";
                } else {
                    // 모든 스테이지 클리어 -> 게임 승리
                    if (!instance_exists(oPopup_GameResult)) {
                        var _popup = instance_create_layer(0, 0, "Instances", oPopup_GameResult);
                        _popup.is_win = true;
                        _popup.final_money = Player_money;
                        
                        // 승리 시 소울 포인트 대량 지급 (예: 50)
                        var _earned_sp = 50 + (current_stage_index * 2);
                        _popup.soul_points = _earned_sp;
                        global.Soulpoint += _earned_sp;
                    }
                }
            }
            break;

        case "show_next_stage_popup": // 3. 다음 라운드 정보 팝업
             if (next_stage_confirmed) { // "라운드 시작" 버튼 클릭 시
                next_stage_confirmed = false; // 리셋
                
                // 보상 지급 (보상 선택창 띄우기)
                give_prize(3); 
                
                stage_clear_state = "wait_for_prize";
            }
            break;
            
        case "wait_for_prize": // 4. 보상 선택 대기
            if (!instance_exists(oPrize)) { // 보상 선택 완료
                
                var next_stage_name = "Stage" + string(current_stage_index);
                var next_stage_data = variable_struct_get(global.stage_list, next_stage_name);
                
                // --- 특성 적용: 스테이지 시작 자금 및 기회 (실제 적용) ---
            var _trait_stage_money = get_player_trait_level("stage_money") * (current_stage_index * 5);
            var _trait_stage_chance = get_player_trait_level("stage_chance");
            
            target_amount = next_stage_data.target_amount;
            chance_last = next_stage_data.chance_count + _trait_stage_chance;
            Player_money = next_stage_data.start_amount + _trait_stage_money;
                
                stage_clear_state = "none"; // 연출 종료, 게임 재개
            }
            break;
    }
    exit; // 스테이지 클리어 연출 중에는 다른 로직 실행 안 함
}


// 게임이 시작된 상태에서만 아래 로직을 실행
if (start_game_state == false) exit;

// 남은 기회가 0 이하인지 확인 (라운드 종료 조건)
if (chance_last <= 0) {
    
    // 1. 진행 중인 모든 미니게임 UI 닫기 (강제 초기화)
    if (global.active_ui_object != noone) {
        with (global.active_ui_object) {
            // oMacs_parent를 상속받은 객체라면 state를 IDLE로 되돌리고 닫기 처리
            if (variable_instance_exists(id, "state")) {
                // state = 0; // MacState.IDLE (enum 값이 0이라고 가정)
                // UI 닫기 버튼 로직과 동일하게 처리
                state = 0; // IDLE
                alarm[0] = 1; // 초기화
            }
        }
        global.ui_blocking_input = false;
        global.active_ui_object = noone;
    }

    // 2. 결과 판정 및 팝업 생성
    var _is_success = (Player_money >= target_amount);
    
    var _popup = instance_create_layer(0, 0, "Instances", oPopup_RoundResult);
    _popup.is_success = _is_success;
    _popup.target_amount = target_amount;
    _popup.current_amount = Player_money;
    
    // 3. 상태 변경 (Step 이벤트 상단의 switch문으로 제어권 이동)
    if (_is_success) {
        stage_clear_state = "show_result_popup";
    } else {
        game_over_state = "show_result_popup";
    }
}

// --- 보상 선택창 테스트 코드 ---
if (keyboard_check_pressed(ord("P"))) { if (!instance_exists(oPrize)) give_prize(1); }
if (keyboard_check_pressed(ord("O"))) { if (!instance_exists(oPrize)) give_prize(2); }
if (keyboard_check_pressed(ord("I"))) { if (!instance_exists(oPrize)) give_prize(3); }
