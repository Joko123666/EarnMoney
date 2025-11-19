/// @description oDicemac - Create Event
event_inherited();

// 게임 상태를 관리하기 위한 열거형(enum) 정의
enum DiceMachineState {
    IDLE,      // 플레이어의 클릭을 기다리는 기본 상태
    BETTING,   // 판돈을 조절하고 플레이를 시작하는 상태
    ROLLING,   // 주사위를 굴리는 애니메이션 상태
	SETTLEMENT, // 결과 정산 및 재도전 여부를 결정하는 상태
    RESULT     // 결과 확인 및 다시 플레이 여부를 결정하는 상태
}

// 상태 변수 초기화
state = DiceMachineState.IDLE;

// 머신 타입 및 이름 설정
mac_type = "Dice";
game_name = "Dice Game";

// 주사위 게임 관련 변수
dice_result = 1;
is_rolling = false;
roll_animation_time = 1.5;
roll_timer = 0;
reward_rates = array_create(6, 0);
reward_rates[5] = 6; // 6이 나오면 6배
target_number = 6;
payout_rate = 1;
dice_probs_default = [1/6, 1/6, 1/6, 1/6, 1/6, 1/6]; // 기본 주사위 확률
dice_probs = array_create(array_length(dice_probs_default)); // 현재 주사위 확률 (아티팩트에 따라 변경될 수 있음)
for (var i = 0; i < array_length(dice_probs_default); i++) {
    dice_probs[i] = dice_probs_default[i];
}

// 아티팩트 관련 변수
relevant_artifacts = ["Dice_low", "Dice_high", "Dice_copper", "Dice_silver", "Dice_gold", "Dice_bone", "Dice_one", "Dice_iron"];
equipped_artifacts = [];
reroll_used_this_turn = false; // "Dice_iron" 아티팩트 재도전 사용 여부

// UI 관련 변수
result_message = "";

// --- 버튼 레이아웃 정의 (부모의 상대 좌표 시스템 활용) ---
// 부모(oMacs_parent)에서 대부분의 버튼(bet, play, close)이 정의됩니다.
// 여기서는 이 게임에만 필요한 버튼을 추가로 정의합니다.

// Play Again 버튼은 Play 버튼과 동일한 위치와 크기를 사용합니다.
button_play_again = { 
    rel_x: _info_padding, 
    rel_y: _action_btn_y, 
    w: _full_btn_w, 
    h: 55, 
    label: "Play Again", 
    sprite: sButton 
};

// 재도전 및 정산 버튼 (분할될 경우)
var _reroll_btn_w = (_full_btn_w - 5) / 2; // 전체 너비에서 간격 5를 빼고 2로 나눔
button_reroll = { 
    rel_x: _info_padding, 
    rel_y: _action_btn_y, 
    w: _reroll_btn_w, 
    h: 47, 
    label: "Reroll", 
    sprite: sButton 
};
button_settle = { 
    rel_x: _info_padding + _reroll_btn_w + 5, 
    rel_y: _action_btn_y, 
    w: _reroll_btn_w, 
    h: 47, 
    label: "Settle", 
    sprite: sButton 
};

// 정산 버튼 (전체 너비)
button_settle_full = { 
    rel_x: _info_padding, 
    rel_y: _action_btn_y, 
    w: _full_btn_w, 
    h: 47, 
    label: "Settle", 
    sprite: sButton 
};

// 가중치 기반 주사위 굴리기 함수
roll_weighted = function(probs_array) {
    var total_prob = 0;
    var i;
    for (i = 0; i < array_length(probs_array); i++) {
        total_prob += probs_array[i];
    }
    var roll = random(total_prob);
    var cumulative_prob = 0;
    for (i = 0; i < array_length(probs_array); i++) {
        cumulative_prob += probs_array[i];
        if (roll < cumulative_prob) {
            return i + 1;
        }
    }
    return array_length(probs_array);
}


