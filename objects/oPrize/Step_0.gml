/// @description 보상 목록 생성 및 플레이어 입력 처리

// --- 1. 초기화 로직 (한 번만 실행) ---
if (!initialized) {
    if (prize_type != -1) {
        if (!variable_global_exists("artifact_list")) {
            show_debug_message("ERROR: global.artifact_list가 존재하지 않습니다!");
        } else {
            switch (prize_type) {
                case 1: // N개의 랜덤 도박 기계
                    var _options = [oCoinmac, oCoinmac2, oDicemac, oRCPmac, oCupmac];
                    array_shuffle_ext(_options);
					if (get_player_trait_level("start_choose") > 0)
					{num_of_choices = 3;}
                    // 한글 주석: num_of_choices 변수를 사용하여 지정된 개수만큼, 하지만 선택 가능한 옵션 개수를 넘지 않도록 반복합니다.
                    for (var i = 0; i < min(num_of_choices, array_length(_options)); i++) {
                        var _obj_id = _options[i];
                        var _name = "알 수 없음", _desc = "설명이 없습니다.";
                        switch (_obj_id) {
                            case oCoinmac: _name = "코인 기계"; _desc = "동전을 던져 앞면을 맞추세요."; break;
                            case oCoinmac2: _name = "더블 코인 기계"; _desc = "두 개의 동전, 더 큰 기회!"; break;
                            case oDicemac: _name = "주사위 기계"; _desc = "주사위의 눈을 예측하세요."; break;
                            case oRCPmac: _name = "가위바위보 기계"; _desc = "기계를 상대로 승리하세요."; break;
                            case oCupmac: _name = "컵 기계"; _desc = "공이 숨겨진 컵을 찾으세요."; break;
                        }
                        choices[i] = { is_artifact: false, obj_id: _obj_id, name: _name, desc: _desc, sprite: sempty, image_index: 0, x: 0, y: 0, w: 0, h: 0 };
                    }
                    break;

                case 2: // 5개의 전략적 아티팩트 (irandom 방식)
                case 3: // 4개의 전략적 아티팩트 + 1개의 도박 기계 (irandom 방식)
                    var _player_mac_types = [];
                    for (var i = 0; i < array_length(oGame.mac_slots); i++) {
                        var _slot = oGame.mac_slots[i];
                        if (instance_exists(_slot.instance_id)) {
                            var _type = _slot.instance_id.mac_type;
                            if (!array_contains(_player_mac_types, _type)) {
                                array_push(_player_mac_types, _type);
                            }
                        }
                    }

                    var _filtered_artifacts = [];
                    var _other_artifacts = [];
                    for (var i = 0; i < array_length(global.artifact_list); i++) {
                        var _artifact = global.artifact_list[i];
                        if (variable_struct_exists(_artifact, "artifact_type") && array_contains(_player_mac_types, _artifact.artifact_type)) {
                            array_push(_filtered_artifacts, _artifact);
                        } else {
                            array_push(_other_artifacts, _artifact);
                        }
                    }

                    var _num_artifacts_to_pick = (prize_type == 2) ? 5 : 4;
                    var _final_artifact_pool = [];

                    // 1. 필터링된 목록에서 무작위로 뽑아 채웁니다.
                    while (array_length(_final_artifact_pool) < _num_artifacts_to_pick && array_length(_filtered_artifacts) > 0) {
                        var _rand_idx = irandom(array_length(_filtered_artifacts) - 1);
                        array_push(_final_artifact_pool, _filtered_artifacts[_rand_idx]);
                        array_delete(_filtered_artifacts, _rand_idx, 1);
                    }

                    // 2. 부족한 경우, 다른 목록에서 무작위로 뽑아 채웁니다.
                    while (array_length(_final_artifact_pool) < _num_artifacts_to_pick && array_length(_other_artifacts) > 0) {
                        var _rand_idx = irandom(array_length(_other_artifacts) - 1);
                        array_push(_final_artifact_pool, _other_artifacts[_rand_idx]);
                        array_delete(_other_artifacts, _rand_idx, 1);
                    }

                    // 3. 최종 선택지를 생성합니다.
                    for (var i = 0; i < array_length(_final_artifact_pool); i++) {
                        var _data = _final_artifact_pool[i];
                        choices[i] = { is_artifact: true, artifact_id: _data.name, name: _data.name, desc: _data.description, sprite: sArtifact, image_index: _data.artifact_num, x: 0, y: 0, w: 0, h: 0 };
                    }
                    
                    if (prize_type == 3) {
                        var _mac_options = [oCoinmac, oCoinmac2, oDicemac, oRCPmac, oCupmac];
                        var _mac_obj = _mac_options[irandom(array_length(_mac_options) - 1)];
                        var _name = "알 수 없음", _desc = "설명이 없습니다.";
                        switch (_mac_obj) {
                            case oCoinmac: _name = "코인 기계"; _desc = "동전을 던져 앞면을 맞추세요."; break;
                            case oCoinmac2: _name = "더블 코인 기계"; _desc = "두 개의 동전, 더 큰 기회!"; break;
                            case oDicemac: _name = "주사위 기계"; _desc = "주사위의 눈을 예측하세요."; break;
                            case oRCPmac: _name = "가위바위보 기계"; _desc = "기계를 상대로 승리하세요."; break;
                            case oCupmac: _name = "컵 기계"; _desc = "공이 숨겨진 컵을 찾으세요."; break;
                        }
                        choices[array_length(choices)] = { is_artifact: false, obj_id: _mac_obj, name: _name, desc: _desc, sprite: sempty, image_index: 0, x: 0, y: 0, w: 0, h: 0 };
                    }

                    array_shuffle(choices);
                    break;
            }
			
			// '포기' 옵션 추가
			var _decline_choice = {
			    is_artifact: false,
			    is_decline: true, // 포기 옵션 식별자
			    name: "포기",
			    desc: "아무것도 선택하지 않고 창을 닫습니다.",
			    sprite: sempty, // 적절한 아이콘이 있다면 변경
			    image_index: 0,
			    x: 0, y: 0, w: 0, h: 0
			};
			array_push(choices, _decline_choice);
			
            initialized = true;
        }
    }
}

// --- 2. 입력 처리 로직 ---
if (state != "choosing" || !initialized) exit;

// 한글 주석: oMouse.x, oMouse.y 대신 GUI 레이어 기준의 마우스 좌표를 사용합니다.
// 이렇게 해야 카메라 위치가 변경되어도 UI 클릭이 정확하게 동작합니다.
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

hover_choice = -1;

for (var i = 0; i < array_length(choices); i++) {
    var _choice = choices[i];
    if (point_in_rectangle(_mx, _my, _choice.x, _choice.y, _choice.x + _choice.w, _choice.y + _choice.h)) {
        hover_choice = i;
        break;
    }
}

if (mouse_check_button_pressed(mb_left) && hover_choice != -1) {
    selected_choice = hover_choice;
    state = "selected";
    alarm[0] = room_speed;
}