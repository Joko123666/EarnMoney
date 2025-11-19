/// @function check_button_click(button_struct, base_x, base_y)
/// @description Checks if a UI button is clicked. Calculates absolute position from relative coords if needed.
/// @param {struct} button_struct The button struct with position, size, and label.
/// @param {real} base_x The base X coordinate for relative positioning.
/// @param {real} base_y The base Y coordinate for relative positioning.
function check_button_click(button_struct, base_x, base_y) {
    // 구조체가 유효하지 않으면 즉시 false 반환
    if (!is_struct(button_struct)) return false;

    // rel_x, rel_y가 있으면 절대 좌표로 변환, 없으면 기존 x, y 사용
    var _x = variable_struct_exists(button_struct, "rel_x") ? base_x + button_struct.rel_x : button_struct.x;
    var _y = variable_struct_exists(button_struct, "rel_y") ? base_y + button_struct.rel_y : button_struct.y;
    
    return mouse_check_button_pressed(mb_left) && 
           point_in_rectangle(mouse_x, mouse_y, _x, _y, _x + button_struct.w, _y + button_struct.h);
}


/// @function draw_custom_button(button_struct, sprite, base_x=0, base_y=0)
/// @description Draws a UI button using a button struct. Calculates absolute position from relative coords if needed.
/// @param {struct} button_struct The button struct with position, size, and label.
/// @param {asset.sprite} sprite The sprite to use for the button.
/// @param {real} [base_x=0] The base X coordinate for relative positioning.
/// @param {real} [base_y=0] The base Y coordinate for relative positioning.
function draw_custom_button(button_struct, sprite, base_x=0, base_y=0) {
    // 구조체가 유효하지 않으면 그리지 않음
    if (!is_struct(button_struct)) return;

    // rel_x, rel_y가 있으면 절대 좌표로 변환, 없으면 기존 x, y 사용
    var _x = variable_struct_exists(button_struct, "rel_x") ? base_x + button_struct.rel_x : button_struct.x;
    var _y = variable_struct_exists(button_struct, "rel_y") ? base_y + button_struct.rel_y : button_struct.y;
    
    // 버튼 그리기
    draw_sprite_stretched(sprite, 0, _x, _y, button_struct.w, button_struct.h);
    
    // 텍스트 그리기
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(_x + button_struct.w / 2, _y + button_struct.h / 2, button_struct.label);
}


/// @function apply_artifacts(trigger, context)
/// @description Applies all relevant artifact effects for a given trigger and returns a list of applied artifact names.
/// @param {string} trigger The event that occurred (e.g., "ON_ROUND_START").
/// @param {struct} context A struct with context-specific data (e.g., { machine: id, bet: current_bet }).
/// @return {array} An array of names of the artifacts that were applied.
function apply_artifacts(trigger, context) {
    var _machine = context.machine;
    if (!instance_exists(_machine)) return [];

    var applied_ids = []; // 발동된 아티팩트의 이름을 저장할 배열

    // 머신에 장착된 아티팩트 목록을 순회합니다.
    for (var i = 0; i < array_length(_machine.equipped_artifacts); i++) {
        var _artifact = _machine.equipped_artifacts[i];
        if (!is_struct(_artifact)) continue;
        
        // 아티팩트의 트리거가 현재 발생한 이벤트와 일치하는지 확인합니다.
        if (variable_struct_exists(_artifact, "trigger") && _artifact.trigger == trigger) {
            var applied = false; // 이 아티팩트가 적용되었는지 여부
            
            // 아티팩트 이름에 따라 하드코딩된 효과 적용
            switch (_artifact.name) {
                // --- ON_ROUND_START ---
                case "Coin_copper": oGame.Player_money += 1; applied = true; break;
                case "Coin_silver": oGame.Player_money += 2; applied = true; break;
                case "Coin_gold": oGame.Player_money += 3; applied = true; break;
                case "Coin_devil": 
                    _machine.payout_rate += 1;
                    _machine.heads_probability -= 0.2;
                    applied = true;
                    break;
                case "Coin_angel": 
                    _machine.heads_probability += 0.1;
                    applied = true;
                    break;
                case "Dice_copper": oGame.Player_money += 1; applied = true; break;
                case "Dice_silver": oGame.Player_money += 2; applied = true; break;
                case "Dice_gold": oGame.Player_money += 3; applied = true; break;
                case "Dice_bone": _machine.payout_rate *= 1.5; applied = true; break;
                case "Cup_wood": oGame.Player_money += 1; applied = true; break;
                case "Cup_iron": oGame.Player_money += 2; applied = true; break;
                case "Cup_gold": oGame.Player_money += 3; applied = true; break;
                case "Ball_bronze": oGame.Player_money += 3; applied = true; break;
                case "Ball_silver": oGame.Player_money += 5; applied = true; break;
                case "Ball_gold": oGame.Player_money += 8; applied = true; break;
                case "Ball_glass": _machine.payout_rate += 0.5; applied = true; break;
                case "Card_bronze": oGame.Player_money += 3; applied = true; break;
                case "Card_silver": oGame.Player_money += 6; applied = true; break;
                case "Card_gold": oGame.Player_money += 9; applied = true; break;
                case "Hand_bronze": oGame.Player_money += irandom_range(0, 5); applied = true; break;
                case "Hand_silver": oGame.Player_money += irandom_range(0, 10); applied = true; break;
                case "Hand_gold": oGame.Player_money += irandom_range(0, 15); applied = true; break;
                case "Common_ticket": oGame.chance_last += 1; applied = true; break;

                // --- ON_LOSE ---
                case "Coin_blood": oGame.Player_money += round(context.bet / 2); applied = true; break;
                case "Cup_glass": oGame.Player_money += round(context.bet / 2); applied = true; break;
                case "Ball_blood": oGame.Player_money += round(context.bet / 2); applied = true; break;
                case "Ball_massage": if (random(1) < 0.2) { oGame.Player_money += context.bet; applied = true; } break;
                case "Hand_rock": 
                    if (variable_instance_exists(_machine, "consecutive_losses") && _machine.consecutive_losses >= 3) {
                        oGame.Player_money += 6;
                        applied = true;
                    }
                    break;
                case "Hand_coin":
                     if (variable_instance_exists(_machine, "consecutive_losses") && _machine.consecutive_losses > 0 && _machine.consecutive_losses % 3 == 0) {
                        oGame.lose_token += 1;
                        applied = true;
                    }
                    break;

                // --- ON_WIN ---
                case "Cup_spiral":
                    if (variable_global_exists("consecutive_win")) {
                        oGame.Player_money += context.bet * (global.consecutive_win * 0.1);
                        applied = true;
                    }
                    break;
                case "Ball_bearing":
                    if (variable_global_exists("consecutive_win")) {
                        oGame.Player_money += global.consecutive_win * 3;
                        applied = true;
                    }
                    break;
                case "Card_punch":
                    // This logic is complex and should be handled inside the machine's Step event
                    break;

                // --- ON_RESULT ---
                case "Dice_one":
                    if (variable_struct_exists(context, "dice_sum")) { // Example context check
                        // Assuming context provides individual dice rolls
                        var _dice = context.dice_rolls;
                        for(var k=0; k<array_length(_dice); k++){
                            if(_dice[k] == 1){
                                oGame.Player_money += context.bet;
                                applied = true;
                            }
                        }
                    }
                    break;
                case "Card_ace":
                    if (variable_struct_exists(context, "player_card") && context.player_card == 1) {
                         oGame.Player_money += context.bet;
                         applied = true;
                    }
                    break;
                case "Card_double":
                     if (variable_struct_exists(context, "player_card") && variable_struct_exists(context, "dealer_card") && context.player_card == context.dealer_card) {
                         oGame.Player_money += context.bet;
                         applied = true;
                    }
                    break;
                case "Card_ten":
                     if (variable_struct_exists(context, "player_card") && context.player_card == 10) {
                         global.card_ten_stacks++;
                         applied = true;
                    }
                     if (variable_struct_exists(context, "dealer_card") && context.dealer_card == 10) {
                         global.card_ten_stacks++;
                         applied = true;
                    }
                    break;
                case "Hand_figure":
                    if(variable_struct_exists(context, "hidden_hand")){
                        oGame.Player_money += context.hidden_hand;
                        applied = true;
                    }
                    break;
                case "Hand_V":
                     if(variable_struct_exists(context, "hidden_hand") && context.hidden_hand == 2){
                        oGame.Player_money += round(context.bet / 2);
                        applied = true;
                    }
                    break;
                case "Hand_ironfist":
                     if(variable_struct_exists(context, "hidden_hand") && context.hidden_hand == 0){
                        oGame.Player_money += 5;
                        applied = true;
                    }
                    break;
                case "Common_777":
                     if(variable_struct_exists(context, "result") && context.result == 7){
                        oGame.Player_money += context.bet;
                        applied = true;
                    }
                    break;
            }

            if (applied) {
                array_push(applied_ids, _artifact.name);
            }
        }
    }
    
    return applied_ids; // 발동된 아티팩트 이름들의 배열을 반환합니다.
}