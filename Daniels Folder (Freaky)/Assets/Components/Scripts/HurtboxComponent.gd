extends Area2D
class_name HurtboxComponent

@export var health_component : int
@export var knockback_component : KnockbackComponent

func damage(attack : Attack):
	if health_component:
		pass
	if knockback_component:
		knockback_component.apply_knockback(attack)
	
