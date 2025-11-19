/// @description oMultiplymac - Step Event
event_inherited(); // 부모(oMacs_parent)의 공통 Step 로직 실행

// 정보 패널의 기준 좌표를 계산합니다.
var _info_panel_x = panel_x + panel_w - info_panel_width - 20;
var _info_panel_y = panel_y + 60;

switch (state) {
    case MultiplyMacState.BETTING:
        if (check_button_click(button_bet_down, _info_panel_x, _info_panel_y)) current_bet = max(min_bet, current_bet - bet_increment);
        if (check_button_click(button_bet_up, _info_panel_x, _info_panel_y)) current_bet = min(max_bet, current_bet + bet_increment);
        if (check_button_click(button_play, _info_panel_x, _info_panel_y)) {
            if (oGame.Player_money >= current_bet) {
                oGame.Player_money -= current_bet;
                audio_play_sound(SE_startgame, 1, false);
                
                // 아티팩트 효과 적용 (ON_ROUND_START)
                var applied = apply_artifacts("ON_ROUND_START", { machine: id, bet: current_bet });
                if (array_length(applied) > 0) {
                    applied_artifact_this_turn = applied[0];
                    for (var j = 0; j < array_length(applied); j++) {
                        array_push(artifact_effects, { name: applied[j], timer: 0.5 });
                    }
                }
                
                anim_timer = spin_duration;
                state = MultiplyMacState.SPINNING;
            }
        }
        break;

    case MultiplyMacState.RESULT:
        if (anim_timer > 0) {
            anim_timer -= delta_time / 1000000;
        }
        if (check_button_click(button_play_again, _info_panel_x, _info_panel_y) && anim_timer <= 0) {
            state = MultiplyMacState.BETTING;
            applied_artifact_this_turn = noone;
        }
        break;

    case MultiplyMacState.SPINNING:
        anim_timer -= delta_time / 1000000;
        if (anim_timer <= 0) {
            number1 = irandom_range(1, 9);
            number2 = irandom_range(1, 9);
            game_result = number1 * number2;
            
            var _is_win = (game_result >= 40);
            var _context = { machine: id, bet: current_bet, win: _is_win, loss: !_is_win, result: game_result };
            var applied = [];

            if (_is_win) {
                payout_rate = game_result / 10;
                result_message = "You Win!";
                oGame.Player_money += floor(current_bet * payout_rate);
                audio_play_sound(SE_win, 1, false);
                applied = apply_artifacts("ON_WIN", _context);
            } else {
                result_message = "You Lose...";
                oGame.lose_token++;
                audio_play_sound(SE_lose, 1, false);
                applied = apply_artifacts("ON_LOSE", _context);
            }
            
            if (array_length(applied) > 0) {
                applied_artifact_this_turn = applied[0];
                for (var j = 0; j < array_length(applied); j++) {
                    array_push(artifact_effects, { name: applied[j], timer: 0.5 });
                }
            }
            
            oGame.chance_last -= 1;
            anim_timer = result_delay_duration;
            state = MultiplyMacState.RESULT;
        }
        break;
}
