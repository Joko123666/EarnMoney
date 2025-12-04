/// @description Initialize Game Result Popup

// 팝업 크기 설정
width = 600;
height = 500;

// 화면 중앙에 위치 (GUI 좌표 기준)
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
x_pos = (_gui_w - width) / 2;
y_pos = (_gui_h - height) / 2;

// 데이터 변수 (oGame에서 인스턴스 생성 직후 설정해야 함)
is_win = false;          // 승리 여부
final_money = 0;         // 최종 소지금
soul_points = 0;         // 획득한 소울 포인트

// 버튼 설정 (크기 및 간격)
var _btn_w = 200;
var _btn_h = 60;
var _gap = 40;

// 버튼 1: 다시하기
button_restart = {
    x: x_pos + width / 2 - _btn_w - _gap / 2,
    y: y_pos + height - 100,
    w: _btn_w,
    h: _btn_h,
    label: "다시하기",
    sprite: sButton
};

// 버튼 2: 타이틀로
button_title = {
    x: x_pos + width / 2 + _gap / 2,
    y: y_pos + height - 100,
    w: _btn_w,
    h: _btn_h,
    label: "타이틀로",
    sprite: sButton
};

// 텍스트 폰트 설정
font_title = fnt_dialogue_name; 
font_main = fnt_dialogue_main;