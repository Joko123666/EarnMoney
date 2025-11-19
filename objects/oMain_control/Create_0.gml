/// @description 중단 메뉴 컨트롤러 초기화

// 중단 메뉴 상태 변수
is_paused = false;

// 중단 메뉴 버튼 배열
buttons = [
    {
        label: "계속하기",
        action: function() {
            // 중단 상태 해제
            is_paused = false;
        }
    },
    {
        label: "스테이지 재시작",
        action: function() {
            room_restart(); // 현재 룸 재시작
        }
    },
    {
        label: "스테이지 중단",
        action: function() {
            room_goto(Mainmenu); // 메인 메뉴 룸으로 이동
        }
    },
    {
        label: "게임 종료",
        action: function() {
            game_end(); // 게임 종료
        }
    }
];

// action 함수들의 실행 컨텍스트를 현재 인스턴스(self)로 바인딩
for (var i = 0; i < array_length(buttons); i++) {
    buttons[i].action = method(self, buttons[i].action);
}

// 마우스가 어떤 버튼 위에 있는지 추적하는 변수
hovered_button = -1;

// 보상 대기 상태 변수
reward_pending = false;

// 메인 메뉴에서 "Game Start"를 통해 시작되었는지 확인
if (variable_global_exists("start_with_artifact") && global.start_with_artifact == true) {
    reward_pending = true; // 보상 대기 상태로 설정
    global.start_with_artifact = false; // 변수 초기화
	// 한글 주석: 게임 시작 대사를 출력합니다.
    show_dialogue("start");
}
