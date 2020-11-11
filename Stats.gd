extends Node

export(int) var max_health = 1 setget set_max_health
# onready so instances don't use default value
var health = max_health setget set_health

signal no_health
signal health_changed(value)
signal max_health_changed(value)

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		print("no health")
		emit_signal("no_health")

func set_max_health(value):
	max_health = value
	emit_signal("max_health_changed", max_health)
	self.health = min(health, max_health)

func _ready():
	self.health = max_health
