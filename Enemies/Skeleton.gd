extends KinematicBody2D


export var MAX_SPEED = 40
export var ACCELERATION = 100
#export var FRICTION = 1500
var velocity = Vector2.ZERO

var target = null

onready var stats = $Stats
onready var sprite = $Sprite
onready var hurtbox = $Hurtbox
onready var cooldownTimer = $CooldownTimer
onready var detectionZone = $DetectionZone
onready var firingZone = $FiringZone

var arrow = load("res://Enemies/Arrow.tscn")

var state = IDLE #set to IDLE after debugging
var on_cooldown = false

enum {
	IDLE,
	WANDER,
	CHASE,
	FIRE
}

# Called when the node enters the scene tree for the first time.
func _ready():
	#shoot()
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match state:
		IDLE:
			target = null
			velocity = velocity.move_toward(Vector2.ZERO, delta) # could do friction * delta
			seek_player()
		WANDER: # not implemented
			target = null
			seek_player()
		CHASE:
			if target != null:
				accelerate_toward_point(target.position, delta)
			seek_player()
		FIRE:
			if not on_cooldown:
				shoot(target)
			seek_player()
		
	velocity = move_and_slide(velocity)

func accelerate_toward_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	
func seek_player():
	if firingZone.can_see_player(): # in range: stop and begin shooting
		velocity = Vector2.ZERO
		target = firingZone.player
		state = FIRE
	elif detectionZone.can_see_player(): # out of range, but can see
		state = CHASE # move into range
		target = detectionZone.player
	else: # player not detected
		target = null
		state = IDLE
	#target = detectionZone.player # acquire target


func shoot(target):
	print("shoot")
	# Instantiate an arrow
	var new_arrow = arrow.instance()
#	var world = get_parent()
#	world.add_child(new_arrow)
	get_parent().add_child(new_arrow)
	new_arrow.position = self.position
	new_arrow.position.y -= 10
	new_arrow.direction = new_arrow.position.direction_to(target.position)
	
	# Set direction (to target)
	on_cooldown = true
	# Set cooldown timer
	cooldownTimer.start(5)
	pass


func _on_CooldownTimer_timeout():
	on_cooldown = false
