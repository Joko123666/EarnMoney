/// @description oMacs_parent - Draw Event (Common UI)
draw_self();

// IDLE 상태이거나, 다른 UI가 활성화되어 있으면 아무것도 그리지 않습니다.
if (state == MacState.IDLE || (global.ui_blocking_input && global.active_ui_object != id)) {
    exit;
}

#region Draw UI Panels
// 메인 패널
draw_set_color(c_black);
draw_set_alpha(0.8);
draw_rectangle(panel_x, panel_y, panel_x + panel_w, panel_y + panel_h, false);
draw_set_alpha(1.0);
draw_set_color(c_white);
draw_rectangle(panel_x, panel_y, panel_x + panel_w, panel_y + panel_h, true);

// 게임 화면 영역
var _game_screen_x = panel_x + 20;
var _game_screen_y = panel_y + 60;
var _game_screen_w = panel_w - info_panel_width - 50;
var _game_screen_h = panel_h - 80;
draw_set_color(#1A1A1A);
draw_roundrect_ext(_game_screen_x, _game_screen_y, _game_screen_x + _game_screen_w, _game_screen_y + _game_screen_h, 10, 10, false);
draw_set_color(c_black);
draw_roundrect_ext(_game_screen_x, _game_screen_y, _game_screen_x + _game_screen_w, _game_screen_y + _game_screen_h, 10, 10, true);

// 정보 패널 영역
var _info_panel_x = panel_x + panel_w - info_panel_width - 20;
var _info_panel_y = panel_y + 60;
var _info_panel_h = panel_h - 80;
draw_set_color(#2A2A2A);
draw_roundrect_ext(_info_panel_x, _info_panel_y, _info_panel_x + info_panel_width, _info_panel_y + _info_panel_h, 10, 10, false);
draw_set_color(c_black);
draw_roundrect_ext(_info_panel_x, _info_panel_y, _info_panel_x + info_panel_width, _info_panel_y + _info_panel_h, 10, 10, true);
#endregion

#region Draw Common UI Text
draw_set_color(c_white);
draw_set_font(fnt_dialogue_name);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// 게임 이름
draw_text(panel_x + 20, panel_y + 15, game_name);

// 베팅 정보
draw_set_font(fnt_dialogue_main);
var _info_cx = _info_panel_x + info_panel_width / 2;
draw_set_halign(fa_center);
draw_text(_info_cx, _info_panel_y + 100, "Current Bet");
draw_text(_info_cx, _info_panel_y + 130, string(current_bet));
#endregion

#region Draw Common Buttons
// 베팅 +, - 버튼
if (state == 1) { // BETTING 상태일 때만 그림
    draw_custom_button(button_bet_down, button_bet_down.sprite, _info_panel_x, _info_panel_y);
    draw_custom_button(button_bet_up, button_bet_up.sprite, _info_panel_x, _info_panel_y);
}

// 닫기 버튼 (절대 좌표를 사용하므로 base_x, base_y는 0, 0)
draw_custom_button(button_internal_close, button_internal_close.sprite, 0, 0);
#endregion

#region Draw Equipped Artifacts
var _a_size = 48; // 아이콘 크기
var _a_spacing = 5; // 아이콘 간격
var _items_per_row = 3;
var _total_grid_w = (_a_size * _items_per_row) + (_a_spacing * (_items_per_row - 1));
var _ax_start = _info_panel_x + (info_panel_width - _total_grid_w) / 2;
var _ay_start = _info_panel_y + _info_panel_h - (_a_size * 2 + _a_spacing) - 45; // 하단 정렬

// 제목 그리기
draw_set_font(font_main);
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_text(_info_cx, _ay_start - 5, "적용 중인 아티팩트");

// 아티팩트 아이콘 그리기
for (var i = 0; i < array_length(equipped_artifacts); i++) {
    var _artifact = equipped_artifacts[i];
    if (!is_struct(_artifact)) continue; // 빈 슬롯 건너뛰기

    var _col = i % _items_per_row;
    var _row = floor(i / _items_per_row);
    var _ax = _ax_start + _col * (_a_size + _a_spacing);
    var _ay = _ay_start + _row * (_a_size + _a_spacing);

    // 기본값 설정
    var _is_applied = false;
    var _scale_mod = 1.0;
    
    // 현재 아티팩트에 대한 활성 이펙트가 있는지 확인
    for (var j = 0; j < array_length(artifact_effects); j++) {
        if (artifact_effects[j].name == _artifact.name) {
            _is_applied = true;
            var _effect = artifact_effects[j];
            var _progress = 1 - (_effect.timer / 0.5); // 0(시작) -> 1(끝)
            
            // 사인파를 이용해 부드러운 스케일 변화(움찔 효과) 생성
            _scale_mod = 1 + sin(_progress * pi) * 0.5; // 1.0 -> 1.5 -> 1.0
            break; // 해당 아티팩트에 대한 이펙트를 찾았으므로 중단
        }
    }
    
    // 최종 알파, 색상, 크기 결정
    var _alpha = _is_applied ? 1.0 : 0.5;
    var _color = _is_applied ? c_white : c_gray;
    var _final_scale = (_a_size / sprite_get_width(sArtifact)) * _scale_mod;
    
    // 아이콘 그리기 (중앙 기준 스케일 조정을 위해 좌표 보정)
    var _draw_x = _ax + _a_size / 2;
    var _draw_y = _ay + _a_size / 2;
    draw_sprite_ext(sArtifact, _artifact.artifact_num, _draw_x, _draw_y, _final_scale, _final_scale, 0, _color, _alpha);
}
#endregion

// 그리기 설정 초기화
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);