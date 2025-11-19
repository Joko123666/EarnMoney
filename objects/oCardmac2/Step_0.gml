/// @description oCardmac2 - Step Event
event_inherited(); // 부모(oMacs_parent)의 공통 Step 로직 실행

// 정보 패널의 기준 좌표를 계산합니다.
var _info_panel_x = panel_x + panel_w - info_panel_width - 20;
var _info_panel_y = panel_y + 60;

switch (state) {
    case CardMac2State.BETTING:
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

                // --- 덱 2개 생성 및 섞기 ---
                var _create_deck = function() {
                    var _deck = [];
                    for (var i = 1; i <= 10; i++) { array_push(_deck, i); }
                    for (var i = array_length(_deck) - 1; i > 0; i--) {
                        var j = irandom(i);
                        var _temp = _deck[i]; _deck[i] = _deck[j]; _deck[j] = _temp;
                    }
                    return _deck;
                }
                player_deck = _create_deck();
                dealer_deck = _create_deck();
                
                player_card_value = player_deck[0];
                dealer_card_value = dealer_deck[0];
                
                anim_timer = deal_duration;
                state = CardMac2State.DEALING;
            }
        }
        break;

    case CardMac2State.PLAYER_CHOICE:
        var _choice = "";
        var _payout = 0;
        if (check_button_click(button_choice_high, _info_panel_x, _info_panel_y)) { _choice = "High"; _payout = payout_high; }
        if (check_button_click(button_choice_low, _info_panel_x, _info_panel_y)) { _choice = "Low"; _payout = payout_low; }
        if (check_button_click(button_choice_same, _info_panel_x, _info_panel_y)) { _choice = "Same"; _payout = payout_same; }

        if (_choice != "") {
            player_choice_str = _choice;
            chosen_payout_rate = _payout;
            anim_timer = reveal_duration;
            state = CardMac2State.REVEAL;
            audio_play_sound(SE_setresult, 1, false);
        }
        break;

    case CardMac2State.RESULT:
        if (anim_timer > 0) anim_timer -= delta_time / 1000000;
        if (check_button_click(button_play_again, _info_panel_x, _info_panel_y) && anim_timer <= 0) {
            alarm[0] = 1;
            state = CardMac2State.BETTING;
            applied_artifact_this_turn = noone;
        }
        break;

    case CardMac2State.DEALING:
        anim_timer -= delta_time / 1000000;
        if (anim_timer <= 0) {
            var high_outcomes = 0;
            var low_outcomes = 0;
            for(var i = 1; i < array_length(dealer_deck); i++) {
                if (dealer_deck[i] > player_card_value) high_outcomes++;
                if (dealer_deck[i] < player_card_value) low_outcomes++;
            }
            var total_outcomes = array_length(dealer_deck) - 1;

            payout_high = (high_outcomes == 0) ? 0 : floor((total_outcomes / high_outcomes) * 0.9 * 10) / 10;
            payout_low = (low_outcomes == 0) ? 0 : floor((total_outcomes / low_outcomes) * 0.9 * 10) / 10;

            state = CardMac2State.PLAYER_CHOICE;
        }
        break;

    case CardMac2State.REVEAL:
        anim_timer -= delta_time / 1000000;
        if (anim_timer <= 0) {
            // --- 결과 판정 ---
            var actual_result_str = "";
            if (dealer_card_value > player_card_value) actual_result_str = "High";
            else if (dealer_card_value < player_card_value) actual_result_str = "Low";
            else actual_result_str = "Same";
            
            var _is_win = (player_choice_str == actual_result_str);
            var _context = { machine: id, bet: current_bet, win: _is_win, loss: !_is_win, player_card: player_card_value, dealer_card: dealer_card_value };
            var applied = [];

            if (_is_win) {
                result_message = "승리!";
                oGame.Player_money += floor(current_bet * chosen_payout_rate);
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
            anim_timer = result_delay_duration;
            state = CardMac2State.RESULT;
        }
        break;
}