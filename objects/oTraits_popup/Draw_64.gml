/// @description 특성 UI 그리기 (그리드 레이아웃)

if (!is_array(icon_regions)) exit; // 데이터가 없으면 중단

// --- 그리기 준비 ---
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

// --- 배경 및 제목 그리기 ---
draw_set_color(c_background);
draw_set_alpha(0.9);
draw_rectangle(0, 0, room_width, room_height, false);
draw_set_alpha(1.0);

draw_set_font(font_title);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_yellow);
draw_text(room_width / 2, padding, "특성 (Traits)");

// --- 소울 포인트 표시 ---
draw_set_font(font_body);
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_text(room_width - padding, padding, "SP: " + string(global.Soulpoint));

// --- 그리기 실행 ---

// 1. 아이콘 그리기 (미리 계산된 icon_regions 사용)
for (var i = 0; i < array_length(icon_regions); i++) {
    var _region = icon_regions[i];
    var _trait_data = _region.data;
    
    var _level = get_player_trait_level(_trait_data.name);
    var _color = (_level > 0) ? c_white : c_dkgray;
    var _alpha = (_level > 0) ? 1.0 : 0.6;
    
    // sTraits 스프라이트에서 traits_num에 해당하는 프레임을 그림
    draw_sprite_ext(sTraits, _trait_data.traits_num, _region.x, _region.y, 1, 1, 0, _color, _alpha);
    
    // 선택된 아이콘일 경우 테두리 표시
    if (_trait_data.name == selected_trait_name) {
        draw_set_color(c_yellow);
        draw_rectangle(_region.x, _region.y, _region.x + _region.w, _region.y + _region.h, true);
    }
}

// 2. 정보 팝업 그리기
if (selected_trait_name != noone) {
    var _selected_trait_data = noone;
    for (var i = 0; i < array_length(global.all_traits); i++){
        if (global.all_traits[i].name == selected_trait_name){
            _selected_trait_data = global.all_traits[i];
            break;
        }
    }

    if (_selected_trait_data != noone) {
        var _popup_w = 300;
        var _popup_h = 200; // 버튼 공간 확보를 위해 높이 증가
        
        // 팝업 배경
        draw_set_color(c_black);
        draw_set_alpha(0.9);
        draw_rectangle(popup_x, popup_y, popup_x + _popup_w, popup_y + _popup_h, false);
        draw_set_alpha(1.0);
        draw_set_color(c_border);
        draw_rectangle(popup_x, popup_y, popup_x + _popup_w, popup_y + _popup_h, true);
        
        // 팝업 제목 (특성 이름)
        draw_set_font(font_title);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(c_yellow);
        draw_text(popup_x + padding, popup_y + padding, _selected_trait_data.display_name);
        
        // 팝업 내용 (특성 설명)
        draw_set_font(font_body);
        draw_set_color(c_white);
        draw_text_ext(popup_x + padding, popup_y + padding + 40, _selected_trait_data.description, 18, _popup_w - padding * 2);

        // --- 레벨, 비용, 업그레이드 버튼 --- 
        var _level = get_player_trait_level(selected_trait_name);
        var _max_level = _selected_trait_data.traits_level;
        var _cost = _selected_trait_data.purchase_price;

        // 레벨 표시
        var _level_text = "Lv. " + string(_level) + " / " + string(_max_level);
        show_debug_message("DEBUG: Displaying level for " + selected_trait_name + ": " + string(_level));
        draw_set_halign(fa_left);
        draw_set_valign(fa_bottom);
        draw_set_font(font_body);
        draw_set_color(c_white);
        draw_text(popup_x + padding, popup_y + _popup_h - padding - 30, _level_text);

        // 업그레이드 버튼 및 비용 표시
        var _upgrade_btn_w = 120;
        var _upgrade_btn_h = 40;
        var _upgrade_btn_x = popup_x + _popup_w - padding - (_upgrade_btn_w / 2);
        var _upgrade_btn_y = popup_y + _popup_h - padding - (_upgrade_btn_h / 2);
        
        // 마우스가 버튼 위에 있는지 확인
        var _hover_upgrade = (_mx > _upgrade_btn_x - _upgrade_btn_w/2 && _mx < _upgrade_btn_x + _upgrade_btn_w/2 &&
                            _my > _upgrade_btn_y - _upgrade_btn_h/2 && _my < _upgrade_btn_y + _upgrade_btn_h/2);

        var _can_upgrade = (_level < _max_level) && (global.Soulpoint >= _cost);
        var _btn_color = _can_upgrade ? (_hover_upgrade ? c_yellow : c_white) : c_dkgray;

        // 버튼 그리기 (sBox 사용)
        
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(_btn_color);
        draw_text(_upgrade_btn_x, _upgrade_btn_y - 5, "업그레이드");
        
        draw_set_font(mainfont);
        draw_set_color(_btn_color);
        draw_text(_upgrade_btn_x, _upgrade_btn_y + 10, "(" + string(_cost) + " SP)");
    }
}

// 3. 닫기 버튼 그리기
var _close_btn = { x: room_width - 90, y: 40, w: 120, h: 40, label: "닫기" };
var _hover_close = (_mx > _close_btn.x - _close_btn.w / 2 && _mx < _close_btn.x + _close_btn.w / 2 &&
                  _my > _close_btn.y - _close_btn.h / 2 && _my < _close_btn.y + _close_btn.h / 2);
var _color = _hover_close ? c_yellow : c_white;

draw_set_color(c_black);
draw_set_alpha(0.7);
draw_rectangle(_close_btn.x - _close_btn.w/2, _close_btn.y - _close_btn.h/2, _close_btn.x + _close_btn.w/2, _close_btn.y + _close_btn.h/2, false);
draw_set_alpha(1.0);
draw_set_color(_color);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fnt_dialogue_main);
draw_text(_close_btn.x, _close_btn.y, _close_btn.label);
