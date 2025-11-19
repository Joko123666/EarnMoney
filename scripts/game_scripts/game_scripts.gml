



/// @function check_artifact(_name)
/// @description 인벤토리에 특정 아티팩트가 있는지 확인합니다.
/// @param {string} _name - 확인할 아티팩트의 이름
/// @return {boolean} - 아티팩트 존재 여부
function check_artifact(_name)
{
    // oInventory_artifact 인스턴스가 존재하는지 확인
    if (instance_exists(oInventory_artifact)) {
        // oInventory_artifact의 has_artifact 함수를 호출하여 결과 반환
        return oInventory_artifact.has_artifact(_name);
    }
    // 인스턴스가 없으면 false 반환
    return false;
}

/// @function with_artifact_do(artifact_id, action_function)
/// @description 특정 아티팩트가 있다면 주어진 함수를 실행합니다.
/// @param {string} artifact_id - 확인할 아티팩트의 이름
/// @param {function} action_function - 아티팩트가 있을 경우 실행할 함수
function with_artifact_do(artifact_id, action_function) {
    if (check_artifact(artifact_id)) {
        action_function();
    }
}
