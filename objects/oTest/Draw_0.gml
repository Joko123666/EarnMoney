/// @description Draw Wireframe UI

// --- 기본 설정 ---
var _text_color = c_white;
var _border_color = #666666; // 어두운 회색 테두리
var _fill_color_dark = #333333; // 짙은 회색 배경 (게임 스크린)
var _fill_color_medium = #444444; // 중간 회색 배경 (콘솔 등)

// --- 폰트 설정 (실제 프로젝트에 있는 폰트로 교체 필요) ---
// font_main 또는 fnt_dialogue_main 등의 폰트가 있다고 가정합니다.
if (font_exists(mainfont)) {
    draw_set_font(mainfont);
} else {
    // 기본 폰트 사용
}
draw_set_halign(fa_center);
draw_set_valign(fa_middle);


// --- 1. 상단 바 (Player_money, Artifacts, Stage) ---
var _top_bar_h = 108; // 게임 스크린 시작 y좌표 기준
draw_set_color(_fill_color_medium);
draw_rectangle(0, 0, 1920, _top_bar_h, false);
draw_set_color(_border_color);
draw_rectangle(0, 0, 1920, _top_bar_h, true);

// 상단 바 텍스트
draw_set_color(_text_color);
draw_text(384 / 2, _top_bar_h / 2, "Player_money"); // 왼쪽 여백 중앙
draw_text(1920 / 2, _top_bar_h / 2, "Artifacts"); // 화면 중앙
draw_text(1920 - (1920 - 1536)/2, _top_bar_h / 2, "Stage"); // 오른쪽 여백 중앙


// --- 2. 게임 스크린 (Game Screen) ---
var _game_screen_x = 384;
var _game_screen_y = 108;
var _game_screen_w = 1152;
var _game_screen_h = 648;

draw_set_color(_fill_color_dark);
draw_rectangle(_game_screen_x, _game_screen_y, _game_screen_x + _game_screen_w, _game_screen_y + _game_screen_h, false);
draw_set_color(_border_color);
draw_rectangle(_game_screen_x, _game_screen_y, _game_screen_x + _game_screen_w, _game_screen_y + _game_screen_h, true);


// --- 3. 하단 콘솔 (Betting, Rate, Artifacts) ---
var _console_y_start = _game_screen_y + _game_screen_h; // 756
var _console_h = 1080 - _console_y_start; // 나머지 전체 높이

draw_set_color(_fill_color_medium);
draw_rectangle(0, _console_y_start, 1920, 1080, false);
draw_set_color(_border_color);
draw_rectangle(0, _console_y_start, 1920, 1080, true);

// 하단 콘솔 영역 나누기 (3등분)
var _console_section_w = 1920 / 3;
var _console_text_y = _console_y_start + _console_h / 2;

// Betting 영역
draw_line(_console_section_w, _console_y_start, _console_section_w, 1080);
draw_set_color(_text_color);
draw_text(_console_section_w / 2, _console_text_y, "Betting");

// Rate 영역
draw_line(_console_section_w * 2, _console_y_start, _console_section_w * 2, 1080);
draw_set_color(_text_color);
draw_text(_console_section_w + (_console_section_w / 2), _console_text_y, "Rate");

// Artifacts 영역
draw_set_color(_text_color);
draw_text((_console_section_w * 2) + (_console_section_w / 2), _console_text_y, "Artifacts");


// --- 그리기 설정 초기화 ---
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);