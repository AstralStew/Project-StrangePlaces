extends Node

@export var level : Level

@export var softwareBG : Panel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_level()

func start_level() -> void:
	await get_tree().create_timer(3).timeout
	
	softwareBG.visible = false
	
	level.process_mode = Node.PROCESS_MODE_INHERIT
	level.call_deferred("start_level")
	level.set_deferred("visible",true)
