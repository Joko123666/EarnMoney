/// @description oCardmac - Create Event
event_inherited();

// --- 상태 정의 ---
enum CardMacState {
    IDLE,       // 대기 상태
    BETTING,    // 베팅 상태
    SHUFFLING,  // 카드 섞는 애니메이션 상태
    DRAWING,    // 플레이어의 카드 뽑기 대기 상태
    REVEAL,     // 카드를 뒤집어 공개하는 애니메이션 상태
    RESULT      // 최종 결과 표시 상태
}

state = CardMacState.IDLE;
mac_type = "Card";

// --- 아티팩트 관련 변수 ---
relevant_artifacts = ["Card_bronze", "Card_silver", "Card_gold", "Card_ace", "Card_punch", "Card_glass", "Card_ten", "Card_black"];
equipped_artifacts = [];

// --- 베팅 관련 변수 ---
current_bet = 10;
min_bet = 10;
max_bet = 100;
bet_increment = 10;

// --- 게임 고유 변수 ---
deck = []; // 1-10 카드를 담을 배열
drawn_card_value = 0; // 뽑은 카드의 숫자
payout_rate = 10.0; // 승리 시 배당률
payout_rate_default = 10.0; // 기본 배당률

// --- 연출(애니메이션) 관련 변수 ---
anim_timer = 0;
shuffle_duration = 1.2;   // 카드 섞는 시간
reveal_duration = 1.0;    // 카드 공개 시간 (이동과 뒤집기 포함)
result_delay_duration = 1.5; // 결과 메시지 표시 전 대기 시간

// 카드 애니메이션을 위한 변수
card_anim_progress = 0; // 0-1 사이의 값으로 애니메이션 진행도 표시
card_start_x = 0;
card_start_y = 0;
card_target_x = 0;
card_target_y = 0;

// --- UI 관련 변수 ---
result_message = "";

// --- UI 패널 및 버튼 좌표 정의 ---
// 부모(oMacs_parent)에서 대부분의 버튼(bet, play, close)이 정의됩니다.
// 여기서는 이 게임에만 필요한 버튼을 추가로 정의하거나, 부모의 버튼을 재정의합니다.

// "Play Again" 버튼은 "Play" 버튼과 동일한 위치를 사용하지만 레이블이 다릅니다.
button_play_again = { 
    rel_x: _info_padding, 
    rel_y: _action_btn_y, 
    w: _full_btn_w, 
    h: 55, 
    label: "Play Again", 
    sprite: sButton 
};

// 카드 덱 영역 (클릭 가능)
// 게임 화면 중앙 좌표를 부모 변수를 이용해 계산
var _game_screen_x = panel_x + 20;
var _game_screen_y = panel_y + 60;
var _game_screen_w = panel_w - info_panel_width - 50;
var _game_screen_h = panel_h - 80;
var _game_cx = _game_screen_x + _game_screen_w / 2;
var _game_cy = _game_screen_y + _game_screen_h / 2;

// sCard_back 스프라이트의 크기를 기준으로 설정
var _card_w = sprite_get_width(sCard_back);
var _card_h = sprite_get_height(sCard_back);
area_deck = { x: _game_cx - _card_w/2, y: _game_cy - _card_h/2, w: _card_w, h: _card_h };

// 닫기 버튼은 부모에서 상속받으므로 정의할 필요 없음

// --- 미구현 아티팩트 메모 ---
// Card_double: 한 장만 뽑는 게임이라 구현 불가
// Card_punch: 게임 결과 순서 추적 로직 필요하여 보류
// Card_glass: 카드 미리보기 UI 기능 필요하여 보류