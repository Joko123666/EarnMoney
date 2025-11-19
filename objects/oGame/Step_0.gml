/// @description oGame - Step Event

// 게임 오버 연출 처리
if (game_over_state != "none") {
    switch (game_over_state) {
        case "dialogue":
            // 대화가 끝나기를 기다림
            if (!instance_exists(oDialogueBox)) {
                game_over_state = "red_screen";
                game_over_timer = 1 * room_speed; // 1초 동안 붉은 화면 유지
            }
            break;
            
        case "red_screen":
            game_over_timer--;
            if (game_over_timer <= 0) {
                game_over_state = "fade_to_black";
            }
            break;
            
        case "fade_to_black":
            game_over_alpha = min(1, game_over_alpha + 0.02);
            if (game_over_alpha >= 1) {
                game_over_state = "show_popup";
                if (instance_exists(oHud)) {
                    oHud.show_game_over_popup = true;
                }
            }
            break;
    }
    exit; // 게임 오버 연출 중에는 다른 로직을 실행하지 않음
}

// 스테이지 클리어 연출 처리
if (stage_clear_state != "none") {
    switch (stage_clear_state) {
        case "dialogue":
            // 대화가 끝나기를 기다림
            if (!instance_exists(oDialogueBox)) {
				// 보상 지급
				give_prize(2);
				
                // 다음 스테이지 정보로 갱신
                current_stage_index++;
                var next_stage_name = "Stage" + string(current_stage_index);
                
                if (variable_struct_exists(global.stage_list, next_stage_name)) {
                    var next_stage_data = variable_struct_get(global.stage_list, next_stage_name);
                    chance_last = next_stage_data.chance_count;
                    Player_money = next_stage_data.start_amount;
                    target_amount = next_stage_data.target_amount;
                    show_message("축하합니다! " + next_stage_name + " 시작!");
                } else {
                    show_message("모든 스테이지를 클리어했습니다! 게임 승리!");
                    game_restart();
                }
                
                stage_clear_state = "none"; // 상태 초기화
            }
            break;
    }
    exit; // 스테이지 클리어 연출 중에는 다른 로직 실행 안 함
}


// 게임이 시작된 상태에서만 아래 로직을 실행
if (start_game_state == false) exit;

// 남은 기회가 0 이하인지 확인
if (chance_last <= 0) {
    // 목표 금액 달성 여부 확인
    if (Player_money >= target_amount) {
        // 스테이지 클리어 성공!
        stage_clear_state = "dialogue";
        var success_dialogue_key = "stage" + string(current_stage_index) + "_success";
        show_dialogue(success_dialogue_key);
        
    } else {
        // 목표 금액 달성 실패 (게임 오버)
        game_over_state = "dialogue";
        show_dialogue("fail"); // 실패 대사 출력
    }
}

// --- 보상 선택창 테스트 코드 시작 ---
// 'P' 키를 누르면 보상 선택창을 엽니다.
if (keyboard_check_pressed(ord("P"))) {
    // 이미 보상 선택창이 열려있는지 확인하여 중복 생성을 방지합니다.
    if (!instance_exists(oPrize)) {
        give_prize(1);
    }
}

if (keyboard_check_pressed(ord("O"))) {
    // 이미 보상 선택창이 열려있는지 확인하여 중복 생성을 방지합니다.
    if (!instance_exists(oPrize)) {
        give_prize(2);
    }
}

if (keyboard_check_pressed(ord("I"))) {
    // 이미 보상 선택창이 열려있는지 확인하여 중복 생성을 방지합니다.
    if (!instance_exists(oPrize)) {
        give_prize(3);
    }
}
// --- 보상 선택창 테스트 코드 끝 ---
