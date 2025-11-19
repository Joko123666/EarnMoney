
// Step Event
if (!stopped) {
    for (var i = 0; i < array_length(symbol_objs); i++) {
        symbol_objs[i].y += spin_speed;
        if (symbol_objs[i].y > y + 64 * 6) {
            symbol_objs[i].y -= 64 * 6;
            symbol_objs[i].image_index = irandom(symbol_count - 1);
        }
    }
}

function start_spin() {
    stopped = false;
}

function force_stop() {
    stopped = true;
}

function get_3_symbols() {
    var center_y = y + 64;
    var result = [];
    for (var j = 0; j < 3; j++) {
        var closest = noone;
        var min_diff = 99999;
        for (var i = 0; i < array_length(symbol_objs); i++) {
            var target_y = center_y + (j - 1) * 64;
            var dy = abs(symbol_objs[i].y - target_y);
            if (dy < min_diff) {
                min_diff = dy;
                closest = symbol_objs[i];
            }
        }
        array_push(result, closest.image_index);
    }
    return result;
}
