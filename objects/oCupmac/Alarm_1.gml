/// @description oCupmac - Alarm 1 (Shuffle Cups)
// 원래 Alarm 0에 있던 컵 섞기 로직을 여기로 이동했습니다.
// Alarm 0은 이제 게임 상태 초기화용으로 사용됩니다.

// 컵 섞기 상태가 아니면 실행하지 않음
if (state != CupGameState.SHUFFLING) {
    exit;
}

audio_play_sound(SE_spincup, 1, false);

// 서로 다른 두 개의 컵을 무작위로 선택하여 목표 위치를 교환
var cup1_idx = irandom(cup_count - 1);
var cup2_idx = irandom(cup_count - 1);
while (cup1_idx == cup2_idx) {
    cup2_idx = irandom(cup_count - 1);
}

// 두 컵의 목표 위치를 가져옴
var target1_x = cups[cup1_idx].target_x;
var target2_x = cups[cup2_idx].target_x;

// 목표 위치만 교환. 컵 구조체(와 그 안의 has_ball 속성)는 이제 새로운 위치로 이동하게 됨.
cups[cup1_idx].target_x = target2_x;
cups[cup2_idx].target_x = target1_x;

// 다음 섞기를 위해 알람을 다시 설정
if (state == CupGameState.SHUFFLING) {
    alarm[1] = shuffle_interval; // alarm[0] -> alarm[1]로 변경
}