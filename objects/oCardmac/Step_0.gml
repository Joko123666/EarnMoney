/// @description oCardmac - Step Event
event_inherited(); // 부모(oMacs_parent)의 공통 Step 로직 실행

// 정보 패널의 기준 좌표를 계산합니다.
var _info_panel_x = panel_x + panel_w - info_panel_width - 20;
var _info_panel_y = panel_y + 60;

switch (state) {
    case CardMacState.BETTING:
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

                // --- 덱 생성 및 섞기 ---
                deck = [];
                for (var i = 1; i <= 10; i++) { array_push(deck, i); }
                for (var i = array_length(deck) - 1; i > 0; i--) {
                    var j = irandom(i);
                    var _temp = deck[i];
                    deck[i] = deck[j];
                    deck[j] = _temp;
                }
                
                anim_timer = shuffle_duration;
                state = CardMacState.SHUFFLING;
            }
        }
        break;

    case CardMacState.DRAWING:
        if (mouse_check_button_pressed(mb_left) && 
            point_in_rectangle(mouse_x, mouse_y, area_deck.x, area_deck.y, area_deck.x + area_deck.w, area_deck.y + area_deck.h)) {
            
            drawn_card_value = deck[0];
            
            card_anim_progress = 0;
            card_start_x = area_deck.x + area_deck.w/2;
            card_start_y = area_deck.y + area_deck.h/2;
            card_target_x = panel_x + 20 + (panel_w - info_panel_width - 50) / 2;
            card_target_y = panel_y + 60 + (panel_h - 80) / 2;
            
            // --- Card_glass (유리 카드) 효과: 10% 확률로 카드 확인 ---
            peek_card = false;
            if (check_artifact("Card_glass") && random(1) < 0.1) {
                peek_card = true;
                // 메시지나 시각적 효과 추가 가능
            }
            
            anim_timer = reveal_duration;
            state = CardMacState.REVEAL;
            audio_play_sound(SE_draw, 1, false);
        }
        break;

    case CardMacState.RESULT:
        if (anim_timer > 0) {
            anim_timer -= delta_time / 1000000;
        }
        if (check_button_click(button_play_again, _info_panel_x, _info_panel_y) && anim_timer <= 0) {
            alarm[0] = 1;
            state = CardMacState.BETTING;
            applied_artifact_this_turn = noone;
        }
        break;

    case CardMacState.SHUFFLING:
        anim_timer -= delta_time / 1000000;
        if (anim_timer <= 0) {
            state = CardMacState.DRAWING;
        }
        break;

    case CardMacState.REVEAL:
        if (anim_timer > 0) {
            anim_timer -= delta_time / 1000000;
            card_anim_progress = 1 - (anim_timer / reveal_duration);
        } else {
            var _is_win = (drawn_card_value == 10);
            var _is_ace = (drawn_card_value == 1);
            var _context = { machine: id, bet: current_bet, win: _is_win, loss: !_is_win && !_is_ace, card: drawn_card_value };
            var applied = [];

            // --- Card_punch (천공 카드) 기록 업데이트 ---
            // 승리(10)는 true, 패배는 false, 에이스(무승부)는 기록하지 않음(혹은 패배로 칠지 기획 확인 필요. 여기선 기록 안함)
            if (_is_win) {
                array_push(match_history, true);
            } else if (!_is_ace) {
                array_push(match_history, false);
            }
            // 히스토리가 너무 길어지지 않게 관리 (선택 사항, 여기선 20개 유지)
            if (array_length(match_history) > 20) array_delete(match_history, 0, 1);


            if (_is_win) {
                result_message = "승리! 10배 획득!";
                oGame.Player_money += floor(current_bet * payout_rate);
                register_result(true);
                audio_play_sound(SE_win, 1, false);
                applied = apply_artifacts("ON_WIN", _context);
            } else if (check_artifact("Card_ace") && _is_ace) {
                result_message = "에이스! 판돈을 돌려받습니다.";
                oGame.Player_money += current_bet;
                audio_play_sound(SE_win, 1, false);
                // 에이스는 특별 케이스로 ON_WIN/ON_LOSE가 아님
            } else {
                result_message = "패배...";
                oGame.lose_token++;
                register_result(false);
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
            state = CardMacState.RESULT;
        }
        break;
}