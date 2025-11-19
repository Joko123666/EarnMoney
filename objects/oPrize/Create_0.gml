/// @description 보상 선택 시스템 변수 초기화

// 한글 주석: 보상 선택 창의 상태를 관리하는 변수
state = "choosing";

// 한글 주석: 선택된 항목과 마우스가 올라간 항목을 저장하는 변수
selected_choice = -1; 
hover_choice = -1;

// 한글 주석: oGame으로부터 받아올 변수들 (Step 이벤트에서 사용됨)
prize_type = -1; 
target_slot = -1;
slots_full = false; // 슬롯이 가득 찼는지 여부
num_of_choices = 2; // 표시할 선택지 개수 (기본값)

// 한글 주석: 화면에 표시할 선택지를 저장할 배열
choices = [];

// 한글 주석: 보상 목록 생성이 완료되었는지 확인하는 플래그
initialized = false;

// 한글 주석: UI 입력 독점 처리
global.ui_blocking_input = true;
global.active_ui_object = id;