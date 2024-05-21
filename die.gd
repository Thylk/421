extends RigidBody3D

var start_pos
var roll_strength = 30
var markers = []

signal roll_finished(value)

# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos = global_position
	# Add your marker nodes to the array
	for i in range(1,7):
		markers.append(get_node(str(i)))

func _input(event):
	if event.is_action_pressed("ui_accept"):
		_roll()

func _roll():
	#Reset state
	sleeping = false
	freeze = false
	transform.origin = start_pos
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	
	# Random rotation
	transform.basis = Basis(Vector3.RIGHT, randf_range(0, 2 * PI)) * transform.basis
	transform.basis = Basis(Vector3.UP, randf_range(0, 2 * PI)) * transform.basis
	transform.basis = Basis(Vector3.FORWARD, randf_range(0, 2 * PI)) * transform.basis
	
	var throw_vector = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
	angular_velocity = throw_vector * roll_strength / 2
	apply_central_impulse(throw_vector * roll_strength)
	
func get_upward_facing_value():
	var highest_marker_index = -1
	var highest_y = -INF  # Start with negative infinity

	for i in range(markers.size()):
		var marker_global_Y = markers[i].global_transform.origin.y
		if marker_global_Y > highest_y:
			highest_y = marker_global_Y
			highest_marker_index = i

	# Assuming marker names correlate with face values directly
	return highest_marker_index + 1
	
func _integrate_forces(state):
	# Check if the die has come to rest
	if linear_velocity.length() < 0.01 and angular_velocity.length() < 0.01:
		# Die is considered resting, get the upward facing value
		var upward_value = get_upward_facing_value()
		emit_signal("roll_finished", get_instance_id(), upward_value)
		sleeping = true  # Put the die to sleep to stop processing forces

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
