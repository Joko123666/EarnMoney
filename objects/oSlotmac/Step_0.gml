/// @description oSlotmac - Step Event (Refactored)
event_inherited();

var _info_panel_x = panel_x + panel_w - info_panel_width - 20;
var _info_panel_y = panel_y + 60;

switch (state) {
    case SlotMachineState.BETTING:
        if (check_button_click(button_bet_down, _info_panel_x, _info_panel_y)) current_bet = max(min_bet, current_bet - bet_increment);
        if (check_button_click(button_bet_up, _info_panel_x, _info_panel_y)) current_bet = min(max_bet, current_bet + bet_increment);
        
        if (check_button_click(button_play, _info_panel_x, _info_panel_y)) {
            if (oGame.Player_money >= current_bet) {
                oGame.Player_money -= current_bet;
                audio_play_sound(SE_startgame, 1, false);

                var applied = apply_artifacts("ON_ROUND_START", { machine: id, bet: current_bet });
                if (array_length(applied) > 0) {
                    for (var j = 0; j < array_length(applied); j++) {
                        array_push(artifact_effects, { name: applied[j], timer: 0.5 });
                    }
                }
                
                // 릴 돌리기 시작
                for (var i = 0; i < 3; i++) {
                    reels[i].speed = random_range(30, 50);
                    reels[i].is_stopping = false;
                    // 최종 결과 위치 미리 결정
                    reels[i].final_result_index = irandom(array_length(reels[i].symbols) - 1);
                }
                
                anim_timer = spin_duration;
                state = SlotMachineState.SPINNING;
            }
        }
        break;

    case SlotMachineState.SPINNING:
        anim_timer -= delta_time / 1000000;

        // 릴 돌리기
        for (var i = 0; i < 3; i++) {
            reels[i].position += reels[i].speed;
        }

        // STOP 버튼 또는 시간 초과 시 릴 정지 시작
        var stop_triggered = check_button_click(button_stop, _info_panel_x, _info_panel_y);
        if (stop_triggered || anim_timer <= 0) {
            state = SlotMachineState.RESULT; // 결과 처리 상태로 바로 전환
            anim_timer = 0; // 타이머 초기화
            
            // 모든 릴을 최종 위치로 설정
            for (var i = 0; i < 3; i++) {
                reels[i].speed = 0;
                // 심볼 높이가 64라고 가정
                reels[i].position = reels[i].final_result_index * 64; 
            }
            
            // 결과 판정
            var win_amount = check_slot_winnings();
            var _is_win = (win_amount > 0);
            var _context = { machine: id, bet: current_bet, win: _is_win, loss: !_is_win };
            var applied = [];

            if (_is_win) {
                result_message = "You Win! +" + string(win_amount);
                oGame.Player_money += win_amount;
                audio_play_sound(SE_win, 1, false);
                applied = apply_artifacts("ON_WIN", _context);
            } else {
                result_message = "You Lose...";
                oGame.lose_token++;
                audio_play_sound(SE_lose, 1, false);
                applied = apply_artifacts("ON_LOSE", _context);
            }
            
            if (array_length(applied) > 0) {
                for (var j = 0; j < array_length(applied); j++) {
                    array_push(artifact_effects, { name: applied[j], timer: 0.5 });
                }
            }
            oGame.chance_last -= 1;
        }
        break;

    case SlotMachineState.RESULT:
        if (check_button_click(button_play_again, _info_panel_x, _info_panel_y)) {
            state = SlotMachineState.BETTING;
            result_message = "";
            applied_artifact_this_turn = noone;
            initialize_reels();
        }
        break;
}