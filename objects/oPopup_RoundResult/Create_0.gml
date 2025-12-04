/// @description Initialize Round Result Popup

// 팝업 크기 설정
width = 500;
height = 350;

// 화면 중앙에 위치 (GUI 좌표 기준)
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
x_pos = (_gui_w - width) / 2;
y_pos = (_gui_h - height) / 2;

// 데이터 변수 (oGame에서 인스턴스 생성 직후 설정해야 함)
is_success = false;      // 성공 여부
target_amount = 0;       // 목표 금액
current_amount = 0;      // 현재 금액

// 버튼 설정
var _btn_w = 200;
var _btn_h = 50;

button_confirm = {
    x: x_pos + (width - _btn_w) / 2,
    y: y_pos + height - 80,
    w: _btn_w,
    h: _btn_h,
    label: "확인", // 상황에 따라 "다음 라운드" 또는 "게임 오버"로 변경됨
    sprite: sButton
};

// 텍스트 폰트 설정 (기존 폰트 사용)
font_title = fnt_dialogue_name; // 제목용 (큰 폰트가 있다면 교체 추천)
font_main = fnt_dialogue_main;  // 본문용