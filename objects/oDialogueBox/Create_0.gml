/// @description 대화 상자 초기화 (dialogue_system_code.txt 기반)

// 한글 주석: 대화 내용, 초상화, 이름 변수를 외부에서 설정할 수 있도록 초기화합니다.
dialogue_text = "대사 없음";
portrait_sprite = -1;
demon_name = "이름 없음";

// 한글 주석: 대화창의 크기 및 위치를 설정합니다.
box_width = 800;
box_height = 200;
box_x = (display_get_gui_width() - box_width) / 2;
box_y = display_get_gui_height() - box_height - 20;

// 한글 주석: 텍스트 타이핑 효과를 위한 변수입니다.
display_text = ""; // 화면에 실제로 그려질 텍스트
text_progress = 0;
text_speed = 0.5;