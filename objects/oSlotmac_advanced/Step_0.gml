/// @description oSlotmac - Step Event

// UI가 활성화되어 있고, 현재 오브젝트가 활성화된 UI 오브젝트가 아니라면 클릭 처리하지 않음
if (global.ui_blocking_input && global.active_ui_object != id) exit;

// Only handle clicks if the mouse button is pressed
if (mouse_check_button_pressed(mb_left)) {
    switch (adv_state) {
        case AdvSlotMachineState.IDLE:
            // Click on the oSlotmac object itself to open the UI
            if (point_in_rectangle(mouse_x, mouse_y, x, y, x + sprite_width, y + sprite_height)) {
                // UI 패널 중앙 정렬 계산
                adv_ui_panel_x = (display_get_gui_width() / 2) - (adv_ui_panel_width / 2);
                adv_ui_panel_y = (display_get_gui_height() / 2) - (adv_ui_panel_height / 2);

                // 버튼들의 절대 좌표 업데이트
                adv_button_bet_down.x = adv_ui_panel_x + adv_button_bet_down.rel_x;
                adv_button_bet_down.y = adv_ui_panel_y + adv_button_bet_down.rel_y;
                adv_button_bet_up.x = adv_ui_panel_x + adv_button_bet_up.rel_x;
                adv_button_bet_up.y = adv_ui_panel_y + adv_button_bet_up.rel_y;
                adv_button_play.x = adv_ui_panel_x + adv_button_play.rel_x;
                adv_button_play.y = adv_ui_panel_y + adv_button_play.rel_y;
                adv_button_play_again.x = adv_ui_panel_x + adv_button_play_again.rel_x;
                adv_button_play_again.y = adv_ui_panel_y + adv_button_play_again.rel_y;
                adv_button_stop.x = adv_ui_panel_x + adv_button_stop.rel_x;
                adv_button_stop.y = adv_ui_panel_y + adv_button_stop.rel_y;
                adv_button_internal_close.x = adv_ui_panel_x + adv_button_internal_close.rel_x;
                adv_button_internal_close.y = adv_ui_panel_y + adv_button_internal_close.rel_y;

                adv_state = SlotMachineState.BETTING;
                global.ui_blocking_input = true;
                global.active_ui_object = id;
            }
            break;

        case AdvSlotMachineState.BETTING:
        case AdvSlotMachineState.RESULT:
            // UI 외부 클릭 시 닫기
            if (!point_in_rectangle(mouse_x, mouse_y, adv_ui_panel_x, adv_ui_panel_y, adv_ui_panel_x + adv_ui_panel_width, adv_ui_panel_y + adv_ui_panel_height)) {
                adv_state = SlotMachineState.BETTING;
                global.ui_blocking_input = false;
                global.active_ui_object = noone;
                break; // Exit switch after handling external click
            }

            if (check_button_click(adv_button_bet_down)) {
                adv_current_bet = max(adv_min_bet, adv_current_bet - adv_bet_increment);
            }
            if (check_button_click(adv_button_bet_up)) {
                adv_current_bet = min(adv_max_bet, adv_current_bet + adv_bet_increment);
            }

            // 플레이/다시하기 버튼
            if (check_button_click(adv_button_play) || check_button_click(adv_button_play_again)) {
                if (oGame.Player_money >= adv_current_bet) {
                    oGame.Player_money -= adv_current_bet;
                    adv_state = SlotMachineState.SPINNING;
                    adv_is_spinning = true;
                    adv_spin_timer = adv_spin_animation_time;
                    adv_result_message = "";
                    adv_reels_stopped_count = 0;
                } else {
                    show_message("돈이 부족합니다! 현재 판돈: " + string(adv_current_bet) + ", 보유 금액: " + string(oGame.Player_money));
                }
            }

            // 닫기 버튼
            if (check_button_click(adv_button_internal_close)) {
                adv_state = SlotMachineState.IDLE;
                global.ui_blocking_input = false;
                global.active_ui_object = noone;
            }
            break;

        case AdvSlotMachineState.SPINNING:
            // Stop 버튼 클릭 시 다음 릴 정지 상태로 전환
            if (check_button_click(adv_button_stop)) {
                adv_state = SlotMachineState.STOPPING_REELS;
                adv_is_spinning = false;
                adv_reels_stopped_count = 0; // 첫 릴부터 다시 정지 시작
                // 첫 번째 릴 정지
                for (var row = 0; row < 3; row++) {
                    adv_reel_results[adv_reels_stopped_count][row] = irandom_range(0, array_length(adv_symbol_payouts) - 1);
                }
                adv_reels_stopped_count++;
            }
            break;

        case AdvSlotMachineState.STOPPING_REELS:
            // Stop 버튼 클릭 시 다음 릴 정지
            if (check_button_click(adv_button_stop)) {
                if (adv_reels_stopped_count < 3) { // 아직 멈출 릴이 남아있다면
                    // 현재 멈출 열의 심볼 결정
                    for (var row = 0; row < 3; row++) {
                        adv_reel_results[adv_reels_stopped_count][row] = irandom_range(0, array_length(adv_symbol_payouts) - 1);
                    }
                    adv_reels_stopped_count++;
                }

                if (adv_reels_stopped_count == 3) { // 모든 릴이 멈췄다면
                    var total_win_amount = adv_check_winnings();
                    if (total_win_amount > 0) {
                        oGame.Player_money += total_win_amount;
                        adv_result_message = "축하합니다! " + string(total_win_amount) + " 코인을 획득했습니다!";
                    } else {
                        adv_result_message = "아쉽네요. 다음 기회에!";
                    }
                    adv_state = SlotMachineState.RESULT;
                }
            }
            break;
    }
}

/// @function adv_check_winnings()
/// @description 3x3 그리드에서 승리 조건을 확인하고 총 배당금을 반환합니다.
function adv_check_winnings() {
    var total_win = 0;
    var _payout_multiplier = 0;

    // 1. 가로줄 확인
    for (var row = 0; row < 3; row++) {
        if (adv_reel_results[0][row] == adv_reel_results[1][row] && adv_reel_results[1][row] == adv_reel_results[2][row]) {
            _payout_multiplier = adv_get_symbol_payout(adv_reel_results[0][row]);
            total_win += adv_current_bet * _payout_multiplier;
        }
    }

    // 2. 세로줄 확인
    for (var col = 0; col < 3; col++) {
        if (adv_reel_results[col][0] == adv_reel_results[col][1] && adv_reel_results[col][1] == adv_reel_results[col][2]) {
            _payout_multiplier = adv_get_symbol_payout(adv_reel_results[col][0]);
            total_win += adv_current_bet * _payout_multiplier;
        }
    }

    // 3. 대각선 확인 (왼쪽 위 -> 오른쪽 아래)
    if (adv_reel_results[0][0] == adv_reel_results[1][1] && adv_reel_results[1][1] == adv_reel_results[2][2]) {
        _payout_multiplier = adv_get_symbol_payout(adv_reel_results[0][0]);
        total_win += adv_current_bet * _payout_multiplier;
    }

    // 4. 대각선 확인 (오른쪽 위 -> 왼쪽 아래)
    if (adv_reel_results[2][0] == adv_reel_results[1][1] && adv_reel_results[1][1] == adv_reel_results[0][2]) {
        _payout_multiplier = adv_get_symbol_payout(adv_reel_results[2][0]);
        total_win += adv_current_bet * _payout_multiplier;
    }

    return total_win;
}
