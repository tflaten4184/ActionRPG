extends Area2D

var player = null

func can_see_player(): # in firing range
	return player != null


func _on_FiringZone_body_entered(body):
	player = body


func _on_FiringZone_body_exited(body):
	player = null
