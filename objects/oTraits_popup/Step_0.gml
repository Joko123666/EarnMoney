/// @description Handle Inputs for the Traits Popup

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _clicked = mouse_check_button_pressed(mb_left);

// --- 최우선 입력 처리 (창 닫기) ---
var _close_btn = { x: room_width - 90, y: 40, w: 120, h: 40, label: "닫기" };
var _hover_close = (_mx > _close_btn.x - _close_btn.w / 2 && _mx < _close_btn.x + _close_btn.w / 2 &&
                  _my > _close_btn.y - _close_btn.h / 2 && _my < _close_btn.y + _close_btn.h / 2);
if (_hover_close && _clicked) {
    instance_destroy();
	oMainmenu_control.menu_state = "main";
    exit; // 다른 입력 처리를 막기 위해 즉시 종료
}
if (can_close_with_escape && keyboard_check_pressed(vk_escape)) {
    instance_destroy();
	oMainmenu_control.menu_state = "main";
    exit; // 다른 입력 처리를 막기 위해 즉시 종료
}

// 데이터 유효성 검사
if (!is_array(icon_regions)) exit;

// --- 클릭 발생 시 우선순위에 따라 처리 ---
if (_clicked) {
    var _click_handled = false; // 클릭이 UI 요소에 의해 처리되었는지 여부

    // 우선순위 1: 업그레이드 버튼 클릭 확인
    if (selected_trait_name != noone) {
        var _selected_trait_data = noone;
        for (var i = 0; i < array_length(global.all_traits); i++){
            if (global.all_traits[i].name == selected_trait_name) { _selected_trait_data = global.all_traits[i]; break; }
        }

        if (_selected_trait_data != noone) {
            var _popup_w = 300; var _popup_h = 200;
            var _upgrade_btn_w = 120; var _upgrade_btn_h = 40;
            var _upgrade_btn_x = popup_x + _popup_w - padding - (_upgrade_btn_w / 2);
            var _upgrade_btn_y = popup_y + _popup_h - padding - (_upgrade_btn_h / 2);

            if (_mx > _upgrade_btn_x - _upgrade_btn_w/2 && _mx < _upgrade_btn_x + _upgrade_btn_w/2 &&
                _my > _upgrade_btn_y - _upgrade_btn_h/2 && _my < _upgrade_btn_y + _upgrade_btn_h/2) {
                
                var _level = get_player_trait_level(selected_trait_name);
                var _max_level = _selected_trait_data.traits_level;
                var _cost = _selected_trait_data.purchase_price;

                if (_level < _max_level && global.Soulpoint >= _cost) {
                    global.Soulpoint -= _cost;
                    add_player_trait(selected_trait_name);
                }
                _click_handled = true; // 업그레이드 버튼이 클릭을 처리했음을 표시
            }
        }
    }

    // 우선순위 2: 특성 아이콘 클릭 확인
    if (!_click_handled) {
        for (var i = 0; i < array_length(icon_regions); i++) {
            var _region = icon_regions[i];
            if (_mx > _region.x && _mx < _region.x + _region.w && _my > _region.y && _my < _region.y + _region.h) {
                var _trait_data = _region.data;
                if (selected_trait_name == _trait_data.name) {
                    selected_trait_name = noone;
                } else {
                    selected_trait_name = _trait_data.name;
                    popup_x = _region.x + _region.w + 10;
                    popup_y = _region.y;
                }
                _click_handled = true; // 아이콘이 클릭을 처리했음을 표시
                break;
            }
        }
    }

    // 우선순위 3: 배경 클릭 확인
    if (!_click_handled) {
        selected_trait_name = noone; // 어떤 UI 요소도 클릭되지 않았으므로 팝업을 닫음
    }
}