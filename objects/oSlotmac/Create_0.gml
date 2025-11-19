/// @description oSlotmac - Create Event (Refactored)
event_inherited();

// --- 상태 정의 ---
enum SlotMachineState {
    IDLE,
    BETTING,
    SPINNING,
	STOPPING_REELS,
    RESULT
}
state = SlotMachineState.IDLE;

// --- 머신 정보 ---
mac_type = "Slot";
game_name = "Slot Machine";

// --- 릴 관련 변수 ---
reels = array_create(3);
for (var i = 0; i < 3; i++) {
    reels[i] = {
        symbols: array_create(10, 0), // 각 릴에 표시될 심볼 목록
        position: 0, // 현재 위치 (y 좌표)
        speed: 0,
        is_stopping: false,
        final_result_index: 0
    };
}
spin_duration = 2.0;
stop_delay = 0.5; // 릴이 순차적으로 멈추는 딜레이
anim_timer = 0;

// --- 심볼 및 배당률 정의 ---
// sSymbol 스프라이트의 프레임 순서와 일치해야 함
// 0:체리, 1:레몬, 2:바, 3:종, 4:다이아, 5:세븐
symbol_payouts = {
    "0": 2,  // 체리
    "1": 3,  // 레몬
    "2": 5,  // 바
    "3": 10, // 종
    "4": 20, // 다이아
    "5": 50  // 세븐
};

// --- 아티팩트 관련 변수 ---
relevant_artifacts = ["Hand_bronze", "Hand_silver", "Hand_gold"]; // 슬롯 전용 아티팩트 없으므로 임시 지정
equipped_artifacts = [];

// --- UI 관련 변수 ---
result_message = "";

// --- 버튼 정의 ---
// Play, Play Again, Bet Up/Down 버튼은 부모에서 상속받음
// 이 게임 전용 버튼만 추가
button_stop = { 
    rel_x: _info_padding, 
    rel_y: _action_btn_y, 
    w: _full_btn_w, 
    h: 55, 
    label: "STOP", 
    sprite: sButton 
};

/// @function initialize_reels()
// 릴의 심볼들을 무작위로 초기화하는 함수
function initialize_reels() {
    for (var i = 0; i < 3; i++) {
        for (var j = 0; j < array_length(reels[i].symbols); j++) {
            reels[i].symbols[j] = irandom(array_length(symbol_payouts) - 1);
        }
    }
}

/// @function check_slot_winnings()
// 슬롯 결과를 확인하고 총 당첨금을 반환하는 함수
function check_slot_winnings() {
    var total_win = 0;
    
    // 가운데 한 줄만 확인
    var s1 = reels[0].symbols[reels[0].final_result_index];
    var s2 = reels[1].symbols[reels[1].final_result_index];
    var s3 = reels[2].symbols[reels[2].final_result_index];

    if (s1 == s2 && s2 == s3) {
        var payout_multiplier = symbol_payouts[$ string(s1)];
        total_win = current_bet * payout_multiplier;
    }
    
    return total_win;
}

// 초기 릴 설정
initialize_reels();