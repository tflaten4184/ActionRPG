extends KinematicBody2D

onready var sprite = $YSort/Sprite
onready var stats = $Stats
onready var wanderController = $WanderController
onready var hurtbox = $Hurtbox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer

enum {
	IDLE,
	WANDER,
	TRAVEL,
	CHASE,
	ATTACK,
	CHANNEL,
	FOLLOW
}

var state = IDLE
var FRICTION = 200
var ACCELERATION = 300
var MAX_SPEED = 50
var velocity = Vector2.ZERO
onready var knockback = Vector2.ZERO
var knockback_multiplier = 1.0 # Sensitivity to incoming knockback
onready var travel_target = null
onready var follow_target = null

onready var enable_wander = false

func _ready():
	hurtbox.connect("area_entered", self, "_on_Hurtbox_area_entered")

func _physics_process(delta): # To prevent recursion, this calls the Run function
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	run(delta)

# This is used in place of the _physics_process() function to prevent inheritance recursion
func run(delta):
	
#	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
#	knockback = move_and_slide(knockback)
	
	seek_target() # invalid for a basic NPC
	match state:
		IDLE:
			idle_state(delta)
		WANDER:
			wander_state(delta)
		TRAVEL:
			travel_state(delta)
		CHASE: # invalid for a basic NPC
			chase_state(delta)
		ATTACK: # invalid for a basic NPC
			attack_state()
		FOLLOW: # ****** WORK IN PROGRESS ******
			follow_state(delta)
	#print("physics combatnpc")
	animate() 
	velocity = move_and_slide(velocity)

func animate():
	pass

func chase_state(delta): # invalid for a basic NPC
	idle_state(delta)

func attack_state(): # invalid for a basic NPC
	pass

func follow_state(delta):
	if follow_target and global_position.distance_to(follow_target.global_position) > 10:
		accelerate_toward_point(follow_target.global_position, delta)
	else:
		#follow_target = null
		state = IDLE

func seek_target(): # invalid for a basic NPC
	pass

func idle_state(delta):
	# Check if it needs to follow
	if follow_target:
		state = FOLLOW
	# Check if it needs to travel
	if travel_target: # if a travel target exists
		state = TRAVEL
	
	else:
		# Stop moving
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	
	# Decide whether to start wandering
	if enable_wander == true and wanderController.get_time_left() == 0:
		state = pick_random_state([IDLE, WANDER])
		wanderController.start_wander_timer(rand_range(1, 3))

func accelerate_toward_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

func travel_state(delta):
	if global_position.distance_to(travel_target) > 10:
		accelerate_toward_point(travel_target, delta)
	else:
		travel_target = null
		state = IDLE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func idle_or_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))

func wander_state(delta):
	if wanderController.get_time_left() == 0:
		idle_or_wander()
	
	accelerate_toward_point(wanderController.target_position, delta)
	
	if global_position.distance_to(wanderController.target_position) <= 1:
		idle_or_wander()
	
# Handles damage and knockback against Bat
func _on_Hurtbox_area_entered(area):
	# "area" refers to the "intruder" (sword hitbox)
	stats.health -= area.damage
	#print(stats.health)
	knockback = area.knockback_vector * area.knockback_strength * knockback_multiplier
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.1)

func _on_Stats_no_health():
	queue_free()
	# Add death effect here
#	var effect = death_effect.instance()
#	var world = get_parent()
#	world.add_child(effect)
#	effect.position = position
#	effect.play()

func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")
	#print("start blink effect")


func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")
