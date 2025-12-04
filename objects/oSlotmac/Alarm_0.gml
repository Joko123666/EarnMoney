/// @description oSlotmac - Alarm 0 (Reset Game)
// 게임을 다시 시작하거나 UI를 닫을 때 변수를 초기 상태로 되돌립니다.

state = SlotMachineState.BETTING;
result_message = "";
anim_timer = 0;
applied_artifact_this_turn = noone;

// 릴 초기화
initialize_reels();
for (var i = 0; i < 3; i++) {
    reels[i].speed = 0;
    reels[i].is_stopping = false;
    reels[i].position = 0;
}