/// @description oOEmac - Create Event
// oMacs_parent의 Create 이벤트를 상속받아 기본 변수들을 초기화합니다.
event_inherited();

// --- 상태 정의 ---
// 홀짝 게임(oOEmac)의 상태를 정의하는 열거형입니다.
enum OEmacState {
    IDLE,       // 대기 상태 (플레이어가 기계를 클릭하기를 기다림)
    BETTING,    // 베팅 금액을 조절하는 상태
    ROLLING,    // 주사위를 굴리고 컵으로 덮는 애니메이션 상태
    CHOOSING,   // 플레이어가 홀/짝을 선택하는 상태
    PRE_REVEAL, // 컵을 열기 전 잠시 멈추는 상태 (긴장감 고조)
    REVEAL,     // 컵을 열어 결과를 보여주는 애니메이션 상태
    RESULT      // 최종 승/패 결과를 표시하는 상태
}

// 초기 상태를 IDLE로 설정합니다.
state = OEmacState.IDLE;

// 머신 타입을 "OE" (Odd/Even)으로 설정합니다.
mac_type = "OE";

// --- 베팅 관련 변수 ---
current_bet = 10;      // 현재 베팅 금액
min_bet = 10;          // 최소 베팅 금액
max_bet = 100;         // 최대 베팅 금액
bet_increment = 10;    // 베팅 금액 조절 단위

// --- 게임 고유 변수 ---
payout_rate = 2.0;     // 배당률 (성공 시 베팅액의 2배를 받음)
dice_results = [1, 1]; // 두 주사위의 눈 결과 (1-6)
dice_sum = 0;          // 두 주사위 눈의 합
player_choice = "";    // 플레이어의 선택 ("Odd" 또는 "Even")
is_rolling = false;    // 현재 주사위를 굴리는 중인지 여부

// --- 아티팩트 관련 변수 ---
relevant_artifacts = ["Dice_low", "Dice_high", "Dice_copper", "Dice_silver", "Dice_gold", "Dice_bone", "Dice_one", "Dice_iron"];
equipped_artifacts = [];

// --- 애니메이션 관련 변수 ---
anim_timer = 0;                   // 애니메이션 진행 시간을 추적하는 타이머
cup_anim_duration = 0.8;          // 컵이 움직이는 애니메이션 시간 (초) - 기존 0.5초
pre_reveal_delay_duration = 0.7;  // 컵을 열기 전 멈추는 시간 (초) - 새로 추가
reveal_delay_duration = 1.5;      // 결과 공개 전 딜레이 시간 (초) - 기존 1.0초

// --- UI 관련 변수 ---
result_message = ""; // 결과 메시지 (예: "승리!", "패배...")

// --- 버튼 정의 ---
// 부모(oMacs_parent)에서 button_play, button_bet_up/down, button_internal_close가 정의됩니다.
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

// 홀/짝 선택 버튼 (게임 화면 내에 위치)
var _game_screen_x = panel_x + 20;
var _game_screen_y = panel_y + 60;
var _game_screen_w = panel_w - info_panel_width - 50;
var _game_screen_h = panel_h - 80;
var _game_cx = _game_screen_x + _game_screen_w / 2;
var _game_cy = _game_screen_y + _game_screen_h / 2;

var _choice_btn_w = 200;
var _choice_btn_h = 60;
button_choose_odd = { 
    x: _game_cx - _choice_btn_w - 10, 
    y: _game_cy - (_choice_btn_h/2), 
    w: _choice_btn_w, 
    h: _choice_btn_h, 
    label: "홀", 
    sprite: sButton 
};
button_choose_even = { 
    x: _game_cx + 10, 
    y: _game_cy - (_choice_btn_h/2), 
    w: _choice_btn_w, 
    h: _choice_btn_h, 
    label: "짝", 
    sprite: sButton 
};

// 닫기 버튼은 부모에서 상속받으므로 정의할 필요 없음