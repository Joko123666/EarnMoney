/// @description oRoulettemac - Create Event
event_inherited();

// 게임 상태 Enum
enum RouletteState {
    IDLE,     // 대기
    BETTING,  // 베팅
    SPINNING, // 회전 중
    RESULT    // 결과
}

// 상태 변수 초기화
state = RouletteState.IDLE;

// 머신 타입
mac_type = "Roul";

// 베팅 관련 변수
current_bet = 10;
min_bet = 10;
max_bet = 100;
bet_increment = 10;

// 룰렛 관련 변수
roulette_angle = 0; // 룰렛 각도
roulette_speed = 0; // 룰렛 속도
roulette_friction = 0.98; // 감속 계수
result_number = 0; // 결과 숫자
result_message = ""; // 결과 메시지

// 룰렛 각 영역 크기 (총합 360도)
segment_sizes = [
    85, // 1
    65, // 2
    55, // 3
    55, // 4
    45, // 5
    25, // 6
    15, // 7
    15  // 8
];

// 각 영역의 끝 각도를 미리 계산
segment_end_angles = array_create(8, 0);
var _cumulative_angle = 0;
for (var i = 0; i < 8; i++) {
    _cumulative_angle += segment_sizes[i];
    segment_end_angles[i] = _cumulative_angle;
}

// 배당률 (1~8)
reward_rates = array_create(8, 0);
reward_rates[0] = 2; // 1
reward_rates[1] = 2; // 2
reward_rates[2] = 2; // 3
reward_rates[3] = 5; // 4
reward_rates[4] = 5; // 5
reward_rates[5] = 10; // 6
reward_rates[6] = 10; // 7
reward_rates[7] = 20; // 8

// 아티팩트 관련 변수
relevant_artifacts = ["Hand_bronze", "Hand_silver", "Hand_gold"]; // 임시 아티팩트 리스트
equipped_artifacts = [];

// 베팅 버튼 (나란히 배치)
var _small_btn_w = (info_panel_width - _info_padding * 3) / 2;
button_bet_down = { rel_x: _info_padding, rel_y: _bet_btn_y, w: _small_btn_w, h: _btn_h, label: "-", sprite: sButton };
button_bet_up = { rel_x: _info_padding * 2 + _small_btn_w, rel_y: _bet_btn_y, w: _small_btn_w, h: _btn_h, label: "+", sprite: sButton };

// 행동 버튼 (전체 너비)
var _full_btn_w = info_panel_width - _info_padding * 2;
button_play = { rel_x: _info_padding, rel_y: _action_btn_y, w: _full_btn_w, h: 55, label: "Play", sprite: sButton };
button_play_again = { rel_x: _info_padding, rel_y: _action_btn_y, w: _full_btn_w, h: 55, label: "Play Again", sprite: sButton };

// 닫기 버튼 위치는 메인 패널의 오른쪽 상단 모서리 기준 상대 위치
button_internal_close = { rel_x: ui_panel_width - 40, rel_y: 15, w: 32, h: 32, label: "", sprite: sButton };