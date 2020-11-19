extends Area2D

onready var shape = $CollisionShape2D
onready var timer = $Cooldown

var knockback_vector = Vector2.ZERO
export var knockback_strength = 120
export var damage = 1
export var COOLDOWN = 3



func _on_Hitbox_area_entered(area):
	shape.set_deferred("disabled", true)
	timer.start(COOLDOWN)


func _on_Cooldown_timeout():
	shape.set_deferred("disabled", false)
