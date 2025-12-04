/// @description oUpdownmac - Alarm 0 (Reset Game)
// 게임을 다시 시작하거나 UI를 닫을 때 변수를 초기 상태로 되돌립니다.

state = UpdownMachineState.BETTING;
player_choice = -1;
dice1_value = 1;
dice2_value = 1;
dice_sum = 0;
result_message = "";
anim_timer = 0;
reveal_timer = 0;
reveal_step = 0;
dice1_scale = dice_default_scale;
dice2_scale = dice_default_scale;
applied_artifact_this_turn = noone;