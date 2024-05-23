extends Control

@onready var score_label_player1 = get_node("ScoreLabelPlayer1")
@onready var score_label_player2 = get_node("ScoreLabelPlayer2")
@onready var label_player1 = get_node("LabelPlayer1")
@onready var label_player2 = get_node("LabelPlayer2")
@onready var label_winner = get_node("LabelWinner")
@onready var restart_button = get_node("RestartButton")

# Colors for the active/inactive player labels
var active_player_color = Color(1, 1, 0)  # Yellow
var inactive_player_color = Color(1, 1, 1)  # White

# Function to initialize the UI (e.g., connect signals)
func _ready():
	# Here you would connect the signals from your GameController to the UI
	var game_controller = get_node("../GameController")
	game_controller.connect("score_updated", Callable(self, "_on_score_updated"))
	game_controller.connect("winner_determined", Callable(self, "_on_winner_determined"))
	restart_button.connect("pressed", Callable(self, "_on_restart_button_pressed"))
	
	show_active_player(0)  # Assuming player 1 starts

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

func _on_winner_determined(player_index: int) -> void:
	label_winner.text = "Player %d wins!" % (player_index + 1)
	restart_button.visible = true  # Show the "Restart Game" button
	
func _on_restart_button_pressed() -> void:
	restart_button.visible = false
	get_node("../GameController").restart_game()
	
func hide_restart_button() -> void:
	restart_button.visible = false

func clear_scores() -> void:
	update_score_for_player(0, 0)
	update_score_for_player(1, 0)

func clear_label_winner() -> void:
	label_winner.text = ""

func show_active_player(active_player_index: int):
	if active_player_index == 0:
		label_player1.modulate = active_player_color
		label_player2.modulate = inactive_player_color
	elif active_player_index == 1:
		label_player1.modulate = inactive_player_color
		label_player2.modulate = active_player_color
