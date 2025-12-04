/// @description Initialize Next Stage Popup

// 팝업 크기 설정
width = 500;
height = 400;

// 화면 중앙에 위치 (GUI 좌표 기준)
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
x_pos = (_gui_w - width) / 2;
y_pos = (_gui_h - height) / 2;

// 데이터 변수 (oGame에서 인스턴스 생성 직후 설정)
next_stage_name = "";
start_amount = 0;
target_amount = 0;
chance_count = 0;

// 버튼 설정
var _btn_w = 200;
var _btn_h = 50;

button_start = {
    x: x_pos + (width - _btn_w) / 2,
    y: y_pos + height - 80,
    w: _btn_w,
    h: _btn_h,
    label: "라운드 시작",
    sprite: sButton
};

// 텍스트 폰트 설정
font_title = fnt_dialogue_name;
font_main = fnt_dialogue_main;