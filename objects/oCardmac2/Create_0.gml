/// @description oCardmac2 - Create Event
event_inherited();

// --- 상태 정의 ---
enum CardMac2State {
    IDLE,           // 대기 상태
    BETTING,        // 베팅 상태
    DEALING,        // 플레이어와 딜러가 카드를 뽑는 애니메이션 상태
    PLAYER_CHOICE,  // 플레이어가 하이/로우/세임을 선택하는 상태
    REVEAL,         // 딜러의 카드를 공개하는 애니메이션 상태
    RESULT          // 최종 결과 표시 상태
}

state = CardMac2State.IDLE;
mac_type = "Card";

// --- 아티팩트 관련 변수 ---
relevant_artifacts = ["Card_bronze", "Card_silver", "Card_gold", "Card_ace", "Card_double", "Card_punch", "Card_glass", "Card_ten", "Card_black"];
equipped_artifacts = [];

// --- 베팅 관련 변수 ---
current_bet = 10;
min_bet = 10;
max_bet = 100;
bet_increment = 10;

// --- 게임 고유 변수 ---
player_deck = [];
dealer_deck = [];
player_card_value = 0;
dealer_card_value = 0;
player_choice_str = ""; // 플레이어의 선택 ("High", "Low", "Same")
chosen_payout_rate = 0; // 선택한 배당률

// --- 동적 배당률 변수 ---
// 실제 배당률은 플레이어의 카드에 따라 실시간으로 계산됩니다.
payout_high = 2.0;
payout_low = 2.0;
payout_same = 8.0; // 'Same'은 확률이 고정되어 있으므로 배당률도 고정

// --- 연출(애니메이션) 관련 변수 ---
anim_timer = 0;
deal_duration = 1.0;      // 카드 나누어주는 시간
reveal_duration = 1.0;    // 카드 공개 시간
result_delay_duration = 1.5; // 결과 메시지 표시 전 대기 시간

// --- UI 관련 변수 ---
result_message = "";

// --- UI 패널 및 버튼 좌표 정의 ---
// 부모(oMacs_parent)에서 대부분의 버튼(bet, play, close)이 정의됩니다.
// 여기서는 이 게임에만 필요한 버튼을 추가로 정의합니다.

// "Play Again" 버튼은 "Play" 버튼과 동일한 위치를 사용합니다.
button_play_again = { 
    rel_x: _info_padding, 
    rel_y: _action_btn_y, 
    w: _full_btn_w, 
    h: 55, 
    label: "Play Again", 
    sprite: sButton 
};

// 하이/로우/세임 선택 버튼 (Play 버튼 아래에 위치)
var _choice_btn_y = _action_btn_y + 65;
var _choice_btn_w = (_full_btn_w - 10) / 3; // 3개 버튼, 간격 5px * 2
var _choice_btn_h = 47;

button_choice_high = { 
    rel_x: _info_padding, 
    rel_y: _choice_btn_y, 
    w: _choice_btn_w, 
    h: _choice_btn_h, 
    label: "HIGH", 
    sprite: sButton 
};
button_choice_low = { 
    rel_x: _info_padding + _choice_btn_w + 5, 
    rel_y: _choice_btn_y, 
    w: _choice_btn_w, 
    h: _choice_btn_h, 
    label: "LOW", 
    sprite: sButton 
};
button_choice_same = { 
    rel_x: _info_padding + (_choice_btn_w + 5) * 2, 
    rel_y: _choice_btn_y, 
    w: _choice_btn_w, 
    h: _choice_btn_h, 
    label: "SAME", 
    sprite: sButton 
};

// --- 미구현 아티팩트 메모 ---
// Card_punch: 게임 결과 순서 추적 로직 필요하여 보류
// Card_glass: 카드 미리보기 UI 기능 필요하여 보류