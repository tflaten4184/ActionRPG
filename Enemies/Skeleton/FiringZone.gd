extends Area2D

var target = null

func can_see_target(): # in firing range
	return target != null


func _on_FiringZone_body_entered(body):
	target = body


func _on_FiringZone_body_exited(body):
	target = null
