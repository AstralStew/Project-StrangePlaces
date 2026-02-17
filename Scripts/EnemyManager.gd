class_name EnemyManager extends Node

@onready var enemy_timer = $EnemyAwakeTimer
@onready var player = get_tree().get_nodes_in_group("Player")[0]
@onready var slime_scene = preload("res://Scenes/slime.tscn")

@onready var NPC_scene = preload("res://Scenes/NPC.tscn") # NOTE > delete this

@export_category("CONTROLS")

@export var number_of_start_slimes : int = 20

var slimes_spawned = 0



@onready var admin_window : AdminWindow = get_tree().get_first_node_in_group("AdminWindow")

@export var spawn_slime_on_click : bool = false :
	get: return admin_window.selected_tool == AdminWindow.ToolNames.SPAWN_ENEMY

@export var spawn_NPC_on_click : bool = false :
	get: return admin_window.selected_tool == AdminWindow.ToolNames.SPAWN_NPC


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()

func setup() -> void:
	print("[EnemyManager] Spawning ",number_of_start_slimes," slimes.")
	for i in number_of_start_slimes:
		var new_slime = spawn_slime()
		new_slime.global_position = Vector2( randf_range(0,1152),randf_range(0,656) )
		new_slime.name += " (startup)"
		print("[EnemyManager] Spawned slime '",new_slime.name,"' during startup at ",new_slime.global_position)
		await get_tree().process_frame


func _unhandled_input(event: InputEvent) -> void:
	if spawn_slime_on_click && event.is_action_pressed("Spawn Enemy"):
		var new_slime = spawn_slime()
		if new_slime != null:
			new_slime.global_position = $"..".get_local_mouse_position()
			print("[EnemyManager] Spawned slime '",new_slime.name,"' via mouse at ",new_slime.global_position)
	
	elif spawn_NPC_on_click && event.is_action_pressed("Spawn NPC"):
		var new_NPC = spawn_NPC()
		if new_NPC != null:
			new_NPC.global_position = $"..".get_local_mouse_position()
			print("[EnemyManager] Spawned NPC '",new_NPC.name,"' via mouse at ",new_NPC.global_position)


func spawn_slime() -> Enemy:
	var instance = slime_scene.instantiate() as Enemy
	if instance == null:
		return null
	
	instance.timer = enemy_timer
	instance.player = player
	instance.setup()
	add_child(instance)
	
	instance.name = "Slime_" + str(slimes_spawned)
	slimes_spawned += 1
	
	return instance


func spawn_NPC() -> NPC:
	var instance = NPC_scene.instantiate() as NPC
	if instance == null:
		return null
	
	instance.setup()
	add_child(instance)
	
	return instance
