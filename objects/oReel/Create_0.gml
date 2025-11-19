
// Create Event
symbol_sheet = sSymbol;
symbol_count = sprite_get_number(symbol_sheet);
symbol_objs = [];

for (var i = 0; i < 6; i++) {
    var yy = y + i * 64;
    var s = instance_create_layer(x, yy, "Instances", oSymbol);
    s.sprite_index = symbol_sheet;
    s.image_index = irandom(symbol_count - 1);
    array_push(symbol_objs, s);
}

stopped = true;
spin_speed = 10;
