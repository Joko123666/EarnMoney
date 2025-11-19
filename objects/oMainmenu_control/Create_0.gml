/// @description 메인 메뉴 초기화

// 메인 메뉴의 상태를 제어하는 변수
menu_state = "main"; // "main"(메인메뉴) 또는 "traits"(특성창)

// 모든 버튼 정보를 담을 배열
buttons = [
    // 게임 시작 버튼
    {
        label: "Game Start",
        x: room_width / 2,
        y: room_height / 2,
        width: 200,
        height: 50,
        action: function() {
            // 게임 시작
			oGame.start_new_game();
			global.start_with_artifact = true;
            room_goto(Game_Main);
        }
    },
    // 특성 버튼
    {
        label: "Traits",
        x: room_width / 2 + 220,
        y: room_height / 2,
        width: 200,
        height: 50,
        action: function() {
            // 특성창 열기
            menu_state = "traits";
        }
    },
    // 업적 버튼
    {
        label: "Achievements",
        x: room_width / 2 - 220,
        y: room_height / 2 - 30,
        width: 200,
        height: 50,
        action: function() {
            // "업적" 서브메뉴 열기
            popup_menu = "Achievements";
        }
    },
	// 기록 버튼
	{
        label: "Records",
        x: room_width / 2 - 220,
        y: room_height / 2 + 30,
        width: 200,
        height: 50,
        action: function() {
            // "기록" 서브메뉴 열기
            popup_menu = "Records";
        }
    },
	// 튜토리얼 버튼
	{
        label: "Tutorial",
        x: 132,
        y: 32,
        width: 200,
        height: 50,
        action: function() {
            // 튜토리얼 룸으로 이동
			oGame.Player_money = 0;
             room_goto(Game_tutorial);
        }
    }
];

// action 함수들의 실행 컨텍스트를 현재 인스턴스(self)로 바인딩합니다.
// 이렇게 해야 action 함수 내에서 menu_state와 같은 인스턴스 변수에 정상적으로 접근할 수 있습니다.
for (var i = 0; i < array_length(buttons); i++) {
	buttons[i].action = method(self, buttons[i].action);
}

// 마우스가 어떤 버튼 위에 있는지 추적하는 변수 (-1은 아무 버튼 위에도 없음을 의미)
hovered_button = -1;

// 팝업 메뉴를 제어하는 변수 (현재는 사용되지 않음)
popup_menu = "";
