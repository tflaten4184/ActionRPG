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

onready var target = null


# Called when the node enters the scene tree for the first time.
func _ready():
	state = IDLE
	enable_wander = false

#func idle_state(delta):
#	# Stop moving
#	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
#
#	# Decide whether to start wandering
#	if enable_wander == true and wanderController.get_time_left() == 0:
#		state = pick_random_state([IDLE, WANDER])
#		wanderController.start_wander_timer(rand_range(1, 3))

func seek_target():
	if state == self.FOLLOW:
		pass # don't seek a target while following (ignore enemies)
	elif targetDetectionZone.can_see_target():
		state = CHASE
		target = targetDetectionZone.target[0]
		# Check if it needs to travel
	elif travel_target: # if a travel target exists
		state = TRAVEL
	else:
		state = IDLE

func chase_state(delta):
	#var target = targetDetectionZone.target[0]
	if target == null:
		state = IDLE
	else:
		# move towards player
		# Note: position is actually a vector
		accelerate_toward_point(target.global_position, delta)
