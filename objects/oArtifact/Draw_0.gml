
switch(artifact_name)
{
	case "Coin_skull" :	draw_sprite(sArtifact, 0, x, y);
	break;
	case "Coin_angel" :	draw_sprite(sArtifact, 1, x, y);
	break;
	case "Coin_gold" :	draw_sprite(sArtifact, 2, x, y);
	break;
	case "Crystal_cyan" :	draw_sprite(sArtifact, 3, x, y);
	break;
}


// ▒ Draw Event - 구매 팝업 표시
if (popup_visible) {
    draw_text(popup_x, popup_y, artifact_name + " 가격: " + string(price));
    draw_text(popup_x, popup_y + 20, "구매하기");
}
