extends Node2D

var player = get_parent()
onready var flameConeSkill = $FlameConeSkill
onready var sandShieldSkill = $SandShieldSkill

onready var ability1 = flameConeSkill
onready var ability2 = sandShieldSkill
onready var ability3 = null
onready var ability4 = null
onready var ability5 = null
onready var ability6 = null

signal channelling_start
signal channelling_done

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent()
	flameConeSkill.connect("channelling_start", self, "channelling_start")
	flameConeSkill.connect("channelling_done", self, "channelling_done")
	sandShieldSkill.connect("channelling_start", self, "channelling_start")
	sandShieldSkill.connect("channelling_done", self, "channelling_done")

func channelling_start():
	emit_signal("channelling_start")
	
func channelling_done():
	emit_signal("channelling_done")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func activate_ability1():
	ability1.activate()
	#emit_signal("channelling_start")

func activate_ability2():
	ability2.activate()
	#emit_signal("channelling_start")
	
func activate_ability3():
	ability3.activate()
	
func activate_ability4():
	ability4.activate()
	
func activate_ability5():
	ability5.activate()
	
func activate_ability6():
	ability6.activate()
	
func shield_popped():
	sandShieldSkill.shield_popped()
