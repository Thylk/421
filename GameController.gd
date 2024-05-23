extends Node3D

class Player:
	var dice_values = {}  # Holds die instance ID as key and rolled value as value

var players = [Player.new(), Player.new()]  # Create two player instances
var current_player_index = 0
var target_values = [1, 2, 4]  # Desired values
var expected_dice_count = 3  # Total number of dice you expect to roll
var game_over = false
@onready var dice_nodes = get_tree().get_nodes_in_group("dice")
@onready var ui = get_node("../UserInterface")

signal score_updated(player_index, amount)
signal winner_determined(player_index)

# Called when the node enters the scene tree for the first time.
func _ready():
	for die_node in dice_nodes:
		die_node.connect("roll_finished", Callable(self, "_on_roll_finished"))

func _input(event):
	if event.is_action_pressed("ui_accept"):
		roll_dice()
	if event.is_action_pressed("ui_cancel"):
		ui.show_active_player(current_player_index)
		players[current_player_index].dice_values.clear()
		reset_dice()

func _on_roll_finished(die_id, value):
	var current_player = players[current_player_index]
	current_player.dice_values[die_id] = value

	# Check if all dice have reported their values
	if len(current_player.dice_values) == expected_dice_count:
		check_dice_values()
		if (game_over == false):
			pass_turn_to_next_player()

func _on_winner_determined(player_index) -> void:
	game_over = true

func check_dice_values():
	var current_player = players[current_player_index]
	var rolled_values = current_player.dice_values.values()
	rolled_values.sort()
	
	# Check if the rolled values are the same as the target values
	if rolled_values == target_values:
		print("Player %d rolled 4, 2, and 1!" % (current_player_index + 1))
		emit_signal("winner_determined", current_player_index)
	else:
		print("Player %d rolled: %s" % [(current_player_index + 1), str(rolled_values)])
		# Calculate and emit the sum of rolled values
		var sum_of_rolled_values = 0
		for value in rolled_values:
			sum_of_rolled_values += value
		emit_signal("score_updated", current_player_index, sum_of_rolled_values)
	
	# Clear the dice values after scoring
	current_player.dice_values.clear()

func pass_turn_to_next_player():
	if game_over:
		return  # Ignore if the game is over
	current_player_index = (current_player_index + 1) % players.size()

func restart_game() -> void:
	game_over = false
	current_player_index = 0
	for player in players:
		player.dice_values.clear()
	ui.hide_restart_button()
	ui.clear_scores()
	ui.clear_label_winner()
	ui.show_active_player(current_player_index)
	reset_dice()

func reset_dice():
	for die in dice_nodes:
		die.reset()  # Call reset function on each die in your game

func roll_dice():
	for die in dice_nodes:
		if die.is_rollable:
			die.roll()
