/// @description oUpdownmac - Step Event

// 부모 이벤트 상속 (필수)
event_inherited();

if (global.ui_blocking_input && global.active_ui_object != id) exit;

// 버튼 클릭 확인을 위한 기준 좌표 계산
var _info_panel_x = panel_x + panel_w - info_panel_width - 20;
var _info_panel_y = panel_y + 60;

switch (state) {
    case UpdownMachineState.IDLE:
        if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mouse_x, mouse_y, bbox_left, bbox_top, bbox_right, bbox_bottom)) {
            state = UpdownMachineState.BETTING;
            global.ui_blocking_input = true;
            global.active_ui_object = id;
        }
        break;

    case UpdownMachineState.BETTING:
    case UpdownMachineState.CHOOSING:
    case UpdownMachineState.RESULT:
        // 닫기 버튼은 절대 좌표 사용
        if (check_button_click(button_internal_close, 0, 0)) {
            state = UpdownMachineState.IDLE;
            global.ui_blocking_input = false;
            global.active_ui_object = noone;
            exit;
        }

        if (state == UpdownMachineState.BETTING) {
            // 베팅 버튼은 상대 좌표 사용 -> 오프셋 전달
            if (check_button_click(button_bet_down, _info_panel_x, _info_panel_y)) { current_bet = max(min_bet, current_bet - bet_increment); }
            if (check_button_click(button_bet_up, _info_panel_x, _info_panel_y)) { current_bet = min(max_bet, current_bet + bet_increment); }
            
            // 플레이 버튼은 절대 좌표 사용
            if (check_button_click(button_play, 0, 0)) {
                if (oGame.Player_money >= current_bet) {
                    oGame.Player_money -= current_bet;
                    state = UpdownMachineState.CHOOSING;
                    result_message = "Choose Up, Down, or 7";
                }
            }
        } else if (state == UpdownMachineState.CHOOSING) {
            // 선택 버튼들은 절대 좌표 사용
            if (check_button_click(button_down, 0, 0)) { player_choice = 0; }
            else if (check_button_click(button_seven, 0, 0)) { player_choice = 1; }
            else if (check_button_click(button_up, 0, 0)) { player_choice = 2; }

            if (player_choice != -1) {
                state = UpdownMachineState.ROLLING;
                animation_timer = animation_duration;
            }
        } else if (state == UpdownMachineState.RESULT) {
            // 다시하기 버튼은 절대 좌표 사용
            if (check_button_click(button_play_again, 0, 0)) {
                state = UpdownMachineState.BETTING;
                player_choice = -1;
                dice1_value = 1;
                dice2_value = 1;
                dice_sum = 0;
                result_message = "";
                payout_rate = 0;
                reveal_step = 0;
                dice1_scale = dice_default_scale;
                dice2_scale = dice_default_scale;
            }
        }
        break;

    case UpdownMachineState.ROLLING:
        animation_timer--;
        dice1_value = irandom_range(1, 6);
        dice2_value = irandom_range(1, 6);
        if (animation_timer <= 0) {
            state = UpdownMachineState.REVEALING;
            reveal_step = 1;
            reveal_timer = reveal_duration;
            dice1_value = irandom_range(1, 6);
            dice2_value = irandom_range(1, 6);
            dice1_scale = dice_reveal_scale;
            dice2_scale = dice_default_scale;
        }
        break;

    case UpdownMachineState.REVEALING:
        reveal_timer--;
        if (reveal_timer <= 0) {
            reveal_step++;
            reveal_timer = reveal_duration;

            if (reveal_step == 2) {
                dice1_scale = dice_default_scale;
                dice2_scale = dice_reveal_scale;
            } else if (reveal_step == 3) {
                dice2_scale = dice_default_scale;
                dice_sum = dice1_value + dice2_value;
                
                var _win_condition = (dice_sum < 7) ? 0 : ((dice_sum == 7) ? 1 : 2);
                
                if (player_choice == _win_condition) {
                    result_message = "You Win!";
                    if (player_choice == 0) payout_rate = payout_down;
                    else if (player_choice == 1) payout_rate = payout_seven;
                    else payout_rate = payout_up;
                } else {
                    result_message = "You Lose!";
                    payout_rate = 0;
					oGame.lose_token ++;
                }
                oGame.Player_money += current_bet * payout_rate;
                oGame.chance_last -= 1;
                state = UpdownMachineState.RESULT;
            }
        }
        break;
}