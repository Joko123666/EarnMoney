/// @description oCoinmac2 - Step Event
event_inherited(); // 부모(oMacs_parent)의 공통 Step 로직 실행

// 정보 패널의 기준 좌표를 계산합니다.
var _info_panel_x = panel_x + panel_w - info_panel_width - 20;
var _info_panel_y = panel_y + 60;

switch (state) {
    case CoinMachine2State.BETTING:
        if (check_button_click(button_bet_down, _info_panel_x, _info_panel_y)) {
            current_bet = max(min_bet, current_bet - bet_increment);
        }
        if (check_button_click(button_bet_up, _info_panel_x, _info_panel_y)) {
            current_bet = min(max_bet, current_bet + bet_increment);
        }
        if (check_button_click(button_play, _info_panel_x, _info_panel_y)) {
            if (oGame.Player_money >= current_bet) {
                audio_play_sound(SE_coinin, 1, false);
                oGame.Player_money -= current_bet;
                
                // 아티팩트 효과 적용 (ON_ROUND_START)
                var applied = apply_artifacts("ON_ROUND_START", { machine: id, bet: current_bet });
                if (array_length(applied) > 0) {
                    applied_artifact_this_turn = applied[0];
                    for (var j = 0; j < array_length(applied); j++) {
                        array_push(artifact_effects, { name: applied[j], timer: 0.5 });
                    }
                }
                
                for (var i = 0; i < coin_count; i++) {
                    coin_results[i] = (random(1) < heads_probability) ? 0 : 1;
                    coin_frame_offsets[i] = irandom(sprite_get_number(sCoin_spin) - 1);
                }

                state = CoinMachine2State.TOSSING;
                toss_timer = single_coin_toss_duration + (toss_delay_per_coin * (coin_count - 1));
            }
        }
        break;

    case CoinMachine2State.RESULT:
        if (check_button_click(button_play_again, _info_panel_x, _info_panel_y)) {
            alarm[0] = 1;
            state = CoinMachine2State.BETTING;
            applied_artifact_this_turn = noone;
        }
        break;

    case CoinMachine2State.SETTLEMENT:
        var handle_settlement = function() {
            var heads_count = 0;
            for (var i = 0; i < coin_count; i++) {
                if (coin_results[i] == 0) heads_count++;
            }
            
            var applied = [];
            if (heads_count > 0) { // 승리
                audio_play_sound(SE_win, 1, false);
                var win_amount = floor(current_bet * heads_count * payout_rate);
                oGame.Player_money += win_amount;
                applied = apply_artifacts("ON_WIN", { machine: id, bet: current_bet, win_amount: win_amount });
            } else { // 패배
                audio_play_sound(SE_lose, 1, false);
                oGame.lose_token++;
                applied = apply_artifacts("ON_LOSE", { machine: id, bet: current_bet });
            }
            
            if (array_length(applied) > 0) {
                applied_artifact_this_turn = applied[0];
                for (var j = 0; j < array_length(applied); j++) {
                    array_push(artifact_effects, { name: applied[j], timer: 0.5 });
                }
            }

            oGame.chance_last -= 1;
            state = CoinMachine2State.RESULT;
        }

        if (reroll_enabled && !reroll_used_this_turn) {
            if (check_button_click(button_reroll, _info_panel_x, _info_panel_y)) {
                reroll_used_this_turn = true;
                for (var i = 0; i < coin_count; i++) {
                    coin_results[i] = (random(1) < heads_probability) ? 0 : 1;
                    coin_frame_offsets[i] = irandom(sprite_get_number(sCoin_spin) - 1);
                }
                state = CoinMachine2State.TOSSING;
                toss_timer = single_coin_toss_duration + (toss_delay_per_coin * (coin_count - 1));
            }
            if (check_button_click(button_settle, _info_panel_x, _info_panel_y)) {
                handle_settlement();
            }
        } else {
            if (check_button_click(button_settle_full, _info_panel_x, _info_panel_y)) {
                handle_settlement();
            }
        }
        break;

    case CoinMachine2State.TOSSING:
        if (toss_timer == single_coin_toss_duration + (toss_delay_per_coin * (coin_count - 1))) {
            audio_play_sound(SE_cointoss, 1, false);
        }
        toss_timer -= delta_time / 1000000;
        if (toss_timer <= 0) {
            state = CoinMachine2State.SETTLEMENT;
        }
        break;
}