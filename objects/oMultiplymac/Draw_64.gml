/// @description Insert description here
// You can write your code in this editor

if (show_buttons)
{
    draw_set_font(mainfont);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Draw Numbers
    draw_text(x - 50, y - 50, string(left_number));
    draw_text(x, y - 50, "X");
    draw_text(x + 50, y - 50, string(right_number));

    // Draw Bet amount
    draw_text(x, y + 20, "Bet: " + string(bet));

    // Draw Payout
    if (state == "payout")
    {
        draw_text(x, y + 50, "Win: " + string(payout));
    }

    // Draw Buttons
    for (var i = 0; i < array_length(button_text); i++)
    {
        button_x[i] = x + (i * 100) - 50; // Adjust position
        button_y[i] = y + 100;
        draw_circle(button_x[i], button_y[i], button_radius, true);
        draw_text(button_x[i], button_y[i], button_text[i]);
    }
}
