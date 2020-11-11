extends Area2D

# Reusable node for soft (slow push) collisions

# Set "push vector" upon collision
func is_colliding():
	var areas = get_overlapping_areas() # array
	return areas.size() > 0 # if array is not empty, return true
	
func get_push_vector():
	var areas = get_overlapping_areas()
	var push_vector = Vector2.ZERO
	if is_colliding():
		var area = areas[0]
		
		# Vector that points from the colliding object to our object
		# (pushing this object away from that object)
		push_vector = area.global_position.direction_to(global_position)
		push_vector = push_vector.normalized()
	return push_vector # returns 0 if not colliding with anything
