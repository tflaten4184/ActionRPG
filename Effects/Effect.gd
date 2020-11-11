extends AnimatedSprite

# This is a reusable script for effect animations

func _ready(): # Upon creation:
	# connect signal manually through code
	
	# obj emitting signal ("signal being emitted", object to connect to, "function to call (of target)")
	self.connect("animation_finished", self, "_on_animation_finished")
	frame = 0
	play("Animate") # play the animation
	

# When animation ends, signal calls this function:


func _on_animation_finished():
	queue_free() # deletes the animation (otherwise it would linger)
