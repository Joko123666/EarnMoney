/// @description 메뉴 상태에 따라 oTraits_popup의 존재를 관리합니다.

if (menu_state == "traits") {
    // '특성창' 상태일 때, oTraits_popup 인스턴스가 없다면 생성합니다.
    if (!instance_exists(oTraits_popup)) {
        instance_create_layer(0, 0, "Instances", oTraits_popup);
    }
} else { // menu_state가 "main"일 때
    // '메인 메뉴' 상태일 때, oTraits_popup 인스턴스가 존재한다면 파괴합니다.
    if (instance_exists(oTraits_popup)) {
        instance_destroy(oTraits_popup);
    }
}
