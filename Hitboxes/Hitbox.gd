extends Area2D



var knockback_vector = Vector2.ZERO
export var knockback_strength = 120
export var damage = 1

export var COOLDOWN = 3

onready var shape = $CollisionShape2D
onready var timer = $Cooldown

func _on_Hitbox_area_entered(area):
	shape.set_deferred("disabled", true)
	if COOLDOWN != 0:
		timer.start(COOLDOWN)


func _on_Cooldown_timeout():
	shape.set_deferred("disabled", false)
