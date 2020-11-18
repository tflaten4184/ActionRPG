extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

export var ACCELERATION = 1500
export var MAX_SPEED = 75
export var ROLL_SPEED = 125
export var FRICTION = 500

# Enumerator: each is a constant that represents 0, 1, 2, etc.
enum { # States
	MOVE,
	ROLL,
	ATTACK,
	CHANNELLING
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.RIGHT
var stats = PlayerStats # global autoload singleton

# onready keyword is the same as putting this initialization in the _ready function
onready var animationPlayer = $AnimationPlayer # plays the animation
onready var animationTree = $AnimationTree # manages states for the player
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var swordCollisionShape = $HitboxPivot/SwordHitbox/CollisionShape2D
onready var hurtbox = $Hurtbox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer

# Skills
onready var artifact = $Artifact
#onready var flameConeSkill = $FlameConeSkill
onready var shields = 0

func _ready(): # upon creation, and AFTER child nodes have been created
	#animationPlayer = $AnimationPlayer # $ accesses a child node
	# ^moved to above with "onready" keyword
	
	Engine.time_scale = 0.8
	
	artifact.connect("channelling_start", self, "channelling_start")
	artifact.connect("channelling_done", self, "channelling_done")
	
	randomize() # sets a new random seed for the whole game
	
	# Disable sword hitbox initially
	swordCollisionShape.disabled = true
	
	# obj emitting signal . connect ("signal name", receiver of signal, "function to call")
	stats.connect("no_health", self, "queue_free")
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector
	

func _physics_process(delta): # called every tick (frame), delta = about 1/60 s
	# Note: need to multiply values by delta when they change over time
	#   (when they're connected to the framerate)
	print(Engine.get_frames_per_second())
	match state: # Like a switch-statement
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
		CHANNELLING:
			velocity = Vector2.ZERO
			animationState.travel("Idle")
	
func channelling_start():
	state = CHANNELLING
	
func channelling_done():
	state = MOVE
	
	
func move_state(delta):
	
	# get input and perform actions
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	# need to normalize the vector, so that diagonal isn't faster
	input_vector = input_vector.normalized()
	
	# input_vector is (0,1), etc. so we need to scale it by acceleration
	if input_vector != Vector2.ZERO: # if Player is moving
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run") # Travel causes state transition in animationTree
		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		
	else: # if Player is Not moving
		#animationPlayer.play("IdleRight")
		animationState.travel("Idle") # Travel causes state transition in animationTree
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		

	move()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
		
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("ability1"):
		artifact.activate_ability1()
		#flameConeSkill.rotation = roll_vector.angle()
		#flameConeSkill.activate()
	
	if Input.is_action_just_pressed("ability2"):
		artifact.activate_ability2()
	
func attack_animation_finished():
	state = MOVE
	
func roll_animation_finished():
	velocity = Vector2.ZERO # Reset momentum after roll (prevent weird sliding)
	state = MOVE

func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	#animationPlayer.play("RollRight")
	# Tell animationTree to transition to the Roll state
	animationState.travel("Roll")
	move()

func move():
	velocity = move_and_slide(velocity)

func attack_state(delta):
	velocity = Vector2.ZERO
	#animationPlayer.play("AttackRight")
	animationState.travel("Attack") # Travel causes state transition in animationTree
	


func _on_Hurtbox_area_entered(area): # When attacked by a mob's hitbox
	if shields >= 1:
		shields -= 1
		artifact.shield_popped()
	else:
		stats.health -= area.damage
		print(stats.health)
		var playerHurtSound = PlayerHurtSound.instance()
		get_tree().current_scene.add_child(playerHurtSound)
		hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.5)
	
	
	


func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")


func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")
