extends KinematicBody2D

var SPEED = 100
var direction = Vector2.LEFT

onready var sprite = $Sprite
onready var HitEffect = preload("res://Effects/HitEffect.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var velocity = direction * SPEED * delta
	# move_and_collide based on velocity
	rotation = velocity.angle()
	if (move_and_collide(velocity)): # returns collision
		create_hit_effect()
		queue_free()


func create_hit_effect(): # to be played on impact
	var effect = HitEffect.instance()
	var world = get_tree().current_scene
	world.add_child(effect)
	effect.global_position = global_position
