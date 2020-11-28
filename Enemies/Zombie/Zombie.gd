extends "res://Enemies/BaseEnemy/CombatEnemy.gd"


#onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func animate():
	if velocity == Vector2.ZERO:
		animationState.travel("Idle")
	else:
		animationTree.set("parameters/Idle/blend_position", velocity.normalized())
		animationTree.set("parameters/Run/blend_position", velocity.normalized())
		animationState.travel("Run")
