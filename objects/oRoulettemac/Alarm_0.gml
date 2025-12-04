/// @description oRoulettemac - Alarm 0 (Reset Game)
// 게임을 다시 시작하거나 UI를 닫을 때 변수를 초기 상태로 되돌립니다.

state = RouletteState.BETTING;
roulette_speed = 0;
result_number = 0;
result_message = "";
applied_artifact_this_turn = noone;

// 룰렛 각도는 굳이 초기화하지 않아도 자연스럽지만, 원한다면 초기화:
// roulette_angle = 0;