/// @description oUI_money - Create Event

// 한글 주석: oGame 오브젝트가 존재할 때만 초기화합니다.
if (instance_exists(oGame)) {
    // 한글 주석: 화면에 표시될 돈입니다. oGame.Player_money의 실제 값을 부드럽게 따라갑니다.
    display_money = oGame.Player_money;
	// 한글 주석: 실제 돈의 마지막 값을 저장하여 변화를 감지하는 데 사용합니다.
	last_known_player_money = oGame.Player_money;
} else {
    // 한글 주석: oGame이 없으면 0으로 시작합니다.
    display_money = 0;
	last_known_player_money = 0;
}

// --- 금액 변화량 표시 애니메이션 변수 ---

// 한글 주석: 표시할 금액의 변화량 (예: +100, -50)
change_amount = 0;
// 한글 주석: 변화량 텍스트의 투명도 (0.0 ~ 1.0). 0이면 보이지 않습니다.
change_alpha = 0;
// 한글 주석: 변화량 텍스트의 시작 Y 좌표 오프셋.
change_y_offset_start = -20;
// 한글 주석: 변화량 텍스트의 현재 Y 좌표 오프셋.
change_y_offset = change_y_offset_start;
