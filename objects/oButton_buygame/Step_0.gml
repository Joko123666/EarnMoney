/// @description Handle Input & Logic

// UI 블로킹 관리
if (state == "confirm") {
    global.ui_blocking_input = true;
    global.active_ui_object = id;
} else {
    // 내가 블로킹 중이었는데 idle로 돌아왔다면 해제
    if (global.active_ui_object == id) {
        global.ui_blocking_input = false;
        global.active_ui_object = noone;
    }
}

// 쿨타임 감소
if (interact_cooldown > 0) interact_cooldown -= delta_time / 1000000;

// 다른 UI가 활성화되어 있고 내가 아니라면 입력 무시
if (global.ui_blocking_input && global.active_ui_object != id) exit;

if (state == "idle") {
    // 버튼 클릭 감지 (룸 좌표 기준)
    if (mouse_check_button_pressed(mb_left) && interact_cooldown <= 0) {
        if (point_in_rectangle(mouse_x, mouse_y, bbox_left, bbox_top, bbox_right, bbox_bottom)) {
            if (oGame.lose_token >= cost) {
                // 구매 가능: 확인 팝업 띄우기
                state = "confirm";
                interact_cooldown = 0.2; // 팝업 즉시 클릭 방지
                audio_play_sound(SE_coinin, 1, false); // 효과음 (임시)
            } else {
                // 토큰 부족: 피드백 (로그 또는 사운드)
                audio_play_sound(SE_lose, 1, false); // 실패음
                show_debug_message("토큰이 부족합니다!");
            }
        }
    }
} 
else if (state == "confirm") {
    // 팝업 입력 감지 (GUI 좌표 기준)
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    
    var _px = (_gui_w - popup_w) / 2;
    var _py = (_gui_h - popup_h) / 2;
    
    // 버튼 위치 계산 (Draw_64와 일치시켜야 함)
    var _btn_y = _py + popup_h - 80;
    var _yes_x = _px + 50;
    var _no_x = _px + popup_w - 50 - button_no.w;
    
    if (mouse_check_button_pressed(mb_left) && interact_cooldown <= 0) {
        // Yes 버튼
        if (_mx >= _yes_x && _mx <= _yes_x + button_yes.w && _my >= _btn_y && _my <= _btn_y + button_yes.h) {
            // 구매 실행
            if (oGame.lose_token >= cost) {
                oGame.lose_token -= cost;
                with (oGame) {
                    give_prize(4); // Prize Type 4: 랜덤 미니게임 3개 중 택 1
                }
                audio_play_sound(SE_win, 1, false); // 성공음
            }
            state = "idle";
            interact_cooldown = 0.2;
        }
        
        // No 버튼
        if (_mx >= _no_x && _mx <= _no_x + button_no.w && _my >= _btn_y && _my <= _btn_y + button_no.h) {
            // 취소
            state = "idle";
            interact_cooldown = 0.2;
        }
    }
}