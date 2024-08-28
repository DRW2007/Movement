extends CharacterBody2D

@export_group("Movement Variables")
@export var max_speed : float
@export var acceleration : float
@export var jump_force : float

@export_group("Frame Timers")
@export var coyote_frames : int
@export var buffer_frames : int


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()





func get_acceleration():
	return

func get_friction():
	return

func can_jump():
	return
