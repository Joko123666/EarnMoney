
/// @description 트리거 완료 처리 (User Event 1)
/// @param trigger_id

var _completed_trigger = argument0;

if (is_waiting_for_trigger && active_trigger_id == _completed_trigger) {
    is_waiting_for_trigger = false;
    active_trigger_id = "";
    
    // 즉시 다음 스텝 진행
    event_user(0);
}
