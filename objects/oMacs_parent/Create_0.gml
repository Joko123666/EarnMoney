event_inherited();

// 기본 머신 상태 정의 (자식 객체에서 구체화)
enum MacState {
    IDLE,    // 비활성화 상태
    ACTIVE,  // 활성화 및 베팅 상태
    PLAYING, // 게임 진행 중
    RESULT   // 결과 확인
}
state = MacState.ACTIVE;

// 머신 기본 속성 (자식 객체에서 재정의)
mac_type = "Parent";
game_name = "Machine Name";

// 베팅 관련 변수
current_bet = 10;
min_bet = 10;
max_bet = 100;
bet_increment = 10;

// 게임 정보 변수 (자식 객체에서 설정)
payout_rate = 1.0;
win_probability = 0.5;
reroll_available = true; // 재도전 가능 여부 (테스트용)

// 아티팩트 관련 변수
relevant_artifacts = [];
equipped_artifacts = array_create(6, -1); // 6개의 빈 슬롯
artifact_effects = []; // 아티팩트 발동 시각 효과를 관리할 배열
applied_artifact_this_turn = noone; // 이번 턴에 발동된 아티팩트 ID

// 아티팩트에 의해 활성화되는 기능 플래그
reroll_enabled = false; // '다시 굴리기' 기능 활성화 여부


// UI 패널 크기 및 위치
ui_panel_width = 1200;
ui_panel_height = 800;
info_panel_width = 400;

// 화면 중앙에 패널이 위치하도록 계산
panel_x = 200;
panel_y = 30;
panel_w = ui_panel_width;
panel_h = ui_panel_height;

// --- 버튼 레이아웃 정의 (정보 패널 기준 상대 위치) ---
_info_padding = 20;
_btn_h = 50;

// Y 좌표
_bet_section_y = 100;
_bet_btn_y = _bet_section_y + 80;
_action_btn_y = _bet_btn_y + _btn_h + 30;

// 베팅 버튼
_small_btn_w = (info_panel_width - _info_padding * 3) / 2;
button_bet_down = { rel_x: _info_padding, rel_y: _bet_btn_y, w: _small_btn_w, h: _btn_h, label: "-", sprite: sButton };
button_bet_up = { rel_x: _info_padding * 2 + _small_btn_w, rel_y: _bet_btn_y, w: _small_btn_w, h: _btn_h, label: "+", sprite: sButton };

// 행동 버튼
_full_btn_w = info_panel_width - _info_padding * 2;
button_play = { rel_x: _info_padding, rel_y: _action_btn_y, w: _full_btn_w, h: 55, label: "Play", sprite: sButton };

// 닫기 버튼 (절대 좌표)
button_internal_close = { x: panel_x + ui_panel_width - 40, y: panel_y + 15, w: 32, h: 32, label: "", sprite: sButton };
