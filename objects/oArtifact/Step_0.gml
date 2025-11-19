
// ▒ 클릭 이벤트
if (mouse_check_button_pressed(mb_left)) {
    var clicked_popup = false;

    if (popup_visible) {
        // ▒ 구매 클릭
        if (point_in_rectangle(mouse_x, mouse_y, popup_x, popup_y + 20, popup_x + 100, popup_y + 40)) && oGame.Player_money >= price
		{
            oInventory_artifact.add_artifact(artifact_name);
			show_dialogue("buy_artifact");
			oGame.Player_money -= price;
            popup_visible = false;
            clicked_popup = true;
        }

        // ▒ 외부 클릭 시 닫기
        if (!clicked_popup && !point_in_rectangle(mouse_x, mouse_y, popup_x, popup_y, popup_x + 100, popup_y + 40)) {
            popup_visible = false;
        }
    } else {
        // ▒ 새 팝업 열기
        popup_x = mouse_x;
        popup_y = mouse_y;
        popup_visible = true;
    }
}