extends Area2D

var target = []

func can_see_target(): # in firing range
	return target.empty() == false


func _on_FiringZone_body_entered(body):
	target.append(body)
	#print("target in range")


func _on_FiringZone_body_exited(body):
	#target = null
	var body_index = target.find(body)
	target.remove(body_index)
