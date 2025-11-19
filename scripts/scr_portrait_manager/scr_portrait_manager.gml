/// @func scr_portrait_manager(speaker, state)
/// @param {string} speaker - The name of the speaker.
/// @param {string} state - The emotional state of the speaker.
/// @return {Asset.GMSprite} - The sprite for the portrait.

function scr_portrait_manager(_speaker, _state) {
	// 한글 주석: 이 스크립트는 대화 상대의 이름과 상태에 따라 적절한 초상화 스프라이트를 반환합니다.
	// 현재는 "악. 마남"에 대한 스프라이트만 설정되어 있습니다. 다른 캐릭터를 추가하려면 case를 더하세요.

    switch (_speaker) {
        case "악. 마남":
			// 한글 주석: 상태(state)에 따라 다른 스프라이트를 반환할 수 있습니다.
			// 현재는 sDemonPortrait_Lucian_Half만 있으므로 기본값으로 사용합니다.
			// 예를 들어 sDemonPortrait_Lucian_Shout, sDemonPortrait_Lucian_Smug 같은 스프라이트가 있다면
			// switch(_state) 문을 추가하여 분기할 수 있습니다.
            return sDemonPortrait_Lucian_Half;

        case "???":
            return -1; // 한글 주석: 이름이 "???"일 때는 초상화를 표시하지 않습니다.

        default:
            return -1; // 한글 주석: 그 외의 경우에는 초상화를 표시하지 않습니다.
    }
}


/// @function show_dialogue(situation)
/// @description 현재 악마의 상황에 맞는 대사를 랜덤하게 골라 대화창을 생성합니다.
/// @param {string} situation    대화 상황 (예: "start", "win", "lose")
function show_dialogue(situation) {
    // 현재 활성화된 대화창이 있다면 새로 만들지 않습니다.
    if (instance_exists(oDialogueBox)) {
        return;
    }

    if (global.current_demon != -1 && variable_struct_exists(global.current_demon, "dialogue_sequences")) {
        // 상황에 맞는 대사 시퀀스(배열)를 가져옵니다.
        var _sequence = variable_struct_get(global.current_demon.dialogue_sequences, situation);
        
        if (is_array(_sequence) && array_length(_sequence) > 0) {
            // 대사 목록에서 랜덤한 대사 데이터(구조체) 하나를 선택합니다.
            var _random_index = irandom(array_length(_sequence) - 1);
            var _dialogue_data = _sequence[_random_index];
            
            // 대사 데이터에서 텍스트와 초상화 키를 추출합니다.
            var _text_to_show = _dialogue_data.text;
            var _portrait_key = _dialogue_data.portrait;
            
            // 초상화 키를 사용하여 실제 스프라이트 이름을 찾습니다.
            var _sprite_name = variable_struct_get(global.current_demon.portraits, _portrait_key);
            var _sprite_asset = asset_get_index(_sprite_name);

            // 대화창 오브젝트를 생성하고, 필요한 정보를 넘겨줍니다.
            var _dialogue_instance = instance_create_layer(0, 0, "Instances", oDialogueBox);
            
            // oDialogueBox의 변수에 직접 값을 할당합니다.
            _dialogue_instance.dialogue_text = _text_to_show;
            _dialogue_instance.portrait_sprite = _sprite_asset;
            _dialogue_instance.demon_name = global.current_demon.name;
        }
    }
}