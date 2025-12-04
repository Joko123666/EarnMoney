/// @description oCupmac - Alarm 0 (Reset Game)
// 게임을 다시 시작하거나 UI를 닫을 때 변수를 초기 상태로 되돌립니다.

// 1. 게임 상태 초기화 (제거됨: 부모 객체에서 IDLE로 설정한 것을 덮어쓰지 않도록 함)
// state = CupGameState.BETTING;

// 2. 게임 변수 초기화
player_choice = -1;
result_message = "";
anim_timer = 0;
applied_artifact_this_turn = noone;

// 3. 컵 위치 및 공 초기화
init_cups();

// 4. 섞기 알람 해제 (만약 섞는 중이었다면 정지)
alarm[1] = -1;