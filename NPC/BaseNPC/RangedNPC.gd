extends "res://NPC/BaseNPC/CombatNPC.gd"

var target = null # target to shoot at (player), constantly updates
var aim_position = null # most recent target position (in case target moves/disappears)
var on_cooldown = false
export(float, 0, 10, 0.1) var COOLDOWN = 5.0

#export var weaponSpritePath : NodePath
onready var weaponSprite = $YSort/WeaponSprite
onready var weaponAnimationPlayer = $WeaponAnimationPlayer
onready var cooldownTimer = $CooldownTimer
onready var firingZone = $FiringZone

onready var projectile = preload("res://NPC/BaseNPC/Projectile.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func run(delta):
	
	seek_target()
	match state:
		IDLE:	
			idle_state(delta)
		WANDER:
			wander_state(delta)
		TRAVEL:
			travel_state(delta)
		CHASE:
			chase_state(delta)
		ATTACK:
			attack_state()
	#print("physics rangednpc")
	animate()
	velocity = move_and_slide(velocity)

func animate():
	pass

func idle_state(delta):
	# Stop moving (decelerate to 0)
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	# Decide whether to start wandering
	if enable_wander == true and wanderController.get_time_left() == 0:
		state = pick_random_state([IDLE, WANDER])
		wanderController.start_wander_timer(rand_range(1, 3))
		
func seek_target():
	if firingZone.can_see_target(): # in range: stop and begin shooting
		velocity = Vector2.ZERO
		target = firingZone.target[0]
		aim_position = target.global_position
		state = ATTACK
	elif targetDetectionZone.can_see_target(): # out of range, but can see
		state = CHASE # move into range
		target = targetDetectionZone.target[0]
	# Check if it needs to travel
	elif travel_target: # if a travel target exists
		target = null
		state = TRAVEL
	else: # target not detected
		target = null
		state = IDLE
		velocity = Vector2.ZERO

func chase_state(delta):
	if target != null:
				accelerate_toward_point(target.global_position, delta)

func attack_state():
	var target_position = target.global_position
	var aim_direction = position.direction_to(target_position)
	weaponSprite.rotation = aim_direction.angle() # Aim bow
	# Face toward the target
	animate_aim_body(aim_direction)
	#animationTree.set("parameters/Idle/blend_position", aim_direction)
	#animationTree.set("parameters/Run/blend_position", aim_direction)
	if not on_cooldown:
		shoot()

func animate_aim_body(aim_direction):
	# Face toward the target (if object has animations)
	pass

func shoot(): # plays animation, which also launches arrow at most recent target
	print("shoot")
	# ** Need bow-draw animation
	#bowSprite.frame = 0
	weaponAnimationPlayer.play("Firing")
	# ** Animation should call a function to instantiate arrow
	#spawn_arrow() # ** need to change this so that the animation calls it instead
	# Set direction (to target)
	on_cooldown = true
	# Set cooldown timer
	cooldownTimer.start(COOLDOWN)
	#bowSprite.play("Idle")
	
func spawn_projectile():
	# Instantiate an arrow
	var new_projectile = projectile.instance()
#	var world = get_parent()
#	world.add_child(new_arrow)
	get_parent().add_child(new_projectile)
	new_projectile.position = self.position
	new_projectile.position.y -= 10
	new_projectile.direction = new_projectile.position.direction_to(aim_position)


func _on_CooldownTimer_timeout():
	on_cooldown = false
