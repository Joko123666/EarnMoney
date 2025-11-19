/// @description oCoinmac - Create Event
event_inherited();

// 코인 기계의 상태를 정의하는 열거형
enum CoinMachineState {
    IDLE,       // 대기 상태 (플레이어의 상호작용을 기다림)
    BETTING,    // 베팅 금액을 조절하는 상태
    TOSSING,    // 코인을 던지는 애니메이션 상태
    SETTLEMENT, // 정산 상태 (결과 확인 후 정산 또는 재도전 선택)
    RESULT      // 최종 결과 표시 상태
}

// 초기 상태를 IDLE로 설정
state = CoinMachineState.IDLE;

// 머신 타입
mac_type = "Coin";

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
equipped_artifacts = []; // 장착된 아티팩트 데이터(구조체)를 저장할 배열

// UI 관련 변수
result_message = ""; // 결과 메시지
coin_spacing = 4; // 코인 간격

// --- oCoinmac 고유 버튼 레이아웃 정의 (부모의 상대 좌표 시스템 활용) ---
// 부모의 변수들을 상속받아 사용합니다.
// oMacs_parent에서 정의된 변수들을 재사용하여 일관된 레이아웃을 유지합니다.
// (예: _info_padding, _btn_h, _action_btn_y, info_panel_width 등)

// Play Again 버튼은 Play 버튼과 동일한 위치와 크기를 사용합니다.
button_play_again = { rel_x: _info_padding, rel_y: _action_btn_y, w: _full_btn_w, h: 55, label: "Play Again", sprite: sButton };

// 재도전 및 정산 버튼 (분할될 경우)
var _reroll_btn_w = (info_panel_width - _info_padding * 2 - 5) / 2; // 전체 너비에서 간격 5를 빼고 2로 나눔
button_reroll = { rel_x: _info_padding, rel_y: _action_btn_y, w: _reroll_btn_w, h: 47, label: "재도전", sprite: sButton };
button_settle = { rel_x: _info_padding + _reroll_btn_w + 5, rel_y: _action_btn_y, w: _reroll_btn_w, h: 47, label: "정산", sprite: sButton };

// 정산 버튼 (전체 너비)
button_settle_full = { rel_x: _info_padding, rel_y: _action_btn_y, w: _full_btn_w, h: 47, label: "정산", sprite: sButton };

