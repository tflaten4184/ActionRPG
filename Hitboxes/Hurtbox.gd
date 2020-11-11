extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

var invincible = false setget set_invincible

onready var collisionShape = $CollisionShape2D
onready var timer = $Timer

signal invincibility_started
signal invincibility_ended

func set_invincible(value): # bool
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

# This ONLY plays the hit-effect animation (doesn't do calculate damage/knockback)
# Damage and knockback need to be handled in the mob's script (i.e. Bat script)
func create_hit_effect(): 
	var effect = HitEffect.instance()
	var world = get_tree().current_scene
	world.add_child(effect)
	effect.global_position = global_position - Vector2(0, 8)


func _on_Timer_timeout():
	#Note: we have to use "self" here because the "setter function" will only
	#  be called if we use "self". The setter will emit a signal "invinciblity_started" or "_ended"
	# (also, requiring "self" prevents unintentional recursion in other local functions)
	self.invincible = false


func _on_Hurtbox_invincibility_started():
	#monitorable = false # Doesn't work because "monitoring in progress" each frame
	#set_deferred("disabled", true) # defers (delays) the set operation until next frame
	collisionShape.set_deferred("disabled", true)


func _on_Hurtbox_invincibility_ended():
	collisionShape.disabled = false
