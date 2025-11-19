/// @description 아이콘 위치 계산 및 캐싱 (그룹화 적용)

icon_regions = [];
var _traits_list = global.all_traits;
if (!is_array(_traits_list) || array_length(_traits_list) == 0) exit;

// --- 1. 특성 목록을 그룹별로 재구성 ---
var _groups = [];
var _current_group_array = [];
var _current_group_id = floor(_traits_list[0].traits_num / 10);

for (var i = 0; i < array_length(_traits_list); i++) {
    var _trait = _traits_list[i];
    var _group_id = floor(_trait.traits_num / 10);

    if (_group_id != _current_group_id) {
        if (array_length(_current_group_array) > 0) {
            array_push(_groups, _current_group_array);
        }
        _current_group_id = _group_id;
        _current_group_array = [];
    }
    array_push(_current_group_array, _trait);
}
if (array_length(_current_group_array) > 0) {
    array_push(_groups, _current_group_array);
}

// --- 2. 그룹별로 좌표 계산 ---

// 그리드 매개변수
var _columns = 8;
var _icon_w = 64;
var _icon_h = 64;
var _spacing_x = 20;
var _spacing_y = 30;
var _group_spacing_y = 40;
var _start_x = (room_width - ((_icon_w + _spacing_x) * _columns - _spacing_x)) / 2;
var _start_y = 120;

var _current_draw_y = _start_y; // y좌표는 계속 누적됨

for (var g = 0; g < array_length(_groups); g++) {
    var _group = _groups[g];
    
    // 현재 그룹의 아이콘들 좌표 계산
    for (var i = 0; i < array_length(_group); i++) {
        var _trait_data = _group[i];
        var _col = i % _columns;
        var _row = floor(i / _columns);

        var _draw_x = _start_x + _col * (_icon_w + _spacing_x);
        var _y_pos_in_group = _row * (_icon_h + _spacing_y);
        
        array_push(icon_regions, { x: _draw_x, y: _current_draw_y + _y_pos_in_group, w: _icon_w, h: _icon_h, data: _trait_data });
    }
    
    // 다음 그룹을 그릴 y 위치를 계산
    var _rows_in_this_group = ceil(array_length(_group) / _columns);
    _current_draw_y += _rows_in_this_group * (_icon_h + _spacing_y) + _group_spacing_y - _spacing_y;
}
