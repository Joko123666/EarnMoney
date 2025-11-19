/// @description oUI_money - Step Event

// 한글 주석: oGame 오브젝트가 존재하는지 확인합니다.
if (instance_exists(oGame)) {
	
	// --- 실제 돈(Player_money)의 변화 감지 ---
	// 한글 주석: 저장된 마지막 돈과 현재 돈이 다르면 변화가 발생한 것입니다.
    if (oGame.Player_money != last_known_player_money) {
		// 한글 주석: 변화량을 계산합니다.
        change_amount = oGame.Player_money - last_known_player_money;
		// 한글 주석: 애니메이션을 처음부터 다시 시작하도록 변수를 초기화합니다.
        change_alpha = 1.5; // 1보다 크게 주어 잠시 머물다 사라지게 함
        change_y_offset = change_y_offset_start;
		// 한글 주석: 현재 돈을 마지막 돈으로 기록하여 다음 변화를 감지할 수 있게 합니다.
        last_known_player_money = oGame.Player_money;
    }

	// --- 돈 증감 연출 (보간) ---
    // 한글 주석: 화면에 표시되는 돈(display_money)이 실제 돈(Player_money)을 부드럽게 따라가도록 합니다.
    display_money = lerp(display_money, oGame.Player_money, 0.1);

    // 한글 주석: 표시되는 값과 실제 값이 아주 가까워지면(0.01 미만) 그냥 같게 만들어 불필요한 연산을 줄입니다.
    if (abs(display_money - oGame.Player_money) < 0.01) {
        display_money = oGame.Player_money;
    }
}

// --- 금액 변화량 애니메이션 처리 ---
// 한글 주석: 변화량 텍스트의 알파값(투명도)이 0보다 크면 애니메이션을 진행합니다.
if (change_alpha > 0) {
	// 한글 주석: 텍스트가 위로 떠오르는 효과를 줍니다.
    change_y_offset -= 0.5;
	// 한글 주석: 텍스트가 서서히 사라지게 합니다.
    change_alpha -= 0.02;
} else {
    change_alpha = 0; // 알파값이 음수가 되지 않도록 0으로 고정
}
