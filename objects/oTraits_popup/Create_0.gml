/// @description 팝업 변수 초기화

// 선택된 특성의 이름을 저장합니다. (없으면 noone)
selected_trait_name = noone;

// 팝업이 표시될 위치 (마우스 클릭 시 동적으로 계산됨)
popup_x = 0;
popup_y = 0;

// UI 레이아웃 설정
padding = 20; // 여백

// 배경 및 테두리 색상
c_background = #222222;
c_border = #EEEEEE;

// 폰트 설정
font_title = fnt_dialogue_name;
font_body = fnt_dialogue_main;

// ESC 키로 창을 닫을 수 있게 합니다.
can_close_with_escape = true;

// 아이콘들의 최종 위치를 저장할 배열. User Event 0에서 계산됩니다.
icon_regions = [];
event_perform(ev_other, ev_user0); // 좌표 계산 이벤트 호출
