/// @description oDicemac - Step Event
event_inherited(); // 부모(oMacs_parent)의 공통 Step 로직 실행

// 정보 패널의 좌표를 계산합니다.
var _info_panel_x = panel_x + panel_w - info_panel_width - 20;
var _info_panel_y = panel_y + 60;

switch (state) {
    case DiceMachineState.BETTING:
        if (check_button_click(button_bet_down, _info_panel_x, _info_panel_y)) {
            current_bet = max(min_bet, current_bet - bet_increment);
        }
        if (check_button_click(button_bet_up, _info_panel_x, _info_panel_y)) {
            current_bet = min(max_bet, current_bet + bet_increment);
        }
        if (check_button_click(button_play, _info_panel_x, _info_panel_y)) {
            if (oGame.Player_money >= current_bet) {
                oGame.Player_money -= current_bet;
                reroll_used_this_turn = false;
                
                // 아티팩트 효과 적용 (ON_ROUND_START)
                var applied = apply_artifacts("ON_ROUND_START", { machine: id, bet: current_bet });
                if (array_length(applied) > 0) {
                    applied_artifact_this_turn = applied[0];
                    for (var j = 0; j < array_length(applied); j++) {
                        array_push(artifact_effects, { name: applied[j], timer: 0.5 });
                    }
                }

                state = DiceMachineState.ROLLING;
                roll_timer = roll_animation_time;
            }
        }
        break;

    case DiceMachineState.RESULT:
        if (check_button_click(button_play_again, _info_panel_x, _info_panel_y)) {
            state = DiceMachineState.BETTING;
            applied_artifact_this_turn = noone;
        }
        break;

    case DiceMachineState.ROLLING:
        roll_timer -= delta_time / 1000000;
        if (roll_timer <= 0) {
            dice_result = roll_weighted(dice_probs);
            state = DiceMachineState.SETTLEMENT;
        }
        break;
	
	case DiceMachineState.SETTLEMENT:
	    var handle_settlement = function(_is_win) {
            var applied = [];
            var _context = { machine: id, bet: current_bet, win: _is_win, loss: !_is_win };

            if (_is_win) {
                result_message = "You Win!";
                oGame.Player_money += floor(current_bet * reward_rates[dice_result - 1]);
                applied = apply_artifacts("ON_WIN", _context);
            } else {
                result_message = "You Lose...";
                oGame.lose_token++;
                applied = apply_artifacts("ON_LOSE", _context);
            }
            
            if (array_length(applied) > 0) {
                applied_artifact_this_turn = applied[0];
                for (var j = 0; j < array_length(applied); j++) {
                    array_push(artifact_effects, { name: applied[j], timer: 0.5 });
                }
            }

            oGame.chance_last -= 1;
            state = DiceMachineState.RESULT;
	    }

	    var is_win = (dice_result == target_number);
	    
	    // 패배했고, 재도전 기회가 있다면
	    if (!is_win && check_artifact("Dice_iron") && !reroll_used_this_turn) {
	        if (check_button_click(button_reroll, _info_panel_x, _info_panel_y)) {
	            reroll_used_this_turn = true;
	            state = DiceMachineState.ROLLING;
	            roll_timer = roll_animation_time;
	        }
	        if (check_button_click(button_settle, _info_panel_x, _info_panel_y)) {
	            handle_settlement(false); // 패배로 정산
	        }
	    } else { // 재도전 조건이 아니면 즉시 정산
	        handle_settlement(is_win);
	    }
	    break;
}