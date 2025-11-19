/// @description 메인 메뉴를 그리고 입력을 처리합니다.

// 공통 그리기 속성 설정
draw_set_font(fnt_dialogue_main); // 폰트 설정
draw_set_halign(fa_center);       // 수평 정렬 (중앙)
draw_set_valign(fa_middle);       // 수직 정렬 (중앙)

// GUI 레이어 기준 마우스 좌표 가져오기
var _mouse_x = device_mouse_x_to_gui(0);
var _mouse_y = device_mouse_y_to_gui(0);

// --- 메뉴 상태에 따라 다른 UI를 그리기 위한 상태 기계 ---
if (menu_state == "main") {
    // =========================
    // === 메인 메뉴 상태 ===
    // =========================

    // 1. 버튼 위에 마우스가 올라와 있는지 감지
    hovered_button = -1; // 매 프레임 초기화
    for (var i = 0; i < array_length(buttons); i++) {
        var btn = buttons[i];
        // 마우스 좌표가 버튼의 사각형 영역 안에 있는지 확인
        if (_mouse_x > btn.x - btn.width / 2 && _mouse_x < btn.x + btn.width / 2 &&
            _mouse_y > btn.y - btn.height / 2 && _mouse_y < btn.y + btn.height / 2) {
            hovered_button = i; // 마우스가 올라간 버튼의 인덱스 저장
            break; // 찾았으면 반복 중단
        }
    }

    // 2. 버튼 클릭 처리
    if (mouse_check_button_pressed(mb_left)) { // 마우스 좌클릭 감지
        if (hovered_button != -1) { // 마우스가 버튼 위에 있을 때
            buttons[hovered_button].action(); // 해당 버튼에 지정된 action 함수 실행
			
			// 중요: 상태 변경 후 즉시 스크립트를 종료하여, 
			// 같은 프레임에서 다른 상태의 코드가 실행되는 것을 방지합니다.
			exit;
        }
    }

    // 3. 버튼 그리기
    for (var i = 0; i < array_length(buttons); i++) {
        var btn = buttons[i];
        // 마우스가 위에 있으면 노란색, 아니면 흰색으로 색상 설정
        var color = (i == hovered_button) ? c_yellow : c_white;
        
        // 버튼 배경 그리기 (반투명 검은 사각형)
        draw_set_color(c_black);
        draw_set_alpha(0.5);
        draw_rectangle(btn.x - btn.width / 2, btn.y - btn.height / 2, btn.x + btn.width / 2, btn.y + btn.height / 2, false);
        draw_set_alpha(1.0);

        // 버튼 텍스트(label) 그리기
        draw_set_color(color);
        draw_text(btn.x, btn.y, btn.label);
    }
    
    // 4. 보유 특성 아이콘을 오른쪽에 표시 (단순히 보여주는 역할)
    if (instance_exists(oTraits_manager) && array_length(global.player_traits) > 0) {
        var _start_x = room_width - 40;
        var _start_y = 50;
        var _spacing = 48;
        draw_set_halign(fa_left);
        draw_set_color(c_white);
        draw_text(_start_x - 100, _start_y - 25, "보유 특성");

        for (var i = 0; i < array_length(global.player_traits); i++) {
            var _trait_id = global.player_traits[i];
            var _trait_data = global.traits_data[? _trait_id];
            if (!is_undefined(_trait_data)) {
                var _sprite = _trait_data.sprite;
                var _x = _start_x;
                var _y = _start_y + (i * _spacing);
                draw_sprite(_sprite, 0, _x, _y);
            }
        }
    }
}


