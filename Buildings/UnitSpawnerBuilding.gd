extends StaticBody2D

onready var sprite = $Sprite
onready var stats = $Stats
onready var hurtbox = $Hurtbox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer

enum {
	CONSTRUCTION,
	IDLE,
	PRODUCTION,
	HARVEST,
	ATTACK
}
var state = IDLE

func _ready():
	pass

func _physics_process(delta): # To prevent recursion, this calls the Run function
	run(delta)

# This is used in place of the _physics_process() function to prevent inheritance recursion
func run(delta):
	
	match state:
		CONSTRUCTION:
			pass
		IDLE:
			pass
		PRODUCTION:
			pass
		HARVEST:
			pass
		ATTACK:
			pass


	
# Handles damage and knockback against Bat
func _on_Hurtbox_area_entered(area):
	# "area" refers to the "intruder" (sword hitbox)
	stats.health -= area.damage
	#print(stats.health)
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.3)

func _on_Stats_no_health():
	queue_free()
	# Add death effect here
#	var effect = death_effect.instance()
#	var world = get_parent()
#	world.add_child(effect)
#	effect.position = position
#	effect.play()

func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")


func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")
