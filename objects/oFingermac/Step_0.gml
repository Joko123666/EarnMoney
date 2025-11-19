/// @description oFingermac - Step Event
event_inherited(); // 부모(oMacs_parent)의 공통 Step 로직 실행

// 정보 패널의 기준 좌표를 계산합니다.
var _info_panel_x = panel_x + panel_w - info_panel_width - 20;
var _info_panel_y = panel_y + 60;

// --- 상태별 로직 처리 ---
switch (state) {
    case FingerMacState.BETTING:
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

                // --- 딜러 손 설정 로직 ---
                hidden_hand_value = irandom(5);
                var coin_flip_is_heads = (irandom(1) == 0);
                if (coin_flip_is_heads) {
                    shown_hand_value = hidden_hand_value;
                } else {
                    do {
                        shown_hand_value = irandom(5);
                    } until (shown_hand_value != hidden_hand_value);
                }
                
                anim_timer = dealer_setup_duration;
                state = FingerMacState.DEALER_SETUP;
            }
        }
        break;

    case FingerMacState.PLAYER_CHOICE:
        for (var i = 0; i < array_length(buttons_player_choice); i++) {
            // 숫자 선택 버튼은 절대 좌표를 사용하므로 base_x, base_y는 0
            if (check_button_click(buttons_player_choice[i], 0, 0)) {
                player_guess = i;
                payout_rate = (player_guess == shown_hand_value) ? payout_rate_2x_default : payout_rate_10x_default;
                
                audio_play_sound(SE_setresult, 1, false);
                anim_timer = reveal_duration;
                state = FingerMacState.REVEAL;
                break;
            }
        }
        break;

    case FingerMacState.RESULT:
        if (anim_timer > 0) {
            anim_timer -= delta_time / 1000000;
        }
        if (check_button_click(button_play_again, _info_panel_x, _info_panel_y) && anim_timer <= 0) {
            alarm[0] = 1;
            state = FingerMacState.BETTING;
            applied_artifact_this_turn = noone;
        }
        break;

    case FingerMacState.DEALER_SETUP:
        anim_timer -= delta_time / 1000000;
        if (anim_timer <= 0) {
            state = FingerMacState.PLAYER_CHOICE;
        }
        break;

    case FingerMacState.REVEAL:
        anim_timer -= delta_time / 1000000;
        if (anim_timer <= 0) {
            var _is_win = (player_guess == hidden_hand_value);
            var _context = { machine: id, bet: current_bet, win: _is_win, loss: !_is_win, hidden_hand: hidden_hand_value, shown_hand: shown_hand_value };
            var applied = [];

            if (_is_win) {
                result_message = "승리!";
                var win_amount = floor(current_bet * payout_rate);
                oGame.Player_money += win_amount;
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
            state = FingerMacState.RESULT;
        }
        break;
}