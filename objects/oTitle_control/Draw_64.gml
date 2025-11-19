/// @description Draw the Buttons

// Set text alignment and font for drawing
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
// Make sure you have a font named 'font_main' or change this to a font you have
draw_set_font(font_main);

// Loop through and draw each button
for (var i = 0; i < array_length(buttons); i++;) {
    var btn = buttons[i];
    
    // Determine colors based on hover state
    var text_color = c_white;
    var border_color = c_white;
    
    if (i == hovered_button) {
        border_color = c_yellow; // Highlight border when hovered
    }
    
    // Draw button background
    draw_set_color(c_dkgray);
    draw_rectangle(btn.x - btn.width / 2, btn.y - btn.height / 2, btn.x + btn.width / 2, btn.y + btn.height / 2, false);
    
    // Draw button border
    draw_set_color(border_color);
    draw_rectangle(btn.x - btn.width / 2, btn.y - btn.height / 2, btn.x + btn.width / 2, btn.y + btn.height / 2, true);
    
    // Draw button text
    draw_set_color(text_color);
    draw_text(btn.x, btn.y, btn.label);
}

// Reset drawing settings to default
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);