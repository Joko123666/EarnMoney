/// @description Initialize Button & Popup State

// 버튼 상태
state = "idle"; // "idle", "confirm"
cost = 5;

// 버튼 외형 설정
// sprite_index = sButton; // 에디터에서 설정한 스프라이트 사용
image_speed = 0;
label = "게임 구매";

// 팝업 설정
popup_w = 500;
popup_h = 300;

// 버튼 구조체 (팝업 내 버튼용)
button_yes = { w: 150, h: 50, label: "구매", sprite: sButton };
button_no = { w: 150, h: 50, label: "취소", sprite: sButton };

// 쿨타임 (팝업 열리자마자 클릭 방지)
interact_cooldown = 0;