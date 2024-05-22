extends Node3D

class Player:
	var dice_values = {}  # Holds die instance ID as key and rolled value as value
	var can_roll = true

var players = [Player.new(), Player.new()]  # Create two player instances
var current_player_index = 0
var target_values = [4, 2, 1]  # Desired values
var expected_dice_count = 3  # Total number of dice you expect to roll

signal score_updated(player_index, amount)

# Called when the node enters the scene tree for the first time.
func _ready():
	var dice_nodes = get_tree().get_nodes_in_group("dice") # Assuming you've added all dice to the 'dice' group
	for die_node in dice_nodes:
		die_node.connect("roll_finished", Callable(self, "_on_roll_finished"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func check_dice_values():
	var current_player = players[current_player_index]
	var rolled_values = current_player.dice_values.values()
	rolled_values.sort()
	var sorted_target_values = target_values.duplicate()
	sorted_target_values.sort()
	
	# Check if the rolled values are the same as the target values
	if rolled_values == sorted_target_values:
		print("Player %d rolled 4, 2, and 1!" % current_player_index)
		emit_signal("score_updated", current_player_index, 10)  # Specific bonus score for target pattern
	else:
		print("Player %d did not roll the target values." % current_player_index)
		# Calculate and emit the sum of rolled values
		var sum_of_rolled_values = 0
		for value in rolled_values:
			sum_of_rolled_values += value
		emit_signal("score_updated", current_player_index, sum_of_rolled_values)
	
	# Clear the dice values after scoring
	current_player.dice_values.clear()


func _on_roll_finished(die_id, value):
	var current_player = players[current_player_index]
	
	# Check if it's the current player's turn
	if current_player.can_roll:
		current_player.dice_values[die_id] = value
		
		# Check for a six
		if value == 6:
			# Allow player to re-roll this die
			emit_signal("enable_reroll", die_id)
			return
		
		# Check if all dice have reported their values
		if len(current_player.dice_values) == expected_dice_count:
			check_dice_values()
			current_player.can_roll = false
			pass_turn_to_next_player()
	else:
		print("It's not currently this player's turn.")

func pass_turn_to_next_player():
	current_player_index = (current_player_index + 1) % players.size()
	var next_player = players[current_player_index]
	next_player.can_roll = true
	# Signal to the UI or game logic that the turn has changed
	# update_ui_for_next_player()
