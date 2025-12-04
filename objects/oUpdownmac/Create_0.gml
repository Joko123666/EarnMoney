/// @description oUpdownmac - Create Event
event_inherited();

// 업다운 기계 상태 열거형
enum UpdownMachineState {
    IDLE, BETTING, CHOOSING, ROLLING, REVEALING, RESULT
}

state = UpdownMachineState.IDLE;

// 머신 타입 및 이름 설정
mac_type = "Dice";
game_name = "Up Down Game";

// 게임 변수
player_choice = -1; // 0: 다운, 1: 7, 2: 업
dice1_value = 1;
dice2_value = 1;
dice_sum = 0;
result_message = "";
payout_rate = 0;
payout_down = 2;
payout_seven = 3;
payout_up = 2;

// 애니메이션 & 공개 변수
animation_timer = 0;
animation_duration = 1.5 * room_speed;
reveal_timer = 0;
reveal_duration = 0.75 * room_speed;
reveal_step = 0;
dice_default_scale = 2.5;
dice_reveal_scale = 3.5;
dice1_scale = dice_default_scale;
dice2_scale = dice_default_scale;

// --- 버튼 레이아웃 정의 (정보 패널 기준 상대 좌표로 변환) ---
// 부모 Draw 이벤트 호환성을 위해 rel_x, rel_y 및 sprite 추가
button_bet_down = { rel_x: 45, rel_y: 161, w: 139, h: 29, label: "-", sprite: sButton };
button_bet_up   = { rel_x: 205, rel_y: 161, w: 139, h: 29, label: "+", sprite: sButton };

// 메인 행동 버튼 (Play / Play Again)
button_play       = { x: 1025, y: 490, w: 299, h: 47, label: "Play" };
button_play_again = { x: 1025, y: 490, w: 299, h: 47, label: "Play Again" };

// 선택 버튼 (Up, Down, Seven) - 게임 정보 영역에 배치
var _choice_btn_w = 299;
var _choice_btn_h = 45;
var _choice_btn_x = 1025;
var _choice_btn_start_y = 331 + 5; // 게임 정보 박스 상단 + 여백
button_down  = { x: _choice_btn_x, y: _choice_btn_start_y, w: _choice_btn_w, h: _choice_btn_h, label: "Down (2-6)" };
button_seven = { x: _choice_btn_x, y: _choice_btn_start_y + _choice_btn_h + 5, w: _choice_btn_w, h: _choice_btn_h, label: "Seven (7)" };
button_up    = { x: _choice_btn_x, y: _choice_btn_start_y + (_choice_btn_h + 5) * 2, w: _choice_btn_w, h: _choice_btn_h, label: "Up (8-12)" };