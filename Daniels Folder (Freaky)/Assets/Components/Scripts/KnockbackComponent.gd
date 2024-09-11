extends Node
class_name KnockbackComponent

@onready var parent : CharacterBody2D = get_parent()

func apply_knockback(attack : Attack):
	parent.velocity = attack.knockback_direction * attack.knockback_force
