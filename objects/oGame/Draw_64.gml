/// @description Game Over UI & Effects

if (game_over_state == "show_dead_image") {
    var _cx = display_get_gui_width() / 2;
    var _cy = display_get_gui_height() / 2;
    
    draw_set_alpha(1);
    draw_set_color(c_white);
    // sDead 스프라이트가 있으면 그림, 없으면 대체 텍스트
    if (sprite_exists(asset_get_index("sDead"))) {
        draw_sprite(asset_get_index("sDead"), 0, _cx, _cy);
    } else {
        draw_text(_cx, _cy, "YOU DIED");
    }
}

if (game_over_state == "show_popup") {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    var _cx = _gw / 2;
    var _cy = _gh / 2;
    
    // 1. 반투명 배경
    draw_set_alpha(0.7);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);
    
    // 2. 결과창 박스 (화면 절반 정도 크기)
    var _box_w = _gw * 0.6;
    var _box_h = _gh * 0.7;
    var _box_x1 = _cx - _box_w / 2;
    var _box_y1 = _cy - _box_h / 2;
    var _box_x2 = _cx + _box_w / 2;
    var _box_y2 = _cy + _box_h / 2;
    
    // 박스 배경 (검정색 + 테두리)
    draw_set_color(c_dkgray);
    draw_rectangle(_box_x1, _box_y1, _box_x2, _box_y2, false);
    draw_set_color(c_white);
    draw_rectangle(_box_x1, _box_y1, _box_x2, _box_y2, true);
    
    // 3. 타이틀
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    // 폰트가 있다면 설정 (예: fnt_dialogue_main)
    if (font_exists(asset_get_index("fnt_dialogue_main"))) {
        draw_set_font(asset_get_index("fnt_dialogue_main"));
    }
    draw_text(_cx, _box_y1 + 20, "GAME RESULT");
    
    // 4. 통계 정보 출력
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    var _start_y = _box_y1 + 80;
    var _line_h = 35;
    var _text_x = _box_x1 + 40;
    
    // 시간 포맷팅 (초 -> 분:초)
    var _mins = floor(global.session_play_time / 60);
    var _secs = floor(global.session_play_time % 60);
    var _time_str = string(_mins) + "m " + string(_secs) + "s";
    
    // 보유 아티팩트 목록 문자열 생성
    var _artifacts_str = "";
    // 획득한 아티팩트가 있다면 나열 (여기서는 player_traits 대신 equipped_artifacts 개념이 모호하므로
    // global.artifact_list는 전체 리스트임. 현재 플레이어가 가진 아티팩트 리스트를 따로 관리하지 않는다면
    // 인벤토리 오브젝트나 머신에서 확인해야 하나, oGame레벨에서는 추적이 어려울 수 있음.
    // *주의*: 현재 구조상 플레이어가 '보유한' 아티팩트는 각 머신에 장착되거나 인벤토리에 있음.
    // 여기서는 간단히 '확인된' 갯수나 텍스트로 대체하거나, 추후 구현 필요.
    // 일단은 공란 혹은 "Not Tracked"로 둠. 
    // (사용자 요청: "최종적으로 보유한 아티팩트") -> 인벤토리 오브젝트를 참조해야 함.
    
    if (instance_exists(oInventory_artifact)) {
        var _inv = instance_find(oInventory_artifact, 0);
        var _count = 0;
        // atti_list는 배열이며, -1이 아닌 요소가 실제 아티팩트임
        if (variable_instance_exists(_inv, "atti_list") && is_array(_inv.atti_list)) {
            for (var i = 0; i < array_length(_inv.atti_list); i++) {
                if (_inv.atti_list[i] != -1) {
                    _count++;
                }
            }
        }
        _artifacts_str = string(_count) + " Artifacts";
    } else {
        _artifacts_str = "None";
    }

    draw_text(_text_x, _start_y + _line_h * 0, "Play Time: " + _time_str);
    draw_text(_text_x, _start_y + _line_h * 1, "Total Gambles: " + string(global.total_gambles));
    draw_text(_text_x, _start_y + _line_h * 2, "Wins: " + string(global.total_wins));
    draw_text(_text_x, _start_y + _line_h * 3, "Losses: " + string(global.total_losses));
    draw_text(_text_x, _start_y + _line_h * 4, "Total Earnings: " + string(global.total_earnings));
    draw_text(_text_x, _start_y + _line_h * 5, "Artifacts: " + _artifacts_str);
    draw_text(_text_x, _start_y + _line_h * 6, "Soul Points Gained: " + string(current_stage_index)); // 이번판 획득량

    // 5. 버튼 (Retry, Main Menu)
    var _btn_w = 200;
    var _btn_h = 60;
    var _btn_y = _box_y2 - 100;
    
    // Retry Button
    var _btn_retry = {
        x: _cx - _btn_w - 20,
        y: _btn_y,
        w: _btn_w,
        h: _btn_h,
        label: "RETRY"
    };
    
    // Main Menu Button
    var _btn_main = {
        x: _cx + 20,
        y: _btn_y,
        w: _btn_w,
        h: _btn_h,
        label: "MAIN MENU"
    };
    
    // 버튼 그리기 (기본 sButton 스프라이트 사용 가정)
    var _btn_sprite = asset_get_index("sButton");
    if (!sprite_exists(_btn_sprite)) _btn_sprite = -1; // 스프라이트 없으면 사각형으로 그려짐(draw_custom_button 구현 확인 필요) 
    // *참고*: draw_custom_button은 sprite 인자가 필수이므로 없으면 에러날 수 있음.
    // sButton은 존재한다고 가정 (파일 목록에 있었음).
    
    draw_custom_button(_btn_retry, _btn_sprite);
    draw_custom_button(_btn_main, _btn_sprite);
    
    // 버튼 클릭 처리
    if (check_button_click(_btn_retry, 0, 0)) {
        game_over_state = "none"; 
        start_game_state = false;
        game_restart();
    }
    
    if (check_button_click(_btn_main, 0, 0)) {
        game_over_state = "none"; // 상태 초기화
        start_game_state = false; // 게임 진행 중단
        room_goto(Mainmenu); 
    }
}