/// @description 보상 목록 생성 및 플레이어 입력 처리

// --- 1. 초기화 로직 (한 번만 실행) ---
if (!initialized) {
    if (prize_type != -1) {
        
        // 안전장치: minigames_list가 없거나 비어있으면 파일 로드 또는 기본값 사용
        if (!variable_global_exists("minigames_list") || array_length(global.minigames_list) == 0) {
            
            // 1. 파일에서 로드 시도 (Buffer 방식 권장)
            if (file_exists("minigames.json")) {
                try {
                    var _buff = buffer_load("minigames.json");
                    var _json_str = buffer_read(_buff, buffer_string);
                    buffer_delete(_buff);
                    global.minigames_list = json_parse(_json_str);
                } catch(_e) {
                    show_debug_message("ERROR: minigames.json load failed: " + string(_e));
                }
            }
            
            // 2. 여전히 비어있다면 하드코딩 기본값 사용 (Fallback)
            if (!variable_global_exists("minigames_list") || array_length(global.minigames_list) == 0) {
                show_debug_message("WARNING: Using HARDCODED minigames list.");
                global.minigames_list = [
                    { object_name: oCoinmac, name: "코인 기계", description: "동전을 던져 앞면을 맞추세요." },
                    { object_name: oDicemac, name: "주사위 기계", description: "주사위의 눈을 예측하세요." },
                    { object_name: oRCPmac, name: "가위바위보 기계", description: "기계를 상대로 승리하세요." },
                    { object_name: oCupmac, name: "컵 기계", description: "공이 숨겨진 컵을 찾으세요." },
                    { object_name: oCardmac, name: "카드 기계", description: "카드를 한 장 뽑아 10을 찾으세요." }
                ];
            }
        }
        
        if (!variable_global_exists("artifact_list")) {
            show_debug_message("ERROR: global.artifact_list가 존재하지 않습니다!");
        } else {
            // asset_get_index 실패 대비용 매핑
            var _fallback_map = {
                "oCoinmac": oCoinmac,
                "oDicemac": oDicemac,
                "oRCPmac": oRCPmac,
                "oCupmac": oCupmac,
                "oCardmac": oCardmac,
                "oCoinmac2": oCoinmac2,
                "oCardmac2": oCardmac2,
                "oFingermac": oFingermac,
                "oUpdownmac": oUpdownmac
            };

            switch (prize_type) {
                case 1: // N개의 랜덤 도박 기계
                    // 한글 주석: 이 보상 유형(1)에서 등장할 수 있는 게임들을 직접 지정합니다.
                    var _allowed_games = ["oCoinmac", "oDicemac", "oRCPmac", "oCupmac", "oCardmac"];
                    var _game_data_list = [];
                    
                    if (variable_global_exists("minigames_list")) {
                        show_debug_message("DEBUG: global.minigames_list length: " + string(array_length(global.minigames_list)));
                        for (var k = 0; k < array_length(global.minigames_list); k++) {
                             var _data = global.minigames_list[k];
                             
                             // _allowed_games에 포함되어 있는지 확인
                             var _is_allowed = false;
                             for (var j = 0; j < array_length(_allowed_games); j++) {
                                 if (_allowed_games[j] == _data.object_name) {
                                     _is_allowed = true;
                                     break;
                                 }
                             }
                             
                             show_debug_message("DEBUG: Checking game: " + _data.object_name + " | Allowed: " + string(_is_allowed));

                             if (_is_allowed) {
                                 array_push(_game_data_list, _data);
                             }
                        }
                    } else {
                        show_debug_message("DEBUG: global.minigames_list does NOT exist even after safety check!");
                    }
                    
                    if (array_length(_game_data_list) == 0) {
                        show_debug_message("WARNING: No games found for Prize Type 1. Check global.minigames_list.");
                    }
                    
                    array_shuffle_ext(_game_data_list);
                    
					if (get_player_trait_level("start_choose") > 0)
					{num_of_choices = 3;}
                    // 한글 주석: num_of_choices 변수를 사용하여 지정된 개수만큼, 하지만 선택 가능한 옵션 개수를 넘지 않도록 반복합니다.
                    var _added_count = 0;
                    for (var i = 0; i < array_length(_game_data_list); i++) {
                        if (_added_count >= num_of_choices) break;

                        var _data = _game_data_list[i];
                        
                        var _obj_id = -1;
                        if (is_string(_data.object_name)) {
                            _obj_id = asset_get_index(_data.object_name);
                        } else {
                            _obj_id = _data.object_name;
                        }

                        var _name = _data.name; 
                        var _desc = _data.description;
                        
                        show_debug_message("DEBUG: Adding choice: " + _name + " | Asset Index: " + string(_obj_id));

                        // 인덱스를 못 찾아도 일단 선택지에 추가하여 시각적으로 확인 가능하게 함
                        array_push(choices, { is_artifact: false, obj_id: _obj_id, name: _name, desc: _desc, sprite: sempty, image_index: 0, x: 0, y: 0, w: 0, h: 0 });
                        _added_count++;
                        
                        if (_obj_id == -1) {
                             show_debug_message("WARNING: Object index not found for " + _data.object_name);
                        }
                    }
                    break;
                
                case 4: // 모든 미니게임 중 3개 랜덤 선택
                    var _all_games_list = [];
                    if (variable_global_exists("minigames_list")) {
                        // 모든 게임 복사
                        array_copy(_all_games_list, 0, global.minigames_list, 0, array_length(global.minigames_list));
                    }
                    
                    array_shuffle_ext(_all_games_list);
                    
                    var _count_type4 = 0;
                    // 최대 3개 선택
                    for (var i = 0; i < array_length(_all_games_list); i++) {
                        if (_count_type4 >= 3) break;
                        
                        var _data = _all_games_list[i];
                        var _obj_id = -1;
                        if (is_string(_data.object_name)) {
                            _obj_id = asset_get_index(_data.object_name);
                        } else {
                            _obj_id = _data.object_name;
                        }
                        
                        var _name = _data.name; 
                        var _desc = _data.description;
                        
                        // 인덱스를 못 찾아도 일단 선택지에 추가하여 시각적으로 확인 가능하게 함
                        array_push(choices, { is_artifact: false, obj_id: _obj_id, name: _name, desc: _desc, sprite: sempty, image_index: 0, x: 0, y: 0, w: 0, h: 0 });
                        _count_type4++;
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

                    var _num_artifacts_to_pick = 0;
                    if (prize_type == 2) {
                        _num_artifacts_to_pick = 5;
                    } else { // prize_type == 3
                        _num_artifacts_to_pick = 3;
                        if (get_player_trait_level("stage_artifact") > 0) _num_artifacts_to_pick++;
                    }
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
                        array_push(choices, { is_artifact: true, artifact_id: _data.name, name: _data.name, desc: _data.description, sprite: sArtifact, image_index: _data.artifact_num, x: 0, y: 0, w: 0, h: 0 });
                    }
                    
                    if (prize_type == 3) {
                        var _mac_count = 1;
                        if (get_player_trait_level("stage_game") > 0) _mac_count++;
                        
                        var _game_data_list = [];
                        if (variable_global_exists("minigames_list")) {
                             for (var k = 0; k < array_length(global.minigames_list); k++) {
                                 array_push(_game_data_list, global.minigames_list[k]);
                             }
                        }
                        array_shuffle_ext(_game_data_list);
                        
                        var _game_added_count = 0;
                        for (var m = 0; m < array_length(_game_data_list); m++) {
                            if (_game_added_count >= _mac_count) break;

                            var _data = _game_data_list[m];
                            
                            var _obj_id = -1;
                            if (is_string(_data.object_name)) {
                                _obj_id = asset_get_index(_data.object_name);
                            } else {
                                _obj_id = _data.object_name;
                            }
                            
                            var _name = _data.name; 
                            var _desc = _data.description;
                            
                            // 유효한 오브젝트인 경우에만 선택지에 추가
                            if (_obj_id != -1) {
                                array_push(choices, { is_artifact: false, obj_id: _obj_id, name: _name, desc: _desc, sprite: sempty, image_index: 0, x: 0, y: 0, w: 0, h: 0 });
                                _game_added_count++;
                            } else {
                                 show_debug_message("WARNING: Object index not found for " + string(_data.object_name) + " in Prize Type 3. Skipping.");
                            }
                        }
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