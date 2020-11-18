extends Node2D

onready var objective = $Objective


var units # Array of all units controlled by this commander


# Called when the node enters the scene tree for the first time.
func _ready():
	units = get_tree().get_nodes_in_group("enemies")
	#print(units)
	command_attack()


func _physics_process(delta):
	pass
	

func command_attack():
	
	for unit in units:
		unit.travel_target = objective.global_position
