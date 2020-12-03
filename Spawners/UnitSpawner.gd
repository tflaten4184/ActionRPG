extends Node2D

export(PackedScene) var unit # Link to scene of unit
#onready var unit = preload("res://NPC/BaseNPC/NPC.tscn")
export(int) var COOLDOWN
onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = COOLDOWN


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_Timer_timeout():
	var new_unit = unit.instance()
	# bad practice, but use for testing for now:
	# globalYsort > buildings > thisbuilding > thisSpawner
	get_parent().get_parent().get_parent().add_child(new_unit)
	new_unit.position = global_position
