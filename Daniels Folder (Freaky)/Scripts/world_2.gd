extends Node2D

var player_scene = preload("res://Daniels Folder (Freaky)/Scenes/Characters/player_2.tscn")
var keyboard_spawned = false
var keyboard_player = null

var controller_player_0_spawned = false
var controller_player_0 = null
func _input(event):
	
	if Input.is_action_just_pressed("ui_down"):
		add_child(player_scene.instantiate())
	
	if Input.is_action_just_pressed("jumpKB") and not keyboard_spawned:
		keyboard_spawned = true
		keyboard_player = player_scene.instantiate()
		keyboard_player.player_index = 0
		add_child(keyboard_player)
	if Input.is_action_just_pressed("cancelKB") and keyboard_spawned:
		keyboard_spawned = false
		keyboard_player.queue_free()
		
	if Input.is_action_just_pressed("jump0") and not controller_player_0_spawned:
		controller_player_0_spawned = true
		controller_player_0 = player_scene.instantiate()
		controller_player_0.player_index = -2
		add_child(controller_player_0)
	if Input.is_action_just_pressed("cancel0") and controller_player_0_spawned:
		controller_player_0_spawned = false
		controller_player_0.queue_free()
	
	if Input.is_action_just_pressed("jump_joy") and event.device != 0:
		print("foreign controller spawning")
		
