/// @description oRCPmac - Step Event
event_inherited(); // 부모(oMacs_parent)의 공통 Step 로직 실행

// 정보 패널의 기준 좌표를 계산합니다.
var _info_panel_x = panel_x + panel_w - info_panel_width - 20;
var _info_panel_y = panel_y + 60;

switch (state) {
    case RCPMachineState.BETTING:
        if (check_button_click(button_bet_down, _info_panel_x, _info_panel_y)) { current_bet = max(min_bet, current_bet - bet_increment); }
        if (check_button_click(button_bet_up, _info_panel_x, _info_panel_y)) { current_bet = min(max_bet, current_bet + bet_increment); }
        if (check_button_click(button_play, _info_panel_x, _info_panel_y)) {
            if (oGame.Player_money >= current_bet) {
                oGame.Player_money -= current_bet;
                
                win_payout = win_payout_default;
                draw_payout = draw_payout_default;
                
                var applied = apply_artifacts("ON_ROUND_START", { machine: id, bet: current_bet });
                if (array_length(applied) > 0) {
                    for (var j = 0; j < array_length(applied); j++) {
                        array_push(artifact_effects, { name: applied[j], timer: 0.5 });
                    }
                }
                
                state = RCPMachineState.CHOOSING;
            }
        }
        break;

    case RCPMachineState.CHOOSING:
        var choice = -1;
        if (check_button_click(button_rock, _info_panel_x, _info_panel_y)) choice = 0;
        if (check_button_click(button_paper, _info_panel_x, _info_panel_y)) choice = 1;
        if (check_button_click(button_scissors, _info_panel_x, _info_panel_y)) choice = 2;

        if (choice != -1) {
            player_choice = choice;
            computer_choice = irandom(2);
            
            var _context = { machine: id, bet: current_bet, player_choice: player_choice };
            var applied = [];
            
            apply_artifacts("ON_CHOICE", _context);

            if (player_choice == computer_choice) { // 무승부
                winner = -1;
                payout_rate = draw_payout;
                result_message = "Draw!";
                consecutive_losses = 0;
                // applied = apply_artifacts("ON_DRAW", _context); // (향후 확장)
            } else if ((player_choice == 0 && computer_choice == 2) || 
                       (player_choice == 1 && computer_choice == 0) || 
                       (player_choice == 2 && computer_choice == 1)) { // 플레이어 승리
                winner = 0;
                payout_rate = win_payout;
                result_message = "You Win!";
                consecutive_losses = 0;
                applied = apply_artifacts("ON_WIN", _context);
            } else { // 플레이어 패배
                winner = 1;
                payout_rate = 0;
                result_message = "You Lose!";
                oGame.lose_token++;
                consecutive_losses++;
                applied = apply_artifacts("ON_LOSE", _context);
            }

            if (array_length(applied) > 0) {
                for (var j = 0; j < array_length(applied); j++) {
                    array_push(artifact_effects, { name: applied[j], timer: 0.5 });
                }
            }

            state = RCPMachineState.ANIMATING;
            animation_timer = animation_duration;
        }
        break;

    case RCPMachineState.RESULT:
        if (check_button_click(button_play_again, _info_panel_x, _info_panel_y)) {
            state = RCPMachineState.BETTING;
            player_choice = -1;
            computer_choice = -1;
            winner = -1;
            applied_artifact_this_turn = noone;
        }
        break;

    case RCPMachineState.ANIMATING:
        animation_timer--;
        if (animation_timer <= 0) {
            state = RCPMachineState.RESULT;
            if (payout_rate > 0) {
                oGame.Player_money += current_bet * payout_rate;
            }
            oGame.chance_last -= 1;
        }
        break;
}

