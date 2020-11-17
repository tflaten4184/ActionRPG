extends KinematicBody2D

var knockback = Vector2.ZERO
onready var sprite = $Sprite
onready var stats = $Stats
onready var enemyDetectionZone = $EnemyDetectionZone
onready var hurtbox = $Hurtbox

onready var blinkAnimationPlayer = $BlinkAnimationPlayer

enum {
	IDLE,
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
	pass

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		CHASE:
			chase_state(delta)
	#sprite.flip_h = velocity.x < 0
	velocity = move_and_slide(velocity)

func accelerate_toward_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

func seek_player():
	if enemyDetectionZone.can_see_target():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()


func chase_state(delta):
	var player = enemyDetectionZone.target
	if player == null:
		state = IDLE
	else:
		# move towards player
		# Note: position is actually a vector
		accelerate_toward_point(player.global_position, delta)
	

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
