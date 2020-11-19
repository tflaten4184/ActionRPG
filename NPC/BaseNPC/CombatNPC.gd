extends "res://NPC/BaseNPC/NPC.gd"


onready var targetDetectionZone = $TargetDetectionZone
#onready var hurtbox = $Hurtbox
#onready var blinkAnimationPlayer = $BlinkAnimationPlayer

# Add a death effect
#var death_effect = preload("res://Effects/EnemyDeathEffect.tscn")

# List of possible states for an NPC
# IDLE,
# WANDER,
# TRAVEL,
# CHASE,
# ATTACK,
# CHANNEL



# Called when the node enters the scene tree for the first time.
func _ready():
	state = IDLE
	enable_wander = true
	#knockback = 50

func run(delta):
	
	seek_target()
	match state:
		IDLE:
			# Stop moving
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			
			
			# Decide whether to start wandering
			if enable_wander == true and wanderController.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_wander_timer(rand_range(1, 3))
		WANDER:
			wander_state(delta)
		TRAVEL:
			travel_state(delta)
		CHASE:
			chase_state(delta)
	print("physics combatnpc")
	velocity = move_and_slide(velocity)

func seek_target():
	if targetDetectionZone.can_see_target():
		state = CHASE
		# Check if it needs to travel
	elif travel_target: # if a travel target exists
		state = TRAVEL
	else:
		state = IDLE

func chase_state(delta):
	var target = targetDetectionZone.target[0]
	if target == null:
		state = IDLE
	else:
		# move towards player
		# Note: position is actually a vector
		accelerate_toward_point(target.global_position, delta)

## Handles damage and knockback against Bat
#func _on_Hurtbox_area_entered(area):
#	# "area" refers to the "intruder" (sword hitbox)
#	stats.health -= area.damage
#	#print(stats.health)
#	knockback = area.knockback_vector * area.knockback_strength * 1.5 #1.5 bonus knockback vs Bat
#	hurtbox.create_hit_effect()
#	hurtbox.start_invincibility(0.3)
	

#func _on_Stats_no_health():
#	queue_free()
#	# Add death effect here
##	var effect = death_effect.instance()
##	var world = get_parent()
##	world.add_child(effect)
##	effect.position = position
##	effect.play()


#func _on_Hurtbox_invincibility_started():
#	blinkAnimationPlayer.play("Start")
#
#
#func _on_Hurtbox_invincibility_ended():
#	blinkAnimationPlayer.play("Stop")
