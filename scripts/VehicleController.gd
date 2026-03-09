extends CharacterBody2D
class_name VehicleBody2D

signal velocity_changed(current_velocity : Vector2) ## Emitted every frame the vehicle is moving.
signal movement_started ## Emitted when the vehicle starts moving from a standstill.
signal movement_stopped ## Emitted when the vehicle comes to a complete stop.
signal boost_started(direction : Vector2) ## Emitted when the boost is activated.
signal boost_ended ## Emitted when the boost effect wears off.

# --- Movement Stats ---
@export var speed = 250.0 ## The base force applied when moving forward.
@export var max_speed = 1000.0 ## The absolute maximum speed the vehicle can reach.
@export_range(0, 1) var acceleration = 0.1 ## How quickly the vehicle reaches max speed.
@export_range(0, 1) var deceleration = 0.05 ## How quickly the vehicle slows down.

# --- Boost Stats ---
@export_group("Boost")
@export var enable_boosting = true ## If true, the vehicle can use the boost maneuver.
@export var boost_force = 1500.0 ## The speed added instantly when boosting.
@export var boost_max_speed_limit = 2500.0 ## The temporary speed cap during boost.
@export var boost_duration = 0.4 ## How long the boost speed lasts in seconds.
@export var boost_cooldown = 2.0 ## Time in seconds before you can boost again.

var is_boosting = false
var can_boost = true
var is_moving_last_frame = false
var current_speed = 0.0

# --- Controls ---
@export_category("Controls")
@export var input_boost = "boost" ## Input action name for boosting.

@export_group("Keyboard")
@export var input_left = "ui_left" ## Input action name for turning left.
@export var input_right = "ui_right" ## Input action name for turning right.
@export var input_backward = "ui_down" ## Input action name for reversing/braking.
@export var input_forward = "ui_up" ## Input action name for moving forward.

func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength(input_right) - Input.get_action_strength(input_left)
	var forward_input = Input.get_action_strength(input_forward)
	var backward_input = Input.get_action_strength(input_backward)
	
	# --- Physics Logic ---
	var effective_max = boost_max_speed_limit if is_boosting else max_speed
	var prev_speed = current_speed
	
	# Apply Input via Lerp for "Weighty" vehicle feel
	if forward_input > 0:
		current_speed = lerp(current_speed, effective_max * forward_input, acceleration)
	elif backward_input > 0:
		current_speed = lerp(current_speed, -max_speed * 0.5 * backward_input, deceleration)
	else:
		current_speed = lerp(current_speed, 0.0, deceleration)
	
	# --- Signal Emission: Movement State ---
	if abs(current_speed) > 0.1 and !is_moving_last_frame:
		movement_started.emit()
		is_moving_last_frame = true
	elif abs(current_speed) <= 0.1 and is_moving_last_frame:
		movement_stopped.emit()
		is_moving_last_frame = false
		current_speed = 0 
		
	# --- Signal Emission: Velocity ---
	if abs(current_speed - prev_speed) > 0.1:
		velocity_changed.emit(velocity)

	# --- Steering Logic ---
	# Harder to turn at high speeds or during boost
	var steering_efficiency = 0.00005 if !is_boosting else 0.00002
	rotation += input_vector.x * steering_efficiency * current_speed
	
	velocity = Vector2.from_angle(rotation) * current_speed
	move_and_slide()

	# --- Boost Trigger ---
	if enable_boosting and Input.is_action_just_pressed(input_boost) and can_boost:
		_execute_boost()

func _execute_boost():
	is_boosting = true
	can_boost = false
	
	# Apply instant physical kick
	current_speed += boost_force 
	
	# Emit the start signal
	boost_started.emit(Vector2.from_angle(rotation))
	
	# Handle Boost Duration
	await get_tree().create_timer(boost_duration).timeout
	is_boosting = false
	boost_ended.emit()
	
	# Handle Cooldown
	await get_tree().create_timer(boost_cooldown).timeout
	can_boost = true
