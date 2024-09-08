extends CharacterBody2D

@export_group("Movement Variables")
@export var max_speed : float
@export var acceleration : float

@export_group("Jump Variables")
@export var jump_height : float
@export var time_to_peak : float
@export var time_to_descent : float

@export_group("Frame Timers")
@export var coyote_frames : int
@export var buffer_frames : int

@onready var coyote_timer : int = 0
@onready var jump_buffer_timer : int = 0

#Jump Calculations
@onready var upwards_gravity : float = (2.0*jump_height)/(time_to_peak*time_to_peak)
@onready var jump_velocity : float = -1.0 * (upwards_gravity * time_to_peak)

@onready var downwards_gravity : float = (2.0 * jump_height)/(time_to_descent*time_to_descent)

const SPEED = 300.0


func _physics_process(delta):
	#Decriment buffer
	jump_buffer_timer -= 1
	
	#Coyote Timer and Gravity
	if is_on_floor():
		coyote_timer = coyote_frames
	else:
		#Apply Gravity
		coyote_timer -= 1
		velocity += Vector2(0,1) * (get_current_gravity() * delta)
	
	# Handle jump.
	if Input.is_action_just_pressed("jumpKB"):
		jump_buffer_timer = buffer_frames
	
	if Input.is_action_just_released("jumpKB") && velocity.y < 0:
		velocity.y *= 0.3
	
	if can_jump() && jump_buffer_timer > 0:
		velocity.y = jump_velocity
		coyote_timer = 0

	var direction = Input.get_axis("move_leftKB", "move_rightKB")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()



func get_current_gravity():
	if velocity.y < 0:
		return upwards_gravity
	return downwards_gravity

func get_acceleration():
	return

func get_friction():
	if is_on_floor():
		return 0.5
	return 0.1

func can_jump():
	if coyote_timer > 0:
		return true
