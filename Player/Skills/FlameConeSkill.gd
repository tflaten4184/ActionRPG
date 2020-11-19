extends Node2D

onready var animationPlayer = $AnimationPlayer
onready var sound = $SoundEffect
onready var player = get_parent().player

signal channelling_start
signal channelling_done

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func activate():
	player = get_parent().player
	emit_signal("channelling_start")
	rotation = player.roll_vector.angle()
	animationPlayer.play("Cone")
	sound.play()

# Animation finished
func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("channelling_done")
