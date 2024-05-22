extends Node3D

var dice_values = {}  # Holds die instance ID as key and rolled value as value
var target_values = [4, 2, 1]  # Desired values
var expected_dice_count = 3  # Total number of dice you expect to roll

signal score_updated(amount)

# Called when the node enters the scene tree for the first time.
func _ready():
	var dice_nodes = get_tree().get_nodes_in_group("dice") # Assuming you've added all dice to the 'dice' group
	for die_node in dice_nodes:
		die_node.connect("roll_finished", Callable(self, "_on_roll_finished"))
	var score_label = get_node("../UserInterface/ScoreLabel") # Change the path to your actual ScoreLabel node path
	score_label.connect("score_updated", Callable(score_label, "_on_score_updated"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func check_dice_values():
	# Convert the dictionary values to a sorted list
	var rolled_values = dice_values.values()
	rolled_values.sort()
	
	# Check if the rolled values are the same as the target values
	if rolled_values == target_values:
		print("The dice rolled 4, 2, and 1!")
	else:
		print("The dice did not roll the target values.")

	emit_signal("score_updated", 3)

	# Clear the previous dice values for future rolls
	dice_values.clear()

func _on_roll_finished(die_id, value):
	print("Die stopped rolling with the upward-facing value of: ", value)
	
	# Track the value reported by the die, using its unique instance ID
	dice_values[die_id] = value

	# Check if all dice have reported their values
	if len(dice_values) == expected_dice_count:
		check_dice_values()
