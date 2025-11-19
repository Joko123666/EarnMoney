/// @description oSlotmac - Create Event
event_inherited();

// 게임 상태를 관리하기 위한 열거형(enum) 정의
enum AdvSlotMachineState {
    IDLE,      // 플레이어의 클릭을 기다리는 기본 상태
    BETTING,   // 판돈을 조절하고 플레이를 시작하는 상태
    SPINNING,  // 릴이 회전하는 애니메이션 상태
    STOPPING_REELS, // 릴이 순차적으로 멈추는 상태
    RESULT     // 결과 확인 및 다시 플레이 여부를 결정하는 상태
}

// 상태 변수 초기화
adv_state = AdvSlotMachineState.IDLE;

// 전역 플레이/정지 버튼 (화면 하단에 고정)
adv_button_global_play = { x: 0, y: 0, w: 150, h: 50, label: "Play Slot" };
adv_button_global_stop = { x: 0, y: 0, w: 150, h: 50, label: "Stop Reel" };



// 판돈 관련 변수
adv_current_bet = 10;
adv_min_bet = 10;
adv_max_bet = 100;
adv_bet_increment = 10;

// 릴 관련 변수 (3x3 그리드)
adv_reel_results = array_create(3); // 3개의 열
for (var i = 0; i < 3; i++) {
    adv_reel_results[i] = array_create(3, 0); // 각 열에 3개의 심볼
}
adv_is_spinning = false;
adv_spin_animation_time = 2.5; // 릴 회전 시간 (초)
adv_spin_timer = 0;

// 릴 순차 정지 관련 변수
adv_reels_stopped_count = 0; // 멈춘 릴의 개수
adv_stop_reel_delay = 0.2; // 각 릴이 멈추는 간격 (초)
adv_stop_reel_timer = 0; // 다음 릴 정지까지의 타이머

// 슬롯 심볼 정의 (sSymbol 스프라이트의 서브 이미지 인덱스 및 배율)
// 심볼 인덱스는 sSymbol 스프라이트의 서브 이미지 순서와 일치해야 합니다.
// 예시: 0=체리, 1=레몬, 2=바, 3=종, 4=다이아몬드, 5=7
adv_symbol_payouts = [
    { symbol_index: 0, name: "Cherry", payout_multiplier: 5 },
    { symbol_index: 1, name: "Lemon", payout_multiplier: 10 },
    { symbol_index: 2, name: "Bar", payout_multiplier: 15 },
    { symbol_index: 3, name: "Bell", payout_multiplier: 20 },
    { symbol_index: 4, name: "Diamond", payout_multiplier: 30 },
    { symbol_index: 5, name: "Seven", payout_multiplier: 50 }
];

// UI 관련 변수
adv_result_message = "";

// UI 패널 크기 정의 (3x3 그리드에 맞게 조정)
adv_ui_panel_width = 650;
adv_ui_panel_height = 450;

// UI 패널의 실제 화면 좌표 (Step 이벤트에서 계산됨)
adv_ui_panel_x = 0;
adv_ui_panel_y = 0;

// 버튼 위치 및 크기 정의 (UI 패널 내에서의 상대 좌표)
adv_button_bet_down = { rel_x: 20, rel_y: 50, w: 32, h: 32, label: "-" };
adv_button_bet_up = { rel_x: adv_ui_panel_width - 52 - 250, rel_y: 50, w: 32, h: 32, label: "+" };
adv_button_play = { rel_x: 125, rel_y: 300, w: 150, h: 40, label: "Spin" };
adv_button_play_again = { rel_x: 125, rel_y: 300, w: 150, h: 40, label: "Spin Again" };
adv_button_stop = { rel_x: 125, rel_y: 300, w: 150, h: 40, label: "Stop" };
adv_button_close = { rel_x: 125, rel_y: 300, w: 150, h: 40, label: "Close" };

// 배율 표 패널 정의
payout_table_panel = { rel_x: adv_ui_panel_width - 220, rel_y: 0, w: 200, h: adv_ui_panel_height };




// 내부 닫기 버튼 (UI 패널 내)
button_internal_close = { rel_x: adv_ui_panel_width - 32, rel_y: 0, w: 32, h: 32, label: "" };

/// @function check_button_click(button_struct)
/// @description 주어진 버튼 영역이 클릭되었는지 확인합니다.
function check_button_click(button) {
    return mouse_check_button_pressed(mb_left) && 
           point_in_rectangle(mouse_x, mouse_y, button.x, button.y, button.x + button.w, button.y + button.h);
}

/// @function adv_get_symbol_payout(symbol_index)
/// @description 심볼 인덱스에 해당하는 배율을 반환합니다.
function adv_get_symbol_payout(symbol_index) {
    for (var i = 0; i < array_length(adv_symbol_payouts); i++) {
        if (adv_symbol_payouts[i].symbol_index == symbol_index) {
            return adv_symbol_payouts[i].payout_multiplier;
        }
    }
    return 0; // 일치하는 심볼이 없을 경우
}
