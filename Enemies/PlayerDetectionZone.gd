extends Area2D

var player = null

func can_see_player(): # in vision range
	return player != null


func _on_PlayerDetectionZone_body_entered(body):
	player = body
	print("player detected")


func _on_PlayerDetectionZone_body_exited(body):
	player = null
