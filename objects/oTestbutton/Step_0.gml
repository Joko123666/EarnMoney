// 마우스의 GUI 좌표를 가져옵니다.
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

// 마우스 클릭 시 대화 출력
if (mouse_check_button_pressed(mb_left) && point_in_rectangle(_mx, _my, x, y, x + w, y + h)) {
    // 현재 상황에 맞는 대화 출력
    var current_situation = situations[current_situation_index];
    show_dialogue(current_situation);
    
    // 다음 상황으로 인덱스 변경 (순환)
    current_situation_index = (current_situation_index + 1) % array_length(situations);
}