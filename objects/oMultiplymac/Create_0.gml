/// @description oMultiplymac - Create Event (Refactored)
event_inherited();

// --- 상태 정의 ---
enum MultiplyMacState {
    IDLE,
    BETTING,
    SPINNING,
    RESULT
}
state = MultiplyMacState.IDLE;

// --- 머신 정보 ---
mac_type = "Multiply";
game_name = "Multiply Machine";

// --- 게임 고유 변수 ---
number1 = 1; // 첫 번째 숫자
number2 = 1; // 두 번째 숫자
game_result = 0; // 곱셈 결과
payout_rate = 1.0; // 배당률 (결과에 따라 동적으로 변할 수 있음)

// --- 아티팩트 관련 변수 ---
relevant_artifacts = ["Hand_bronze", "Hand_silver", "Hand_gold"]; // 임시 아티팩트 리스트
equipped_artifacts = [];

// --- 애니메이션 관련 변수 ---
anim_timer = 0;
spin_duration = 2.0; // 룰렛이 돌아가는 시간
result_delay_duration = 1.5; // 결과 메시지 표시 전 대기 시간

// --- UI 관련 변수 ---
result_message = "";

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