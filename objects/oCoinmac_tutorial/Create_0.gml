/// @description oCoinmac - Create Event
event_inherited();

// 코인 기계의 상태를 정의하는 열거형
enum tutorialCoinMachineState {
    IDLE,       // 대기 상태 (플레이어의 상호작용을 기다림)
    BETTING,    // 베팅 금액을 조절하는 상태
    TOSSING,    // 코인을 던지는 애니메이션 상태
    SETTLEMENT, // 정산 상태 (결과 확인 후 정산 또는 재도전 선택)
    RESULT      // 최종 결과 표시 상태
}

// 초기 상태를 IDLE로 설정
state = tutorialCoinMachineState.IDLE;

// 머신 타입
mac_type = "Coin";

//tutorial setting
is_tutorial_game_over = false;
tutorial_result = "none"

// 베팅 관련 변수
current_bet = 10; // 현재 베팅 금액
min_bet = 10;     // 최소 베팅 금액
max_bet = 100;    // 최대 베팅 금액
bet_increment = 10; // 베팅 금액 조절 단위

// 동전 던지기 관련 변수
payout_rate = 2.0; // 배당률
payout_rate_defalt = 2.0; // 기본 배당률
heads_probability = 0.5; // 앞면이 나올 확률
heads_probability_defalt = 0.5; // 기본 앞면 확률
coin_count = 1; // 코인 개수 (oCoinmac은 단일 코인 기계)

coin_results = array_create(coin_count, 0); // 코인 결과 저장 배열
coin_frame_offsets = array_create(coin_count, 0); // 코인 애니메이션 프레임 오프셋
is_tossing = false; // 현재 코인을 던지는 중인지 여부
single_coin_toss_duration = 1.2; // 단일 코인 애니메이션 시간 (초)
toss_timer = 0; // 던지기 타이머
reroll_used_this_turn = false; // 이번 턴에 재굴림을 사용했는지 여부
needs_stat_recalc = false; // 능력치 재계산 필요 여부

// 아티팩트 관련 변수
relevant_artifacts = ["Coin_copper", "Coin_silver", "Coin_gold", "Coin_iron", "Coin_devil", "Coin_angel", "Coin_blood", "Coin_DDD"];
equipped_artifacts = [];

// UI 관련 변수
result_message = ""; // 결과 메시지
coin_spacing = 4; // 코인 간격

// --- UI 패널 크기 (새로운 사양 기반) ---
ui_panel_width = 1200; // UI 패널 너비
ui_panel_height = 800; // UI 패널 높이
info_panel_width = 400; // 정보 패널 너비

// 패널을 그릴 절대적인 방 좌표
panel_x = 200;
panel_y = 30;
panel_w = ui_panel_width;
panel_h = ui_panel_height;

// --- 버튼 레이아웃 정의 (상대적 위치 사용) ---
var _info_padding = 20; // 정보 패널 내부 여백
var _btn_h = 50; // 버튼 높이

// Y 좌표는 정보 패널 상단 기준 상대 위치
var _bet_section_y = 100; // 베팅 섹션 Y 위치
var _bet_btn_y = _bet_section_y + 80; // 베팅 버튼 Y 위치
var _action_btn_y = _bet_btn_y + _btn_h + 30; // 행동 버튼 Y 위치

// 베팅 버튼 (나란히 배치)
var _small_btn_w = (info_panel_width - _info_padding * 3) / 2;
button_bet_down = { rel_x: _info_padding, rel_y: _bet_btn_y, w: _small_btn_w, h: _btn_h, label: "-", sprite: sButton }; // 베팅 감소
button_bet_up = { rel_x: _info_padding * 2 + _small_btn_w, rel_y: _bet_btn_y, w: _small_btn_w, h: _btn_h, label: "+", sprite: sButton }; // 베팅 증가

// 행동 버튼 (전체 너비)
var _full_btn_w = info_panel_width - _info_padding * 2;
button_play = { rel_x: _info_padding, rel_y: _action_btn_y, w: _full_btn_w, h: 55, label: "Play", sprite: sButton }; // 플레이 버튼
button_play_again = { rel_x: _info_padding, rel_y: _action_btn_y, w: _full_btn_w, h: 55, label: "Play Again", sprite: sButton }; // 다시하기 버튼

// 정산 버튼 (나란히 배치)
button_settle = { rel_x: _info_padding, rel_y: _action_btn_y, w: _small_btn_w, h: 55, label: "정산", sprite: sButton }; // 정산 버튼
button_reroll = { rel_x: _info_padding * 2 + _small_btn_w, rel_y: _action_btn_y, w: _small_btn_w, h: 55, label: "재도전", sprite: sButton }; // 재도전 버튼

// 닫기 버튼 위치는 메인 패널의 오른쪽 상단 모서리 기준 상대 위치
button_internal_close = { rel_x: ui_panel_width - 40, rel_y: 15, w: 32, h: 32, label: "", sprite: sButton }; // 내부 닫기 버튼

