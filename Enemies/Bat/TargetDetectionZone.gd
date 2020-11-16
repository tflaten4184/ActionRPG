extends Area2D

var target = null

func can_see_target(): # in vision range
	return target != null


func _on_TargetDetectionZone_body_entered(body):
	target = body
	print("target detected")


func _on_TargetDetectionZone_body_exited(body):
	target = null
