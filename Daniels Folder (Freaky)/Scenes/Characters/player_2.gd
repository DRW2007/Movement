extends CharacterBody2D

var player_index : int = -1
var action_key : String = ""
##The CharacterStatsResource that determines the movement, jump, and buffer variables for the player
@export var csr : CharacterStatsResource 

@onready var max_speed := csr.max_speed
@onready var ground_acceleration := csr.ground_acceleration
@onready var air_acceleration := csr.air_acceleration

@onready var jump_height := csr.jump_height
@onready var time_to_peak := csr.time_to_peak
@onready var time_to_descent := csr.time_to_descent

@onready var shorthop_percentage = csr.shorthop_percentage

@onready var coyote_frames = csr.coyote_frames
@onready var buffer_frames = csr.buffer_frames

@onready var coyote_timer : int = 0
@onready var jump_buffer_timer : int = 0

#Jump Calculations
@onready var upwards_gravity : float = (2.0*jump_height)/(time_to_peak*time_to_peak)
@onready var jump_velocity : float = -1.0 * (upwards_gravity * time_to_peak)

@onready var downwards_gravity : float = (2.0 * jump_height)/(time_to_descent*time_to_descent)


var direction = 0
var jump_held : bool = false
var facing_right : bool = true

func _ready():
	if player_index == -1:
		print("OH GOD OH NO PLEASE")
	elif player_index == 0:
		action_key = "KB"
		print("Keyboard Connected!")
	elif player_index == -2:
		action_key = "0"
		print("Controller 0 Connected!")
	else:
		action_key = "_joy"
		print("Controller " + str(player_index) + " connected (not 0)")
	

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
	
	#Handle Jump
	if can_jump() && jump_buffer_timer > 0:
		velocity.y = jump_velocity
		coyote_timer = 0
		
		#Handle shorthop with input buffer
		if not jump_held:
			velocity.y *= shorthop_percentage
	if direction:
		#If the player is holding left
		if direction < 0:
			#If the Velocity and direction are opposite ways
			if velocity.x * direction < 0:
				velocity.x += get_acceleration() * direction * 2
			#If the velocity is less than the max speed in that direction, speed them up to the max speed
			elif velocity.x > -1 * max_speed:
				velocity.x = max(velocity.x + (get_acceleration() * direction), -1 * max_speed)
			#If the velocity is more than the max speed in that direction, slow them down less
			else:
				velocity.x = move_toward(velocity.x, 0, get_friction() * get_acceleration()/4)
		#If the player is holding right
		if direction > 0:
			#If the Velocity and direction are opposite ways
			if velocity.x * direction < 0:
				velocity.x += get_acceleration() * direction * 2
			#If the velocity is less than the max speed in that direction, speed them up to the max speed
			elif velocity.x < max_speed:
				velocity.x = min(velocity.x + (get_acceleration() * direction), max_speed)
			#If the velocity is more than the max speed in that direction, slow them down less
			else:
				velocity.x = move_toward(velocity.x, 0, get_friction() * get_acceleration()/4)
	#If the player is NOT holding left or right, slow them down by ACCELERATION/2
	else:
		velocity.x = move_toward(velocity.x, 0, get_acceleration()/2)
	print(scale)
	
	move_and_slide()

func _input(event):
	#Doesnt read inputs for other devices. Second statement lets the device 0 controller go through
	if event.device != player_index and player_index != -2:
		return
	
	#Sets jump buffer for jump handling
	if Input.is_action_just_pressed("jump" + action_key):
		jump_held = true
		jump_buffer_timer = buffer_frames
	
	#Shorthop 
	if Input.is_action_just_released("jump" + action_key):
		jump_held = false
		if velocity.y < 0:
			velocity.y *= shorthop_percentage
	
	direction = Input.get_axis("move_left" + action_key, "move_right" + action_key)
	
	if direction > 0 and not facing_right:
		print(" right")
		facing_right = true
		scale = Vector2(-1,1)
	elif direction < 0 and facing_right:
		print(" left")
		facing_right = false
		scale = Vector2(-1,1)
	
	if Input.is_action_just_pressed("light_attack" + action_key):
		print("Attack " + str(player_index))
		for body in $Area2D.get_overlapping_bodies():
			if body is CharacterBody2D and body != self:
				body.velocity = Vector2(100 ,-1.0 * (body.upwards_gravity * body.time_to_peak))
				print(body)
	
	#print("Device " + str(event.device) + " sent from " + action_key)

func get_current_gravity():
	if velocity.y < 0:
		return upwards_gravity
	return downwards_gravity

func get_acceleration():
	if is_on_floor():
		return ground_acceleration
	return air_acceleration

func get_friction():
	if is_on_floor():
		return 0.5
	return 0.1

func can_jump():
	if coyote_timer > 0:
		return true
