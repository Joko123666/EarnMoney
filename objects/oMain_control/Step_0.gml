// 대화 상자 종료 후 보상 처리
if (reward_pending && !instance_exists(oDialogueBox)) {
    oGame.give_prize(1);
    reward_pending = false;
}

/// @description 중단 메뉴 로직 처리

// ESC 키를 눌러 중단 메뉴를 토글합니다.
if (keyboard_check_pressed(vk_escape)) {
    is_paused = !is_paused;

    if (is_paused) {
        // 게임을 중단시킬 때, oMain_control 자신을 제외한 모든 인스턴스를 비활성화합니다.
        instance_deactivate_all(true);
    } else {
        // 게임을 재개할 때, 모든 인스턴스를 다시 활성화합니다.
        instance_activate_all();
    }
}

// 게임이 중단된 상태가 아니면, 이후 로직을 실행할 필요가 없습니다.
if (!is_paused) {
    exit;
}

// --- 아래는 is_paused가 true일 때만 실행됩니다. ---

// GUI 레이어 기준 마우스 좌표 가져오기
var _mouse_x = device_mouse_x_to_gui(0);
var _mouse_y = device_mouse_y_to_gui(0);

// 1. 버튼 위에 마우스가 올라와 있는지 감지
hovered_button = -1; // 매 프레임 초기화
for (var i = 0; i < array_length(buttons); i++) {
    var btn = buttons[i];
    var btn_x = display_get_gui_width() / 2;
    var btn_y = 200 + (i * 80);
    var btn_w = 250;
    var btn_h = 60;

    // 마우스 좌표가 버튼의 사각형 영역 안에 있는지 확인
    if (_mouse_x > btn_x - btn_w / 2 && _mouse_x < btn_x + btn_w / 2 &&
        _mouse_y > btn_y - btn_h / 2 && _mouse_y < btn_y + btn_h / 2) {
        hovered_button = i; // 마우스가 올라간 버튼의 인덱스 저장
        break; // 찾았으면 반복 중단
    }
}

// 2. 버튼 클릭 처리
if (mouse_check_button_pressed(mb_left)) { // 마우스 좌클릭 감지
    if (hovered_button != -1) { // 마우스가 버튼 위에 있을 때
        buttons[hovered_button].action(); // 해당 버튼에 지정된 action 함수 실행

        // 클릭 후, 메뉴가 닫히는 동작(계속하기) 외에는
        // 즉시 게임 상태가 변경되므로, 비활성화된 인스턴스들을 다시 활성화해야 합니다.
        if (buttons[hovered_button].label != "계속하기") {
            instance_activate_all();
        }

		// 중요: 상태 변경 후 즉시 스크립트를 종료하여,
		// 같은 프레임에서 다른 상태의 코드가 실행되는 것을 방지합니다.
		// 예를 들어, "계속하기"를 누르면 is_paused가 false가 되는데,
		// exit가 없으면 이 프레임에 바로 아래의 instance_activate_all이 실행될 수 있습니다.
		if (is_paused == false) {
			instance_activate_all();
		}

        exit;
    }
}
