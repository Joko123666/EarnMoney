/// @function scr_traits_data()
/// @description Returns the master list of all traits, loaded from traits_data.json.
function scr_traits_data() {
    var _file_path = "traits_data.json";
    if (file_exists(_file_path)) {
        var _file = file_text_open_read(_file_path);
        var _json_string = "";
        while (!file_text_eof(_file)) {
            _json_string += file_text_readln(_file);
        }
        file_text_close(_file);
        
        try {
            var _data = json_parse(_json_string);
            return _data;
        } catch (_exception) {
            show_debug_message("ERROR: Failed to parse traits_data.json: " + _exception.message);
            return [];
        }
    } else {
        show_debug_message("ERROR: traits_data.json not found!");
        return [];
    }
}
