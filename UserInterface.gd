extends Control

@onready var score_label_player1 = get_node("ScoreLabelPlayer1")
@onready var score_label_player2 = get_node("ScoreLabelPlayer2")

# Function to initialize the UI (e.g., connect signals)
func _ready():
	# Here you would connect the signals from your GameController to the UI
	var game_controller = get_node("../GameController")
	game_controller.connect("score_updated", Callable(self, "_on_score_updated"))

func _on_score_updated(player_index: int, amount: int) -> void:
	if player_index == 0:
		var current_score = int(score_label_player1.text.split(" ")[1])
		update_score_for_player(player_index, current_score + amount)
	elif player_index == 1:
		var current_score = int(score_label_player2.text.split(" ")[1])
		update_score_for_player(player_index, current_score + amount)

# Function to update the score for a specific player
func update_score_for_player(player_index: int, new_score: int) -> void:
	var score_label = score_label_player1 if player_index == 0 else score_label_player2
	score_label.text = "Score: %d" % new_score
