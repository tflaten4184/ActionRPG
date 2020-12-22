extends Node2D

onready var commandArea = $CommandArea
onready var allies_in_range = []

func _ready():
	pass
	
func _physics_process(delta):
	pass




func _on_CommandArea_body_shape_entered(body_id, body, body_shape, area_shape):
	# add ally (area) to list of allies_in_range
	print("ally detected")
	allies_in_range.append(body)
	print(allies_in_range)


func _on_CommandArea_body_shape_exited(body_id, body, body_shape, area_shape):
	# remove ally (area) from list of allies_in_range
	print("ally left")
	allies_in_range.remove(allies_in_range.find(body))
	print(allies_in_range)

func execute(target):
	# for list of allies_in_range:
	# tell each ally to follow the player
	# (need to add FollowState to Ally class)
	print("command pressed")
	for ally in allies_in_range:
		ally.travel_target = target.global_position
		print(ally.state)
		print(ally.travel_target)

