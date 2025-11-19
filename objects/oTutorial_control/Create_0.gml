/// @description 튜토리얼 시스템 초기화

// 한글 주석: 튜토리얼 시스템의 주요 변수들을 초기화합니다.
is_active = true; // 튜토리얼 활성화 여부
current_step = -1; // 현재 진행중인 튜토리얼 단계
tutorial_data = -1; // 튜토리얼 데이터(JSON)를 저장할 변수
is_waiting_for_trigger = false; // 플레이어의 특정 행동(트리거)을 기다리는지 여부
active_trigger_id = ""; // 활성화된 트리거의 ID
dialogue_instance = noone; // 생성된 대화 상자 인스턴스를 저장

// 한글 주석: 연출 효과에 사용될 변수들
effect_alpha = 0; // 화면 암転 효과 등을 위한 알파값
effect_target_alpha = 0; // 목표 알파값
highlight_mode = "none"; // "left", "right", "none" 등 화면 강조 모드

// 한글 주석: JSON 파일을 읽어 튜토리얼 데이터를 불러옵니다.
var _path = "tutorial_data.json";
if (file_exists(_path)) {
    var _file = file_text_open_read(_path);
    var _json_string = "";
    while (!file_text_eof(_file)) {
        _json_string += file_text_readln(_file);
    }
    file_text_close(_file);
    tutorial_data = json_parse(_json_string);
	
	// 한글 주석: json_parse는 이제 struct를 반환합니다. "steps" 키가 있는지 확인합니다.
	if (variable_struct_exists(tutorial_data, "steps")) {
		tutorial_data = tutorial_data.steps;
	} else {
		show_debug_message("JSON 데이터에 'steps' 키가 없습니다.");
		is_active = false;
	}
	
} else {
    show_debug_message("튜토리얼 파일을 찾을 수 없습니다: " + _path);
    is_active = false;
}

// 한글 주석: 튜토리얼의 첫 단계를 시작합니다.
if (is_active) {
    advance_tutorial();
}

/// @func find_step_by_id(id)
/// @param {string} id - 찾고자 하는 스텝의 ID
/// @return {real} - 해당 ID를 가진 스텝의 인덱스, 없으면 -1
function find_step_by_id(_id) {
	// 한글 주석: 주어진 ID를 가진 튜토리얼 스텝의 인덱스를 찾습니다.
    if (is_array(tutorial_data)) {
        for (var i = 0; i < array_length(tutorial_data); i++) {
            var _step = tutorial_data[i];
            if (is_struct(_step) && variable_struct_exists(_step, "id") && _step.id == _id) {
                return i;
            }
        }
    }
    return -1; // 한글 주석: ID를 찾지 못한 경우 -1을 반환합니다.
}

/// @func advance_tutorial()
// 한글 주석: 튜토리얼을 다음 단계로 진행시키는 함수입니다.
function advance_tutorial() {
    current_step++;
    if (is_active && current_step < array_length(tutorial_data)) {
        process_tutorial_step();
    } else {
        is_active = false; // 한글 주석: 모든 튜토리얼 단계가 완료되면 비활성화합니다.
        show_debug_message("튜토리얼이 종료되었습니다.");
    }
}

/// @func process_tutorial_step()
// 한글 주석: 현재 튜토리얼 단계에 따라 적절한 행동을 처리합니다.
function process_tutorial_step() {
    if (!is_active || current_step >= array_length(tutorial_data)) {
        return;
    }

    var _step = tutorial_data[current_step];
    var _type = _step.type;

    show_debug_message("Processing Tutorial Step: " + string(current_step) + ", Type: " + _type);

    switch (_type) {
        case "dialogue":
			// 한글 주석: 대화 타입일 경우, oDialogueBox 인스턴스를 생성하여 대사를 표시합니다. (복원된 방식)
            if (!instance_exists(oDialogueBox)) {
                dialogue_instance = instance_create_layer(x, y, "Instances", oDialogueBox);
				
				var _speaker = _step.speaker;
				var _text = _step.text;
				var _sprite_state = variable_struct_exists(_step, "sprite") ? _step.sprite : "default";
				
                // 복원된 oDialogueBox의 변수에 직접 값을 할당합니다.
				dialogue_instance.demon_name = _speaker;
				dialogue_instance.dialogue_text = _text;
				dialogue_instance.portrait_sprite = scr_portrait_manager(_speaker, _sprite_state);
            }
            break;

        case "effect":
			// 한글 주석: 연출 타입일 경우, 해당 연출을 실행합니다.
            switch (_step.name) {
                case "fade_in": effect_target_alpha = 0.85; break; // 한글 주석: 화면을 어둡게 하되, 텍스트는 보이도록 0.85로 설정합니다.
                case "screen_shake": with(oGame) { event_user(0); } break; // oGame에서 화면 흔들림 처리
                case "eye_open": 
					with(oGame) { event_user(1); } // oGame에서 눈 뜨는 연출 처리
					effect_target_alpha = 0; // 한글 주석: 눈을 뜨는 연출과 함께 화면을 다시 밝게 합니다.
					break; 
                case "show_demon_portrait":
					// 여기에 악마 초상화 표시 로직 추가
					break;
                case "focus_on_monitor":
					// 여기에 모니터 초점 연출 로직 추가
					break;
                case "highlight_left_screen": highlight_mode = "left"; break;
                case "highlight_right_screen": highlight_mode = "right"; break;
                case "clear_highlights": highlight_mode = "none"; break;
            }
            advance_tutorial(); // 한글 주석: 연출 실행 후 바로 다음 단계로 넘어갑니다.
            break;

        case "action":
			// 한글 주석: 특정 액션 타입일 경우, 해당 액션을 수행합니다.
            switch (_step.name) {
                case "create_coinmac_button": instance_create_layer(room_width/2, 1152, "Instances", oCoinmac_tutorial); break;
                case "give_player_money": oGame.Player_money += 10; break;
                case "enable_player_input": oGame.player_can_control = true; break;
                case "give_soul_points": global.Soulpoint += 10; break;
                case "go_to_main_menu": room_goto(Mainmenu); break;
            }
            advance_tutorial(); // 한글 주석: 액션 실행 후 바로 다음 단계로 넘어갑니다.
            break;

        case "trigger":
			// 한글 주석: 트리거 타입일 경우, 플레이어의 입력을 기다리는 상태로 전환합니다.
            is_waiting_for_trigger = true;
            active_trigger_id = _step.id;
            show_debug_message("Waiting for trigger: " + active_trigger_id);
            break;
    }
}
