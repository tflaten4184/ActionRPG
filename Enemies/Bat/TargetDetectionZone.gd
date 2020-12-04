extends Area2D

var target = []

func can_see_target(): # in vision range
	return target.empty() == false


func _on_TargetDetectionZone_body_entered(body):
	target.append(body)
	#print("target detected")


func _on_TargetDetectionZone_body_exited(body):
	#target = null
	var body_index = target.find(body)
	target.remove(body_index)
