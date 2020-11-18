extends KinematicBody2D

var knockback = Vector2.ZERO
onready var sprite = $Sprite
onready var stats = $Stats
onready var targetDetectionZone = $TargetDetectionZone
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var blinkAnimationPlayer = $BlinkAnimationPlayer

enum {
	IDLE,
	WANDER,
	CHASE
}
var state = IDLE
var FRICTION = 200
var ACCELERATION = 300
var MAX_SPEED = 50
var velocity = Vector2.ZERO

var death_effect = preload("res://Effects/EnemyDeathEffect.tscn")

func _ready():
	#print(stats.max_health)
	#print(stats.health)
	sprite.frame = rand_range(0,4)
	pass

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_target()
			
			if wanderController.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_wander_timer(rand_range(1, 3))
		WANDER:
			wander_state(delta)
		CHASE:
			chase_state(delta)
	sprite.flip_h = velocity.x < 0
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400 # push strength
	velocity = move_and_slide(velocity)

func accelerate_toward_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

func seek_target():
	if targetDetectionZone.can_see_target():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func idle_or_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))

func chase_state(delta):
	var target = targetDetectionZone.target[0]
	if target == null:
		state = IDLE
	else:
		# move towards player
		# Note: position is actually a vector
		accelerate_toward_point(target.global_position, delta)

func wander_state(delta):
	seek_target()
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
	knockback = area.knockback_vector * area.knockback_strength * 1.5 #1.5 bonus knockback vs Bat
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.3)
	

func _on_Stats_no_health():
	queue_free()
	var effect = death_effect.instance()
	var world = get_parent()
	world.add_child(effect)
	effect.position = position
	effect.play()


func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")


func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")
