/// @description oCupmac - Create Event (Shell Game)
event_inherited();

randomize();

// 컵 게임 상태 열거형
enum CupGameState {
    IDLE, BETTING, SETUP, SHUFFLING, CHOOSING, REVEAL, RESULT
}

state = CupGameState.IDLE;

// 머신 타입 및 이름 설정
mac_type = "Cup";
game_name = "Cup Game";

// --- 핵심 게임 변수 ---
payout_rate = 3;
payout_rate_default = 3; // 기본 배당률
player_choice = -1;
result_message = "";
cup_count = 3;
cups = array_create(cup_count);

// --- 아티팩트 관련 변수 ---
relevant_artifacts = [
    // Cup Artifacts
    "Cup_wood", "Cup_iron", "Cup_gold", "Cup_glass", "Cup_spiral", "Cup_blood", "Cup_black",
    // Ball Artifacts
    "Ball_bronze", "Ball_silver", "Ball_gold", "Ball_glass", "Ball_blood", "Ball_bearing", "Ball_massage", "Ball_black"
];
equipped_artifacts = [];

// --- 애니메이션 & 타이밍 ---
animation_timer = 0;
setup_duration = 1.0 * room_speed;
shuffle_duration = 2.5 * room_speed;
shuffle_interval = 0.2 * room_speed;
reveal_duration = 1.5 * room_speed;

// --- 버튼 레이아웃 정의 (부모의 상대 좌표 시스템 활용) ---
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

// 컵 선택 버튼 (베팅 버튼 아래에 위치)
var _choice_btn_y = _bet_btn_y + _btn_h + 15;
var _choice_btn_w = (_full_btn_w - 10) / 3; // 3개 버튼, 간격 5px * 2
var _choice_btn_h = 50;

button_cup_1 = { 
    rel_x: _info_padding, 
    rel_y: _choice_btn_y, 
    w: _choice_btn_w, 
    h: _choice_btn_h, 
    label: "1", 
    sprite: sButton 
};
button_cup_2 = { 
    rel_x: _info_padding + _choice_btn_w + 5, 
    rel_y: _choice_btn_y, 
    w: _choice_btn_w, 
    h: _choice_btn_h, 
    label: "2", 
    sprite: sButton 
};
button_cup_3 = { 
    rel_x: _info_padding + (_choice_btn_w + 5) * 2, 
    rel_y: _choice_btn_y, 
    w: _choice_btn_w, 
    h: _choice_btn_h, 
    label: "3", 
    sprite: sButton 
};

// 컵 위치 초기화 함수
function init_cups() {
    var _game_screen_x = panel_x + 20;
    var _game_screen_y = panel_y + 60;
    var _game_screen_w = panel_w - info_panel_width - 50;
    var _game_screen_h = panel_h - 80;
    var _game_cx = _game_screen_x + _game_screen_w / 2;
    var _game_cy = _game_screen_y + _game_screen_h / 2;
    var _cup_spacing = 200;

    for (var i = 0; i < cup_count; i++) {
        var _x = _game_cx + (i - (cup_count - 1) / 2) * _cup_spacing;
        var _y = _game_cy;
        cups[i] = {
            id: i,
            x: _x, y: _y, start_x: _x, start_y: _y, target_x: _x, target_y: _y,
            has_ball: (i == floor(cup_count / 2)) // 공을 가운데 컵에 둠
        };
    }
}

init_cups();

// 미구현 아티팩트 메모
// Cup_ice: 컵 개수 변경 로직이 복잡하여 제외
// Cup_battary: 금액 저장/사용 로직 필요하여 제외
// Ball_7: 스택 시스템 필요하여 제외