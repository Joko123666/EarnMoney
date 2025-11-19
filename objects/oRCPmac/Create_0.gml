/// @description oRCPmac - Create Event
event_inherited();

// 가위바위보 기계 상태 열거형
enum RCPMachineState {
    IDLE, BETTING, CHOOSING, ANIMATING, RESULT
}

state = RCPMachineState.IDLE;

// 머신 타입 및 이름 설정
mac_type = "Hand";
game_name = "Rock Paper Scissors";

// 게임 변수
player_choice = -1; // 0: 바위, 1: 보, 2: 가위
computer_choice = -1;
result_message = "";

// 배당률 변수
payout_rate = 0; // 최종 배당률
win_payout = 2;      // 승리 시 배당률
draw_payout = 1;     // 무승부 시 배당률
win_payout_default = 2; // 기본 승리 배당률
draw_payout_default = 1; // 기본 무승부 배당률

// 아티팩트 관련 변수
relevant_artifacts = ["Hand_bronze", "Hand_silver", "Hand_gold", "Hand_figure", "Hand_V", "Hand_ironfist", "Hand_rock", "Hand_coin", "Hand_black"];
equipped_artifacts = [];
consecutive_losses = 0; // 연속 패배 횟수

// 애니메이션 변수
animation_timer = 0;
animation_duration = 1.5 * room_speed;
winner = -1;
player_sprite_scale = 2;
computer_sprite_scale = 2;
win_scale = 2.5;
lose_scale = 1.5;
default_scale = 2;

// --- oRCPmac 고유 버튼 레이아웃 정의 (부모의 상대 좌표 시스템 활용) ---

// Play Again 버튼은 Play 버튼과 동일한 위치와 크기를 사용합니다.
button_play_again = { rel_x: _info_padding, rel_y: _action_btn_y, w: _full_btn_w, h: 55, label: "Play Again", sprite: sButton };

// 선택 버튼 (가위, 바위, 보) - 3개를 가로로 나열합니다.
var _choice_btn_gap = 10;
var _choice_btn_w = (_full_btn_w - (_choice_btn_gap * 2)) / 3;
var _choice_btn_y = _action_btn_y - 60; // Play 버튼보다 약간 위에 배치합니다.

button_rock     = { rel_x: _info_padding, rel_y: _choice_btn_y, w: _choice_btn_w, h: 50, label: "Rock", sprite: sButton };
button_paper    = { rel_x: _info_padding + _choice_btn_w + _choice_btn_gap, rel_y: _choice_btn_y, w: _choice_btn_w, h: 50, label: "Paper", sprite: sButton };
button_scissors = { rel_x: _info_padding + (_choice_btn_w + _choice_btn_gap) * 2, rel_y: _choice_btn_y, w: _choice_btn_w, h: 50, label: "Scissors", sprite: sButton };