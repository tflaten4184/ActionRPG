extends "res://NPC/BaseNPC/RangedAlly.gd"

onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")


func _ready():
	projectile = preload("res://NPC/Archer/AllyArrow.tscn")

func animate():
	# Animation Tree functions
	if velocity == Vector2.ZERO:
		animationState.travel("Idle")
	else:
		animationTree.set("parameters/Idle/blend_position", velocity.normalized())
		animationTree.set("parameters/Run/blend_position", velocity.normalized())
		animationState.travel("Run")

func animate_aim_body(aim_direction):
	# Face toward the target
	animationTree.set("parameters/Idle/blend_position", aim_direction)
	animationTree.set("parameters/Run/blend_position", aim_direction)
