/// @description oDicemac - Alarm 0 (Reset Game)
// 게임을 다시 시작하거나 UI를 닫을 때 변수를 초기 상태로 되돌립니다.

state = DiceMachineState.BETTING;
dice_result = 1;
result_message = "";
roll_timer = 0;
applied_artifact_this_turn = noone;
reroll_used_this_turn = false;
reroll_enabled = false;

// 확률 초기화
array_copy(dice_probs, 0, dice_probs_default, 0, array_length(dice_probs_default));