// 텍스트 타이핑 효과 처리
if (text_progress < string_length(dialogue_text)) {
    text_progress += text_speed;
    display_text = string_copy(dialogue_text, 1, floor(text_progress));
} else {
    display_text = dialogue_text; // 타이핑 완료
}

// 마우스 클릭 또는 키보드 입력으로 대화창 닫기
if (mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_space)) {
    // 텍스트가 다 나오지 않았다면 한번에 보여주기
    if (display_text != dialogue_text) {
        text_progress = string_length(dialogue_text);
    } else {
        // 다 나왔다면 인스턴스 파괴
        instance_destroy();
    }
}