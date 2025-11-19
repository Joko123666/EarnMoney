/// @description oSlotmac - Draw GUI Event

#region Test vision
// 클릭 가능 영역 시각화 (디버그용)
draw_set_alpha(0.5); // 반투명 설정
draw_set_color(c_red);

if (state == SlotMachineState.IDLE) {
    // 오브젝트 자체의 클릭 범위
    draw_rectangle(x, y, x + sprite_width, y + sprite_height, true);
} else {
    // UI 패널 내부 버튼들의 클릭 범위
    var buttons = [button_bet_down, button_bet_up, button_play, button_play_again, button_stop, button_internal_close];
    for (var i = 0; i < array_length(buttons); i++) {
        var btn = buttons[i];
        draw_rectangle(btn.x, btn.y, btn.x + btn.w, btn.y + btn.h, true);
    }
}

draw_set_alpha(1); // 알파값 복원
#endregion

// UI 표시 상태일 때만 그리기 (IDLE 상태가 아닐 때)
if (state != SlotMachineState.IDLE) {
    // GUI 그리기 설정
    draw_set_font(font_main);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);

    // UI 패널 배경 그리기 (sBox 사용)
    draw_sprite_stretched(sBox, 0, ui_panel_x, ui_panel_y, ui_panel_width, ui_panel_height);

    // 판돈 표시
    draw_text(ui_panel_x + 20, ui_panel_y + 20, "판돈: " + string(current_bet));

    // 판돈 조절 버튼
    draw_custom_button(button_bet_down, sButton, 0); 
    draw_custom_button(button_bet_up, sButton, 0);   

    // 내부 닫기 버튼 (sIcon 사용)
    draw_custom_button(button_internal_close, sIcon, 1);

    // 릴 굴림 박스 그리기 (3x3 그리드에 맞게 조정)
    var reel_box_x = ui_panel_x + 20;
    var reel_box_y = ui_panel_y + 100;
    var reel_box_w = ui_panel_width - 40 - payout_table_panel.w; // 배율표 공간만큼 줄임
    var reel_box_h = 200; // 3x3에 맞게 높이 조정
    draw_sprite_stretched(sBox, 0, reel_box_x, reel_box_y, reel_box_w, reel_box_h);

    // 3x3 릴 그리기
    var symbol_size = 64; // 심볼 하나의 크기 (sSymbol 스프라이트의 프레임 크기)
    var symbol_gap = 5; // 심볼 간 간격
    var start_x = reel_box_x + (reel_box_w / 2) - (symbol_size * 1.5 + symbol_gap); // 중앙 정렬
    var start_y = reel_box_y + (reel_box_h / 2) - (symbol_size * 1.5 + symbol_gap); // 중앙 정렬

    for (var col = 0; col < 3; col++) {
        for (var row = 0; row < 3; row++) {
            var draw_x = start_x + col * (symbol_size + symbol_gap);
            var draw_y = start_y + row * (symbol_size + symbol_gap);
            
            var symbol_to_draw = 0;
            if (state == SlotMachineState.SPINNING) {
                // 굴리는 중에는 랜덤한 심볼 표시
                symbol_to_draw = irandom_range(0, array_length(symbol_payouts) - 1);
            } else if (state == SlotMachineState.STOPPING_REELS) {
                // 멈추는 중: 멈춘 릴은 결과 심볼, 안 멈춘 릴은 랜덤 심볼
                if (col < reels_stopped_count) {
                    symbol_to_draw = reel_results[col][row];
                } else {
                    symbol_to_draw = irandom_range(0, array_length(symbol_payouts) - 1);
                }
            } else { // RESULT 상태
                symbol_to_draw = reel_results[col][row];
            }
            draw_sprite(sSymbol, symbol_to_draw, draw_x + symbol_size / 2, draw_y + symbol_size / 2);
        }
    }

    // 결과 메시지 표시
    if (state == SlotMachineState.RESULT) {
        draw_set_halign(fa_center);
        draw_text(ui_panel_x + ui_panel_width / 2 - payout_table_panel.w / 2, ui_panel_y + ui_panel_height - 50, result_message); // 배율표 때문에 위치 조정
        draw_set_halign(fa_left);
    }

    // UI 패널 내부에 플레이/정지 버튼 그리기
    if (state == SlotMachineState.BETTING) {
        draw_custom_button(button_play, sButton, 0);
    } else if (state == SlotMachineState.SPINNING || state == SlotMachineState.STOPPING_REELS) {
        draw_custom_button(button_stop, sButton, 0);
    } else if (state == SlotMachineState.RESULT) {
        draw_custom_button(button_play_again, sButton, 0);
    }

    // ----------------- 배율 표 패널 그리기 -----------------
    var payout_panel_abs_x = ui_panel_x + payout_table_panel.rel_x;
    var payout_panel_abs_y = ui_panel_y + payout_table_panel.rel_y;

    draw_sprite_stretched(sBox, 0, payout_panel_abs_x, payout_panel_abs_y, payout_table_panel.w, payout_table_panel.h);

    draw_set_halign(fa_center);
    draw_text(payout_panel_abs_x + payout_table_panel.w / 2, payout_panel_abs_y + 10, "배율 표");

    var current_y_offset = payout_panel_abs_y + 40;
    var line_height = 40; // 각 항목의 높이

    for (var i = 0; i < array_length(symbol_payouts); i++) {
        var symbol_data = symbol_payouts[i];
        
        // 심볼 이미지 그리기
        draw_sprite(sSymbol, symbol_data.symbol_index, payout_panel_abs_x + 30, current_y_offset + symbol_size / 2 - 10); // 심볼 위치 조정
        
        // 심볼 이름과 배율 텍스트 그리기
        draw_set_halign(fa_left);
        draw_text(payout_panel_abs_x + 70, current_y_offset, symbol_data.name + ": x" + string(symbol_data.payout_multiplier));
        
        current_y_offset += line_height;
    }
}