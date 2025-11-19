/// @description 항복 버튼 클릭 이벤트

// 마우스가 버튼 영역 안에 있는지 확인
if (mouse_check_button_pressed(mb_left)) {
    if (point_in_rectangle(mouse_x, mouse_y, bbox_left, bbox_top, bbox_right, bbox_bottom)) {
        // oGame이 존재하는지 확인
        if (instance_exists(oGame)) {
            // oGame의 게임 오버 상태를 트리거
            oGame.game_over_state = "dialogue";
            oGame.show_dialogue("fail"); // "fail" 대화 상자 출력
        }
        
        // 현재 버튼 인스턴스 파괴 (한 번만 작동하도록)
        instance_destroy();
    }
}
