/// @description Handle Input

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

// 버튼 라벨 업데이트 (Create에서 설정되지만 안전을 위해)
if (is_success) {
    button_confirm.label = "다음 라운드로";
} else {
    button_confirm.label = "게임 오버";
}

// 버튼 클릭 체크
if (mouse_check_button_pressed(mb_left)) {
    if (point_in_rectangle(_mx, _my, button_confirm.x, button_confirm.y, button_confirm.x + button_confirm.w, button_confirm.y + button_confirm.h)) {
        
        // 버튼 클릭 효과음 (있다면)
        // audio_play_sound(SE_click, 1, false);

        // oGame에 신호 전달
        with (oGame) {
            // 라운드 결과 팝업 확인 완료 상태로 변경
            // 이 상태가 되면 oGame은 악마의 대사를 출력하기 시작함
            round_result_confirmed = true; 
        }
        
        // 팝업 닫기
        instance_destroy();
    }
}