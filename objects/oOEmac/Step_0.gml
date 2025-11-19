/// @description oOEmac - Step Event
event_inherited(); // 부모(oMacs_parent)의 공통 Step 로직 실행

// 정보 패널의 기준 좌표를 계산합니다.
var _info_panel_x = panel_x + panel_w - info_panel_width - 20;
var _info_panel_y = panel_y + 60;

// --- 상태별 로직 처리 ---
switch (state) {
    case OEmacState.BETTING:
        if (check_button_click(button_bet_down, _info_panel_x, _info_panel_y)) current_bet = max(min_bet, current_bet - bet_increment);
        if (check_button_click(button_bet_up, _info_panel_x, _info_panel_y)) current_bet = min(max_bet, current_bet + bet_increment);
        if (check_button_click(button_play, _info_panel_x, _info_panel_y)) {
            if (oGame.Player_money >= current_bet) {
                audio_play_sound(SE_startgame, 1, false);
                oGame.Player_money -= current_bet;

                // 아티팩트 효과 적용 (ON_ROUND_START)
                var applied = apply_artifacts("ON_ROUND_START", { machine: id, bet: current_bet });
                if (array_length(applied) > 0) {
                    applied_artifact_this_turn = applied[0];
                    for (var j = 0; j < array_length(applied); j++) {
                        array_push(artifact_effects, { name: applied[j], timer: 0.5 });
                    }
                }

                dice_results[0] = irandom_range(1, 6);
                dice_results[1] = irandom_range(1, 6);
                dice_sum = dice_results[0] + dice_results[1];
                anim_timer = cup_anim_duration;
                state = OEmacState.ROLLING;
            }
        }
        break;

    case OEmacState.CHOOSING:
        var choice_made = "";
        if (check_button_click(button_choose_odd, 0, 0)) choice_made = "Odd";
        if (check_button_click(button_choose_even, 0, 0)) choice_made = "Even";
        
        if (choice_made != "") {
            player_choice = choice_made;
            audio_play_sound(SE_setresult, 1, false);
            anim_timer = pre_reveal_delay_duration;
            state = OEmacState.PRE_REVEAL;
        }
        break;

    case OEmacState.RESULT:
        if (anim_timer > 0) {
            anim_timer -= delta_time / 1000000;
        }
        if (check_button_click(button_play_again, _info_panel_x, _info_panel_y) && anim_timer <= 0) {
            alarm[0] = 1;
            state = OEmacState.BETTING;
            applied_artifact_this_turn = noone;
        }
        break;

    case OEmacState.ROLLING:
        anim_timer -= delta_time / 1000000;
        if (anim_timer <= 0) {
            audio_play_sound(SE_rolldice, 1, false);
            state = OEmacState.CHOOSING;
        }
        break;

    case OEmacState.PRE_REVEAL:
        anim_timer -= delta_time / 1000000;
        if (anim_timer <= 0) {
            anim_timer = cup_anim_duration;
            state = OEmacState.REVEAL;
        }
        break;

    case OEmacState.REVEAL:
        anim_timer -= delta_time / 1000000;
        if (anim_timer <= 0) {
            var is_even = (dice_sum % 2 == 0);
            var _is_win = (player_choice == "Even" && is_even) || (player_choice == "Odd" && !is_even);
            var _context = { machine: id, bet: current_bet, win: _is_win, loss: !_is_win, dice_sum: dice_sum };
            var applied = [];

            if (_is_win) {
                result_message = "승리!";
                oGame.Player_money += floor(current_bet * payout_rate);
                audio_play_sound(SE_win, 1, false);
                applied = apply_artifacts("ON_WIN", _context);
            } else {
                result_message = "패배...";
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
            anim_timer = reveal_delay_duration;
            state = OEmacState.RESULT;
        }
        break;
}
