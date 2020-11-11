extends AudioStreamPlayer

func _ready():
	connect("finished", self, "queue_free")


func _on_PlayerHurtSound_finished():
	queue_free()
