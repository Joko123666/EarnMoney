/// @description Handle Mouse Input

// Get mouse coordinates in the GUI layer for accurate UI interaction
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Reset hover state each frame
hovered_button = -1;

// Iterate through buttons to check for interaction
for (var i = 0; i < array_length(buttons); i++;) {
    var btn = buttons[i];
    
    // Calculate button boundaries
    var btn_x1 = btn.x - btn.width / 2;
    var btn_y1 = btn.y - btn.height / 2;
    var btn_x2 = btn_x1 + btn.width;
    var btn_y2 = btn_y1 + btn.height;
    
    // Check if mouse is within the button's area
    if (point_in_rectangle(mx, my, btn_x1, btn_y1, btn_x2, btn_y2)) {
        hovered_button = i;
        
        // Check for a left mouse button click
        if (mouse_check_button_pressed(mb_left)) {
            // Execute the button's action
            btn.action();
        }
        
        // Exit the loop since buttons are not expected to overlap
        break;
    }
}