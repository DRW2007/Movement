extends Resource
class_name CharacterStatsResource

@export_group("Movement Variables")
@export var max_speed : float
@export var ground_acceleration : float
@export var air_acceleration : float

@export_group("Jump Variables")
@export var jump_height : float
@export var time_to_peak : float
@export var time_to_descent : float
##Number from 0.0 to 1.0 that determines how much y velocity is retained after shorthopping
@export var shorthop_percentage : float


@export_group("Frame Timers")
@export var coyote_frames : int
@export var buffer_frames : int
