extends Node2D

func create_grass_effect():
	# Create GrassEffect (destruction animation)
	var GrassEffect = load("res://Effects/GrassEffect.tscn") # gets the Scene (Class)
	var grassEffect = GrassEffect.instance() # creates an Instance (Object) from Scene (Class)
	
	# Note: get_tree() returns the SceneTree (high-level scene manager which controls the game)
	# Note: current_scene refers to the scene the game's currently running main scene (root node)
	var world = get_tree().current_scene # gets a reference to the game's main scene
	world.add_child(grassEffect)
	# set the Effect's position equal to this Grass's position
	grassEffect.global_position = global_position # set's targets position to self's position


func _on_Hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()
