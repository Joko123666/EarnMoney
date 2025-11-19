/// @description oCoinmac2 - Create Event
event_inherited();

// 머신 타입 및 이름 설정
mac_type = "Coin";
game_name = "Multiple Coin Game";

// 게임플레이 변수
payout_rate = 1.0;
payout_rate_defalt = 1.0;
heads_probability = 0.5;
heads_probability_defalt = 0.5;
coin_count = 2; // oCoinmac2의 핵심 변수

coin_results = array_create(coin_count, 0);
coin_frame_offsets = array_create(coin_count, 0);
is_tossing = false;
single_coin_toss_duration = 1.2;
toss_delay_per_coin = 0.3; // oCoinmac2의 핵심 변수
toss_timer = 0;
reroll_used_this_turn = false;
needs_stat_recalc = false;

// 아티팩트 관련 변수
relevant_artifacts = ["Coin_copper", "Coin_silver", "Coin_gold", "Coin_iron", "Coin_devil", "Coin_angel", "Coin_blood", "Coin_DDD"];

// UI 변수
result_message = "";
coin_spacing = 16; // 코인 사이 간격

// 상태 정의
enum CoinMachine2State {
    IDLE,      
    BETTING,   
    TOSSING,   
	SETTLEMENT,
    RESULT     
}
state = CoinMachine2State.IDLE;


// --- oCoinmac2 고유 버튼 레이아웃 정의 ---
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
var _reroll_btn_w = (_full_btn_w - 5) / 2;
button_reroll = { 
    rel_x: _info_padding, 
    rel_y: _action_btn_y, 
    w: _reroll_btn_w, 
    h: 47, 
    label: "재도전", 
    sprite: sButton 
};
button_settle = { 
    rel_x: _info_padding + _reroll_btn_w + 5, 
    rel_y: _action_btn_y, 
    w: _reroll_btn_w, 
    h: 47, 
    label: "정산", 
    sprite: sButton 
};

// 정산 버튼 (전체 너비)
button_settle_full = { 
    rel_x: _info_padding, 
    rel_y: _action_btn_y, 
    w: _full_btn_w, 
    h: 47, 
    label: "정산", 
    sprite: sButton 
};



