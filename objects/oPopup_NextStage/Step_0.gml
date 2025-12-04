/// @description Handle Input

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

// 버튼 클릭 체크
if (mouse_check_button_pressed(mb_left)) {
    if (point_in_rectangle(_mx, _my, button_start.x, button_start.y, button_start.x + button_start.w, button_start.y + button_start.h)) {
        
        // 버튼 클릭 효과음 (있다면)
        // audio_play_sound(SE_click, 1, false);

        // oGame에 신호 전달
        with (oGame) {
            // 다음 스테이지 시작 확인 상태로 변경
            next_stage_confirmed = true; 
        }
        
        // 팝업 닫기
        instance_destroy();
    }
}