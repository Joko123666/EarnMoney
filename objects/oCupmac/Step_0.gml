/// @description oCupmac - Step Event
event_inherited(); // 부모(oMacs_parent)의 공통 Step 로직 실행

// 정보 패널의 기준 좌표를 계산합니다.
var _info_panel_x = panel_x + panel_w - info_panel_width - 20;
var _info_panel_y = panel_y + 60;

switch (state) {
    case CupGameState.BETTING:
        if (check_button_click(button_bet_down, _info_panel_x, _info_panel_y)) { current_bet = max(min_bet, current_bet - bet_increment); }
        if (check_button_click(button_bet_up, _info_panel_x, _info_panel_y)) { current_bet = min(max_bet, current_bet + bet_increment); }
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

                state = CupGameState.SETUP;
                animation_timer = setup_duration;
            }
        }
        break;

    case CupGameState.CHOOSING:
        var button_pressed = -1;
        if (check_button_click(button_cup_1, _info_panel_x, _info_panel_y)) button_pressed = 0;
        if (check_button_click(button_cup_2, _info_panel_x, _info_panel_y)) button_pressed = 1;
        if (check_button_click(button_cup_3, _info_panel_x, _info_panel_y)) button_pressed = 2;

        if (button_pressed != -1) {
            audio_play_sound(SE_setresult, 1, false);
            
            var sorted_cups = array_create(cup_count);
            array_copy(sorted_cups, 0, cups, 0, cup_count);
            array_sort(sorted_cups, function(c1, c2) { return c1.x - c2.x; });
            
            player_choice = sorted_cups[button_pressed].id;

            state = CupGameState.REVEAL;
            animation_timer = reveal_duration;
        }
        break;

    case CupGameState.RESULT:
        if (check_button_click(button_play_again, _info_panel_x, _info_panel_y)) {
            state = CupGameState.BETTING;
            player_choice = -1;
            result_message = "";
            init_cups();
            applied_artifact_this_turn = noone;
        }
        break;

    case CupGameState.SETUP:
        if (animation_timer == setup_duration) { audio_play_sound(SE_ballin, 1, false); }
        animation_timer--;
        if (animation_timer <= 0) {
            state = CupGameState.SHUFFLING;
            animation_timer = shuffle_duration;
            alarm[1] = 1;
        }
        break;

    case CupGameState.SHUFFLING:
        for (var i = 0; i < cup_count; i++) {
            var cup = cups[i];
            cup.x = lerp(cup.x, cup.target_x, 0.25);
            cup.y = lerp(cup.y, cup.target_y, 0.25);
        }
        animation_timer--;
        if (animation_timer <= 0) {
            alarm[1] = -1;
            state = CupGameState.CHOOSING;
            result_message = "Choose a cup!";
        }
        break;

    case CupGameState.REVEAL:
        animation_timer--;
        if (animation_timer <= 0) {
            state = CupGameState.RESULT;
            var correct_cup_id = -1;
            for (var i = 0; i < cup_count; i++) {
                if (cups[i].has_ball) { correct_cup_id = cups[i].id; break; }
            }
            
            var _is_win = (player_choice == correct_cup_id);
            var _context = { machine: id, bet: current_bet, win: _is_win, loss: !_is_win };
            var applied = [];

            if (_is_win) {
                audio_play_sound(SE_win, 1, false);
                result_message = "You Win!";
                oGame.Player_money += current_bet * payout_rate;
                applied = apply_artifacts("ON_WIN", _context);
            } else {
                audio_play_sound(SE_lose, 1, false);
                oGame.lose_token++;
                result_message = "You Lose!";
                applied = apply_artifacts("ON_LOSE", _context);
            }

            if (array_length(applied) > 0) {
                applied_artifact_this_turn = applied[0];
                for (var j = 0; j < array_length(applied); j++) {
                    array_push(artifact_effects, { name: applied[j], timer: 0.5 });
                }
            }
        }
        break;
}