/// @description oCoinmac_tutorial - Step Event (Refactored)

// 다른 UI가 활성화되어 있으면 아무 작업도 수행하지 않습니다.
if (global.ui_blocking_input && global.active_ui_object != id) exit;

// 정보 패널의 기준 좌표를 계산합니다.
var _info_panel_x = panel_x + panel_w - info_panel_width - 20;
var _info_panel_y = panel_y + 60;

switch (state) {
    case tutorialCoinMachineState.IDLE:
        // 객체 자체를 클릭하면 UI 패널을 엽니다.
        if (mouse_check_button_pressed(mb_left) && 
            point_in_rectangle(mouse_x, mouse_y, bbox_left, bbox_top, bbox_right, bbox_bottom)) {
            
            state = tutorialCoinMachineState.BETTING; // 상태를 베팅으로 변경
            global.ui_blocking_input = true;
            global.active_ui_object = id;
        }
        break;

    case tutorialCoinMachineState.BETTING:
    case tutorialCoinMachineState.RESULT:
    case tutorialCoinMachineState.SETTLEMENT:

        // 닫기 버튼은 절대 좌표를 사용하므로 base_x, base_y는 0으로 전달합니다.
        if (check_button_click(button_internal_close, 0, 0)) {
            state = tutorialCoinMachineState.IDLE; // IDLE 상태로 전환
            global.ui_blocking_input = false; // UI 차단 해제
            global.active_ui_object = noone; // 활성 UI 객체 없음
            break;
        }
		// 기계 버튼 클릭시 창 닫기
        if (mouse_check_button_pressed(mb_left) && 
            place_meeting(oMouse.x, oMouse.y, oMacs_parent)) {
            state = tutorialCoinMachineState.IDLE;
            global.ui_blocking_input = false;
            global.active_ui_object = noone;
            break;
        }
        
        if (state == tutorialCoinMachineState.BETTING) {
            // 베팅 감소 버튼
            if (check_button_click(button_bet_down, _info_panel_x, _info_panel_y)) {
                current_bet = max(min_bet, current_bet - bet_increment);
            }
            // 베팅 증가 버튼
            if (check_button_click(button_bet_up, _info_panel_x, _info_panel_y)) {
                current_bet = min(max_bet, current_bet + bet_increment);
            }
            // 플레이 버튼
            if (check_button_click(button_play, _info_panel_x, _info_panel_y)) {
                if (oGame.Player_money >= current_bet) {
                    oGame.Player_money -= current_bet; // 돈 차감
                    
                    for (var i = 0; i < coin_count; i++) {
                        coin_results[i] = (random(1) < heads_probability) ? 0 : 1;
                        coin_frame_offsets[i] = irandom(sprite_get_number(sCoin_spin) - 1);
                    }

                    state = tutorialCoinMachineState.TOSSING; // 던지기 상태로 전환
                    toss_timer = single_coin_toss_duration; // 타이머 설정
                }
            }
        } else if (state == tutorialCoinMachineState.RESULT) {
            // 다시하기 버튼
            if (check_button_click(button_play_again, _info_panel_x, _info_panel_y)) {
                alarm[0] = 1; // 알람을 설정하여 게임 상태 초기화
                state = tutorialCoinMachineState.BETTING; // 베팅 상태로 전환
            }
        } else if (state == tutorialCoinMachineState.SETTLEMENT) {
            // 정산 버튼
            if (check_button_click(button_settle, _info_panel_x, _info_panel_y)) {
                var heads_count = 0;
                for (var i = 0; i < coin_count; i++) {
                    if (coin_results[i] == 0) heads_count++;
                }
                if (heads_count > 0) {
                    var win_amount = floor(current_bet * payout_rate);
                    oGame.Player_money += win_amount;
					tutorial_result = "win";
					is_tutorial_game_over = true;
                } else {
                    tutorial_result = "lose";
				    is_tutorial_game_over = true;
                }
                state = tutorialCoinMachineState.RESULT;
            }
        }
        break;

    case tutorialCoinMachineState.TOSSING:
        toss_timer -= delta_time / 1000000;
        if (toss_timer <= 0) {
            state = tutorialCoinMachineState.SETTLEMENT;
        }
        break;
}

if (instance_exists(oTutorial_control) && place_meeting(x, y, oMouse) && mouse_check_button_pressed(mb_left)) 
{ 
	oTutorial_control.is_waiting_for_trigger = false; 
	with (oHud) {camera_location = CameraLocation.TOP; camera_y_to = room_top_y;}
}
