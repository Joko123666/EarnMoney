/// @description oCardmac - Draw Event
event_inherited();
if (state == CardMacState.IDLE) exit;

// --- 그리기 설정 및 좌표 ---
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// 부모가 그려준 게임 화면 영역의 좌표를 가져옵니다.
var _game_screen_x = panel_x + 20;
var _game_screen_y = panel_y + 60;
var _game_screen_w = panel_w - info_panel_width - 50;
var _game_screen_h = panel_h - 80;
var _game_cx = _game_screen_x + _game_screen_w / 2;
var _game_cy = _game_screen_y + _game_screen_h / 2;

// --- 상태별 그리기 --- 
switch (state) {
    case CardMacState.SHUFFLING:
        // 10장의 카드가 원을 그리며 섞이는 연출
        var _progress = 1 - (anim_timer / shuffle_duration);
        for (var i = 0; i < 10; i++) {
            var _angle = (i * 36) + (_progress * 720); // 720도 회전
            var _radius = 150 * sin(_progress * pi); // 나타났다가 사라지는 효과
            var _draw_x = _game_cx + lengthdir_x(_radius, _angle);
            var _draw_y = _game_cy + lengthdir_y(_radius, _angle);
            draw_sprite(sCard_back, 0, _draw_x, _draw_y);
        }
        break;

    case CardMacState.DRAWING:
        // 쌓여있는 덱 그리기
        for (var i = 0; i < 10; i++) {
            draw_sprite(sCard_back, 0, area_deck.x + area_deck.w/2, (area_deck.y + area_deck.h/2) - i * 2);
        }
        // 덱 주변에 클릭 유도용 반짝임 효과
        var _glow_alpha = 0.5 + 0.5 * sin(get_timer() / 200000);
        draw_set_alpha(_glow_alpha);
        draw_set_color(c_yellow);
        draw_rectangle(area_deck.x - 5, area_deck.y - 5, area_deck.x + area_deck.w + 5, area_deck.y + area_deck.h + 5, true);
        draw_set_alpha(1);
        draw_set_color(c_white);

        draw_set_font(fnt_dialogue_main);
        draw_text(_game_cx, _game_cy + 150, "덱을 클릭하여 카드를 뽑으세요.");
        break;

    case CardMacState.REVEAL:
        // 카드가 덱에서 중앙으로 이동하며 뒤집히는 연출
        var _card_x = lerp(card_start_x, card_target_x, card_anim_progress);
        var _card_y = lerp(card_start_y, card_target_y, card_anim_progress);
        
        var _flip_progress = card_anim_progress * 2; // 0 -> 2
        var _x_scale = 1;
        var _sprite_to_draw = sCard_back;
        var _frame = 0;

        if (_flip_progress <= 1) {
            // 0 -> 1: 뒷면이 줄어듦
            _x_scale = 1 - _flip_progress;
        } else {
            // 1 -> 2: 앞면이 나타남
            _x_scale = _flip_progress - 1;
            _sprite_to_draw = sCard_front;
            _frame = drawn_card_value - 1; // 1-10 값을 0-9 프레임으로
        }
        draw_sprite_ext(_sprite_to_draw, _frame, _card_x, _card_y, _x_scale, 1, 0, c_white, 1);
        break;

    case CardMacState.RESULT:
        // 최종 결과 카드 표시
        draw_sprite(sCard_front, drawn_card_value - 1, _game_cx, _game_cy);
        if (anim_timer <= 0) {
            draw_set_font(fnt_dialogue_main);
            draw_text(_game_cx, _game_cy + 150, result_message);
        }
        break;
}

// --- 정보 패널 버튼 그리기 (오른쪽) ---
var _info_panel_x = panel_x + panel_w - info_panel_width - 20;
var _info_panel_y = panel_y + 60;

if (state == CardMacState.BETTING) {
    // button_play는 부모(oMacs_parent)에 정의되어 있음
    draw_custom_button(button_play, button_play.sprite, _info_panel_x, _info_panel_y);
} else if (state == CardMacState.RESULT && anim_timer <= 0) {
    draw_custom_button(button_play_again, button_play_again.sprite, _info_panel_x, _info_panel_y);
}