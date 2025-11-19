/// @description oRoulettemac - Step Event
event_inherited(); // 부모(oMacs_parent)의 공통 Step 로직 실행

// 정보 패널의 기준 좌표를 계산합니다.
var _info_panel_x = panel_x + panel_w - info_panel_width - 20;
var _info_panel_y = panel_y + 60;

switch (state) {
    case RouletteState.BETTING:
        if (check_button_click(button_bet_down, _info_panel_x, _info_panel_y)) {
            current_bet = max(min_bet, current_bet - bet_increment);
        }
        if (check_button_click(button_bet_up, _info_panel_x, _info_panel_y)) {
            current_bet = min(max_bet, current_bet + bet_increment);
        }
        if (check_button_click(button_play, _info_panel_x, _info_panel_y)) {
            if (oGame.Player_money >= current_bet) {
                oGame.Player_money -= current_bet;
                
                var applied = apply_artifacts("ON_ROUND_START", { machine: id, bet: current_bet });
                if (array_length(applied) > 0) {
                    for (var j = 0; j < array_length(applied); j++) {
                        array_push(artifact_effects, { name: applied[j], timer: 0.5 });
                    }
                }

                state = RouletteState.SPINNING;
                roulette_speed = random_range(25, 40);
                result_message = "";
            }
        }
        break;

    case RouletteState.RESULT:
        if (check_button_click(button_play_again, _info_panel_x, _info_panel_y)) {
            state = RouletteState.BETTING;
            applied_artifact_this_turn = noone;
        }
        break;

    case RouletteState.SPINNING:
        roulette_angle = (roulette_angle + roulette_speed) mod 360;
        roulette_speed *= roulette_friction;

        if (roulette_speed < 0.1) {
            roulette_speed = 0;
            
            var pointer_angle = 270;
            var final_angle = (roulette_angle - pointer_angle + 360) mod 360;
            
            result_number = 1;
            for (var i = 0; i < 8; i++) {
                if (final_angle < segment_end_angles[i]) {
                    result_number = i + 1;
                    break;
                }
            }

            var payout = reward_rates[result_number - 1];
            var _is_win = (payout > 0);
            var _context = { machine: id, bet: current_bet, win: _is_win, loss: !_is_win, result: result_number };
            var applied = [];

            if (_is_win) {
                var win_amount = current_bet * payout;
                oGame.Player_money += win_amount;
                result_message = "Result: " + string(result_number) + "! You won " + string(win_amount) + " coins!";
                applied = apply_artifacts("ON_WIN", _context);
            } else {
                result_message = "Result: " + string(result_number) + ". Too bad!";
                oGame.lose_token++;
                applied = apply_artifacts("ON_LOSE", _context);
            }
            
            if (array_length(applied) > 0) {
                for (var j = 0; j < array_length(applied); j++) {
                    array_push(artifact_effects, { name: applied[j], timer: 0.5 });
                }
            }
            
            oGame.chance_last -= 1;
            state = RouletteState.RESULT;
        }
        break;
}
