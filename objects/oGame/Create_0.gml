/// @description oGame 초기화 

// --- 전역 변수 및 게임 설정 ---
// 아티팩트 목록을 JSON 파일에서 로드합니다.
var _artifact_file = file_text_open_read("artifacts.json");
if (_artifact_file != -1) {
    var _json_string = "";
    while (!file_text_eof(_artifact_file)) {
        _json_string += file_text_readln(_artifact_file);
    }
    file_text_close(_artifact_file);
    global.artifact_list = json_parse(_json_string);
} else {
    show_debug_message("!!! CRITICAL ERROR: artifacts.json not found!");
    global.artifact_list = []; // 파일이 없으면 빈 배열로 초기화
}

// --- 미니게임 데이터 로딩 ---
global.minigames_list = [];
var _minigames_file = file_text_open_read("minigames.json");
if (_minigames_file != -1) {
    var _json_string = "";
    while (!file_text_eof(_minigames_file)) {
        _json_string += file_text_readln(_minigames_file);
    }
    file_text_close(_minigames_file);
    global.minigames_list = json_parse(_json_string);
} else {
    show_debug_message("!!! CRITICAL ERROR: minigames.json not found!");
}

script_execute(stage_list);

global.ui_blocking_input = false; // UI가 활성화되어 입력을 막고 있는지 여부
global.active_ui_object = noone; // 현재 활성화된 UI 오브젝트 (입력을 막는 오브젝트)

Player_money = 100;
lose_token = 0;
start_game_state = false;
global.Soulpoint = 10;
player_can_control = true;

global.consecutive_losses = 0;
global.consecutive_win = 0;
global.card_ten_stacks = 0;

// --- 통계 관련 변수 ---
global.session_play_time = 0; // 총 플레이 시간 (초 단위)
global.total_gambles = 0;     // 도박 시도 횟수
global.total_wins = 0;        // 도박 승리 횟수
global.total_losses = 0;      // 도박 패배 횟수
global.max_consecutive_wins = 0;   // 최대 연승 횟수
global.max_consecutive_losses = 0; // 최대 연패 횟수
global.total_earnings = 0;    // 도박으로 번 총 금액


current_stage_index = 1; // 현재 스테이지 추적
target_amount = 200;
chance_last = 10;

// --- 연출 관련 변수 ---
game_over_state = "none"; // "none", "dialogue", "red_screen", "fade_to_black", "show_popup"
game_over_alpha = 0;
game_over_timer = 0;
stage_clear_state = "none"; // "none", "dialogue"

// 라운드 종료 팝업 상태 제어 변수
round_result_confirmed = false;
next_stage_confirmed = false;

// --- 인스턴스 생성 ---

// 한글 주석: oMouse 인스턴스가 없다면 생성합니다.
if (!instance_exists(oMouse)) {
    instance_create_layer(0, 0, "Instances", oMouse);
}
if (!instance_exists(oTraits_manager)) {
    instance_create_layer(0, 0, "Instances", oTraits_manager);
}

// --- 도박 기계 슬롯 설정 ---
// 각 슬롯의 x, y 좌표와 현재 배치된 기계의 인스턴스 ID를 저장합니다.
// 아래 x, y 값을 원하는 좌표로 수정하세요.
mac_slots = [
    { slot_number: 0, x: 440, y: 1120, instance_id: noone },
    { slot_number: 1, x: 736, y: 1120, instance_id: noone },
    { slot_number: 2, x: 1030, y: 1120, instance_id: noone }
];


// --- 악마 데이터 로딩 ---

// 한글 주석: 전역 변수로 악마 데이터와 현재 악마를 저장할 구조체를 초기화합니다.
global.demons_data = -1;
global.current_demon = -1;

// 한글 주석: JSON 파일을 읽어와서 파싱한 후 전역 변수에 저장합니다.
var _json_string = file_text_open_read("demons_data.json");
if (_json_string != -1) {
    var _data = "";
    while (!file_text_eof(_json_string)) {
        _data += file_text_readln(_json_string);
    }
    file_text_close(_json_string);
    
    global.demons_data = json_parse(_data);
} else {
    show_debug_message("ERROR: Could not find demons_data.json!");
}


// --- 게임 시작 함수 ---



/// @function start_new_game()
/// @description 새 게임을 시작하고 초기 설정을 진행합니다.
function start_new_game() {
    // 한글 주석: 기존에 배치된 도박 기계들을 파괴하고 슬롯을 초기화합니다.
    for (var i = 0; i < array_length(mac_slots); i++) {
        if (instance_exists(mac_slots[i].instance_id)) {
            instance_destroy(mac_slots[i].instance_id);
        }
        mac_slots[i].instance_id = noone;
    }

        // 한글 주석: 악마 데이터가 로드되었다면 랜덤 악마를 선택합니다.
	    if (global.demons_data != -1) {
	        var _demon_list = global.demons_data.demons;
	        var _random_index = irandom(array_length(_demon_list) - 1);
	        global.current_demon = _demon_list[_random_index];
			
            // 한글 주석: 첫 번째 스테이지의 데이터를 설정합니다.
			var stage1_data = global.stage_list.Stage1;
			
			// --- 특성 적용: 시작 자금 & 기회 ---
			// start_money: 특성 단계당 첫 스테이지의 시작금액 +10
			var _bonus_money = get_player_trait_level("start_money") * 10;
			Player_money = stage1_data.start_amount + _bonus_money;
			
			// start_losetoken: 특성 단계당 +2
			var _bonus_lt = get_player_trait_level("start_losetoken") * 2;
			lose_token = 0 + _bonus_lt;

			chance_last = stage1_data.chance_count;
			target_amount = stage1_data.target_amount;
			
			
			// --- 연출 관련 변수 초기화 ---
			game_over_state = "none";
			game_over_alpha = 0;
			game_over_timer = 0;
			stage_clear_state = "none";
            round_result_confirmed = false;
            next_stage_confirmed = false;
			
	        start_game_state = true;
	        
	        // 2번 특성(start_choose - 아티팩트 선택)은 구현 보류 (이름 중복 문제 해결 후 적용)
	    }
}

// 게임 시작 시 초기화 함수 실행 (중요: 이 호출이 있어야 global.current_demon이 설정됨)
start_new_game();


/// @function give_prize(prize_type)
/// @description 빈 머신 슬롯을 확인하고 보상 선택 화면을 생성합니다.
/// @param {real} prize_type 보상 유형 (1: 도박 3개, 2: 아티팩트 5개, 3: 아티팩트 4개 + 도박 1개)
function give_prize(_prize_type = 1) { // 기본값을 1로 설정
    var _slots_full = false;
    var _empty_slot_index = -1;

    // 아티팩트 전용 보상이 아닌 경우에만 슬롯을 확인합니다.
    if (_prize_type != 2) {
        // 한글 주석: mac_slots 배열을 순회하며 비어있는 슬롯을 찾습니다.
        for (var i = 0; i < array_length(mac_slots); i++) {
            if (mac_slots[i].instance_id == noone) {
                _empty_slot_index = i;
                break; // 한글 주석: 첫 번째 빈 슬롯을 찾았으므로 반복을 중단합니다.
            }
        }
        
        if (_empty_slot_index == -1) {
            _slots_full = true;
            show_debug_message("WARNING: All machine slots are full.");
        }
    }

    // 한글 주석: oPrize 인스턴스가 없을 때만 생성합니다. (중복 방지)
    if (!instance_exists(oPrize)) {
        var _prize_inst = instance_create_layer(0, 0, "Instances", oPrize);
        _prize_inst.prize_type = _prize_type;
        _prize_inst.target_slot = _empty_slot_index;
        _prize_inst.slots_full = _slots_full;
        
        // --- 특성 적용: stage_choose (스테이지-선택지 추가) ---
        // 이 특성은 oPrize 내부에서 처리하거나, 여기서 oPrize의 변수를 설정해줘야 함.
        // 현재 oPrize 구조를 모르므로 oPrize 수정 시 처리 예정.
    }
}