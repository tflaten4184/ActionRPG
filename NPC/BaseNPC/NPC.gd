extends KinematicBody2D

onready var sprite = $Sprite
onready var stats = $Stats
onready var wanderController = $WanderController

enum {
	IDLE,
	WANDER,
	TRAVEL,
	CHASE,
	ATTACK,
	CHANNEL
}
var state = IDLE
var FRICTION = 200
var ACCELERATION = 300
var MAX_SPEED = 50
var velocity = Vector2.ZERO
onready var travel_target = null

onready var enable_wander = false

func _ready():
	pass

func _physics_process(delta): # To prevent recursion, this calls the Run function
	run(delta)

# This is used in place of the _physics_process() function to prevent inheritance recursion
func run(delta):
	
	match state:
		IDLE:
			# Check if it needs to travel
			if travel_target: # if a travel target exists
				state = TRAVEL
			
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
		
	print("physics npc")

	velocity = move_and_slide(velocity)

func accelerate_toward_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

func travel_state(delta):
	if position.distance_to(travel_target) > 10:
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
	
func _on_Stats_no_health():
	queue_free()
	# Add death effect here
#	var effect = death_effect.instance()
#	var world = get_parent()
#	world.add_child(effect)
#	effect.position = position
#	effect.play()

