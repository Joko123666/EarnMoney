/// @description oFingermac - Create Event
// 부모 oMacs_parent의 Create 이벤트를 상속받습니다.
event_inherited();

// --- 상태 정의 ---
enum FingerMacState {
    IDLE, BETTING, DEALER_SETUP, PLAYER_CHOICE, REVEAL, RESULT
}
state = FingerMacState.IDLE;

// 머신 타입을 "Hand"로 설정합니다.
mac_type = "Hand";

// --- 베팅 관련 변수 ---
current_bet = 10;
min_bet = 10;
max_bet = 100;
bet_increment = 10;

// --- 게임 고유 변수 ---
hidden_hand_value = 0;
shown_hand_value = 0;
player_guess = -1;
payout_rate = 0;
payout_rate_2x_default = 2;   // 기본 2배 배당률
payout_rate_10x_default = 10; // 기본 10배 배당률

// --- 아티팩트 관련 변수 ---
relevant_artifacts = ["Hand_bronze", "Hand_silver", "Hand_gold", "Hand_figure", "Hand_V", "Hand_ironfist", "Hand_rock", "Hand_coin", "Hand_black"];
equipped_artifacts = [];
consecutive_losses = 0; // 연속 패배 횟수

// --- 애니메이션 관련 변수 ---
anim_timer = 0;
dealer_setup_duration = 1.0;
reveal_duration = 1.5;
result_delay_duration = 1.5;

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

// 숫자 선택 버튼 (0-5) - 게임 화면 내에 위치
buttons_player_choice = array_create(6);
var _game_screen_x = panel_x + 20;
var _game_screen_y = panel_y + 60;
var _game_screen_w = panel_w - info_panel_width - 50;
var _game_screen_h = panel_h - 80;

var _b_w = 80, _b_h = 50, _b_gap = 15;
var _total_w = (6 * _b_w) + (5 * _b_gap);
var _start_x = _game_screen_x + (_game_screen_w - _total_w) / 2;
var _btn_y = _game_screen_y + _game_screen_h - _b_h - 20; // 게임 화면 하단에 배치

for (var i = 0; i < 6; i++) {
    buttons_player_choice[i] = {
        x: _start_x + i * (_b_w + _b_gap), // 절대 좌표 사용
        y: _btn_y,                        // 절대 좌표 사용
        w: _b_w,
        h: _b_h,
        label: string(i),
        sprite: sButton
    };
}

// 닫기 버튼은 부모에서 상속받으므로 정의할 필요 없음