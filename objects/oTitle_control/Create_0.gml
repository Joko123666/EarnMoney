/// @description Initialize Buttons

// An array to hold all button information
buttons = [
	// Start Game Button
	{
		label: "Start Game",
		x: room_width / 2,
		y: room_height / 2,
		width: 200,
		height: 50,
		action: function() {
			// Example: Go to the main game room
			room_goto(Mainmenu);
		}
	},
	// Quit Game Button
	{
		label: "Quit",
		x: room_width / 2,
		y: room_height / 2 + 60,
		width: 200,
		height: 50,
		action: function() {
			// Quit the game
			game_end();
		}
	}
];

// Variable to track which button is being hovered over
hovered_button = -1;