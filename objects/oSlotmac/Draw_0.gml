/// @description oSlotmac - Draw Event (Refactored)
event_inherited();
if (state == SlotMachineState.IDLE) exit;

// --- 그리기 설정 ---
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fnt_dialogue_main);

// --- 게임 화면 좌표 ---
var _game_screen_x = panel_x + 20;
var _game_screen_y = panel_y + 60;
var _game_screen_w = panel_w - info_panel_width - 50;
var _game_screen_h = panel_h - 80;
var _game_cx = _game_screen_x + _game_screen_w / 2;
var _game_cy = _game_screen_y + _game_screen_h / 2;

// --- 릴 그리기 ---
var _reel_width = 100;
var _symbol_height = 64;
var _symbol_scale = 2;
var _start_x = _game_cx - _reel_width;

// 릴 배경
draw_set_color(c_black);
draw_rectangle(_start_x - 5, _game_cy - (_symbol_height * _symbol_scale * 1.5) - 5, _start_x + _reel_width * 3 + 5, _game_cy + (_symbol_height * _symbol_scale * 1.5) + 5, false);
draw_set_color(c_white);

// 릴과 심볼 그리기
for (var i = 0; i < 3; i++) {
    var _reel_x = _start_x + i * _reel_width;
    var _reel = reels[i];
    
    // 심볼 목록을 순환하며 그리기
    var _num_symbols = array_length(_reel.symbols);
    for (var j = 0; j < _num_symbols; j++) {
        var _symbol_index = _reel.symbols[j];
        var _symbol_y_base = _game_cy + (j * _symbol_height * _symbol_scale);
        var _draw_y = _symbol_y_base - (_reel.position % (_num_symbols * _symbol_height * _symbol_scale));

        // 화면 위아래로 순환되도록 조정
        if (_draw_y < _game_cy - (_num_symbols / 2 * _symbol_height * _symbol_scale)) {
            _draw_y += _num_symbols * _symbol_height * _symbol_scale;
        }
        if (_draw_y > _game_cy + (_num_symbols / 2 * _symbol_height * _symbol_scale)) {
            _draw_y -= _num_symbols * _symbol_height * _symbol_scale;
        }

        // 그리기 영역(가운데 3칸) 내에 있을 때만 그리기
        if (abs(_draw_y - _game_cy) < _symbol_height * _symbol_scale * 1.5) {
            draw_sprite_ext(sSymbol, _symbol_index, _reel_x + _reel_width / 2, _draw_y, _symbol_scale, _symbol_scale, 0, c_white, 1);
        }
    }
}

// 가운데 라인
draw_set_color(c_yellow);
draw_line_width(_start_x, _game_cy, _start_x + _reel_width * 3, _game_cy, 3);
draw_set_color(c_white);


// --- 결과 메시지 ---
if (state == SlotMachineState.RESULT) {
    draw_text(_game_cx, _game_cy + 200, result_message);
}

// --- 정보 패널 버튼 ---
var _info_panel_x = panel_x + panel_w - info_panel_width - 20;
var _info_panel_y = panel_y + 60;

if (state == SlotMachineState.SPINNING) {
    draw_custom_button(button_stop, button_stop.sprite, _info_panel_x, _info_panel_y);
}

// --- 그리기 설정 초기화 ---
draw_set_halign(fa_left);
draw_set_valign(fa_top);