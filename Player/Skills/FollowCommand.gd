extends Node2D

onready var commandArea = $CommandArea
onready var allies_in_range = []
onready var current_followers = []

func _ready():
	pass
	
func _physics_process(delta):
	#if null in current_followers:
	current_followers.remove(current_followers.find(null))




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
		if not ally in current_followers:
			current_followers.append(ally)
		ally.follow_target = target
		ally.state = ally.FOLLOW
		print(ally.state)
		print(ally.follow_target)

func cancel():
	for follower in current_followers:
		if follower: # if follower still exists
			follower.follow_target = null
	current_followers = [] # clear the list of followers
