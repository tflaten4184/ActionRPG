extends Node2D

onready var player = get_parent()
onready var flameConeSkill = $FlameConeSkill

onready var ability1 = flameConeSkill
onready var ability2 = null
onready var ability3 = null
onready var ability4 = null
onready var ability5 = null
onready var ability6 = null

signal channelling_start
signal channelling_done

# Called when the node enters the scene tree for the first time.
func _ready():
	flameConeSkill.connect("channelling_start", self, "channelling_start")
	flameConeSkill.connect("channelling_done", self, "channelling_done")

func channelling_start():
	emit_signal("channelling_start")
	
func channelling_done():
	emit_signal("channelling_done")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func activate_ability1():
	ability1.activate(player)
	#emit_signal("channelling_start")

func activate_ability2():
	ability2.activate(player)
	#emit_signal("channelling_start")
	
func activate_ability3():
	ability3.activate(player)
	
func activate_ability4():
	ability4.activate(player)
	
func activate_ability5():
	ability5.activate(player)
	
func activate_ability6():
	ability6.activate(player)
	
