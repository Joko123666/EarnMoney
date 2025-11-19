/// @description 보상 선택 UI 그리기 (동적 레이아웃)

var _gui_width = display_get_gui_width();
var _gui_height = display_get_gui_height();

if (array_length(choices) == 0) exit;

// --- 0. 선택지 분리 ---
var _display_choices = [];
var _decline_choice_index = -1;

for (var i = 0; i < array_length(choices); i++) {
    var _choice = choices[i];
    if (variable_struct_exists(_choice, "is_decline") && _choice.is_decline) {
        _decline_choice_index = i;
    } else {
        array_push(_display_choices, {data: _choice, original_index: i});
    }
}

var _num_display_choices = array_length(_display_choices);

// --- 1. 배경 및 기본 설정 ---
draw_set_color(c_black);
draw_set_alpha(0.8);
draw_rectangle(0, 0, _gui_width, _gui_height, false);
draw_set_alpha(1.0);

draw_set_font(font_main);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// --- 2. 카드 레이아웃 계산 ---
if (_num_display_choices > 0) {
    var _card_w = 200; 
    var _card_h = 280; 
    var _spacing = 40; 

    switch (prize_type) {
        case 2:
            var _top_row_y = _gui_height / 2 - _card_h + 20;
            var _bottom_row_y = _gui_height / 2 + 20;
            
            var _top_row_count = min(2, _num_display_choices);
            if (_top_row_count > 0) {
                var _top_row_width = (_card_w * _top_row_count) + (_spacing * (_top_row_count - 1));
                for (var i = 0; i < _top_row_count; i++) {
                    _display_choices[i].data.x = (_gui_width - _top_row_width) / 2 + i * (_card_w + _spacing);
                    _display_choices[i].data.y = _top_row_y;
                }
            }
            
            if (_num_display_choices > 2) {
                var _bottom_row_count = _num_display_choices - 2;
                var _bottom_row_width = (_card_w * _bottom_row_count) + (_spacing * (_bottom_row_count - 1));
                for (var i = 2; i < _num_display_choices; i++) {
                    _display_choices[i].data.x = (_gui_width - _bottom_row_width) / 2 + (i - 2) * (_card_w + _spacing);
                    _display_choices[i].data.y = _bottom_row_y;
                }
            }
            break;

        default:
            var _total_width = (_card_w * _num_display_choices) + (_spacing * (_num_display_choices - 1));
            var _start_x = (_gui_width - _total_width) / 2;
            var _start_y = (_gui_height - _card_h) / 2;
            
            for (var i = 0; i < _num_display_choices; i++) {
                _display_choices[i].data.x = _start_x + i * (_card_w + _spacing);
                _display_choices[i].data.y = _start_y;
            }
            break;
    }

    // --- 3. 카드 그리기 ---
    for (var i = 0; i < _num_display_choices; i++) {
        var _choice_wrapper = _display_choices[i];
        var _choice = _choice_wrapper.data;
        var _original_index = _choice_wrapper.original_index;

        _choice.w = _card_w;
        _choice.h = _card_h;
        
        var _x = _choice.x, _y = _choice.y, _w = _choice.w, _h = _choice.h;

        var _border_color = c_dkgray;
        if (state == "choosing" && hover_choice == _original_index) _border_color = c_white;
        else if (state == "selected" && selected_choice == _original_index) _border_color = c_yellow;

        draw_set_color(c_black);
        draw_rectangle(_x, _y, _x + _w, _y + _h, false);
        draw_set_color(_border_color);
        draw_rectangle(_x, _y, _x + _w, _y + _h, true);

        var _sprite_x = _x + _w / 2, _sprite_y = _y + 80;
        if (sprite_exists(_choice.sprite)) {
            draw_sprite_ext(_choice.sprite, _choice.image_index, _sprite_x, _sprite_y, 2, 2, 0, c_white, 1);
        }

        draw_set_color(c_white);
        draw_set_valign(fa_top);
        draw_text(_x + _w / 2, _y + 180, _choice.name);
        
        draw_set_font(fnt_dialogue_main);
        draw_text_ext(_x + _w / 2, _y + 210, _choice.desc, 18, _w - 20);
        draw_set_font(font_main);
    }
}

// --- 4. '포기' 버튼 그리기 ---
if (_decline_choice_index != -1) {
    var _choice = choices[_decline_choice_index];
    
    var _w = 400;
    var _h = 80;
    var _x = (_gui_width - _w) / 2;
    var _y = _gui_height - _h - 40; // 하단에 40px 여백

    // Step 이벤트에서 클릭 감지를 위해 w, h 업데이트
    _choice.x = _x;
    _choice.y = _y;
    _choice.w = _w;
    _choice.h = _h;

    var _border_color = c_dkgray;
    if (state == "choosing" && hover_choice == _decline_choice_index) _border_color = c_white;
    else if (state == "selected" && selected_choice == _decline_choice_index) _border_color = c_yellow;

    draw_set_color(c_black);
    draw_rectangle(_x, _y, _x + _w, _y + _h, false);
    draw_set_color(_border_color);
    draw_rectangle(_x, _y, _x + _w, _y + _h, true);

    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(_x + _w / 2, _y + _h / 2, _choice.name);
}

// --- 5. 그리기 설정 초기화 ---
draw_set_halign(fa_left);
draw_set_valign(fa_top);