class_name MobManager extends Node

@onready var enemy_timer = $EnemyAwakeTimer
@onready var main_character = get_tree().get_first_node_in_group("MainCharacter")
@onready var server_window = get_tree().get_first_node_in_group("ServerWindow") as ServerWindow

@onready var slime_scene = preload("res://Scenes/slime.tscn")
@onready var NPC_scene = preload("res://Scenes/NPC.tscn")

@export_category("CONTROLS")

@export var number_of_start_slimes : int = 20


@export_category("CORRUPTION TICK")
@export var tick_rate : float = 0.5
@export var slime_tick_chance : float = 0.01
@export var npc_tick_chance : float = 0.02

var slimes_spawned = 0


@export_category("READ ONLY")

@onready var admin_window : AdminWindow = get_tree().get_first_node_in_group("AdminWindow")

@export var spawn_slime_on_click : bool = false :
	get: return (
		admin_window.selected_tab == AdminWindow.Tabs.ENEMIES &&
		admin_window.selected_enemy_tool == AdminWindow.EnemyTools.SPAWN
	) 

@export var spawn_NPC_on_click : bool = false :
	get: return (
		admin_window.selected_tab == AdminWindow.Tabs.NPCS &&
		admin_window.selected_npc_tool == AdminWindow.NPCTools.SPAWN
	)

signal spawned_slime
signal spawned_NPC
signal tick_slime
signal tick_NPC

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()

func setup() -> void:
	
	spawned_slime.connect(server_window.spawn_slime)
	spawned_NPC.connect(server_window.spawn_NPC)
	tick_slime.connect(server_window.tick_slime)
	tick_NPC.connect(server_window.tick_NPC)
	
	print("[MobManager] Spawning ",number_of_start_slimes," slimes.")
	for i in number_of_start_slimes:
		var new_slime : Slime = spawn_slime()
		new_slime.global_position = Vector2( randf_range(0,1152),randf_range(0,656) )
		new_slime.name += " (startup)"
		print("[MobManager] Spawned slime '",new_slime.name,"' during startup at ",new_slime.global_position)
		await get_tree().process_frame
	
	if GlobalVariables.corruption_active:
		passive_tick()
#

func _unhandled_input(event: InputEvent) -> void:
	if spawn_slime_on_click && event.is_action_pressed("AdminEnemyTool"):
		var new_slime : Slime = spawn_slime()
		if new_slime != null:
			new_slime.add_to_group("Slimes")
			new_slime.global_position = $"..".get_local_mouse_position()
			print("[MobManager] Spawned slime '",new_slime.name,"' via mouse at ",new_slime.global_position)
		spawned_slime.emit()
	
	elif spawn_NPC_on_click && event.is_action_pressed("AdminNPCTool"):
		var new_NPC : NPC = spawn_NPC()
		if new_NPC != null:
			new_NPC.add_to_group("NPCs")
			new_NPC.global_position = $"..".get_local_mouse_position()
			print("[MobManager] Spawned NPC '",new_NPC.name,"' via mouse at ",new_NPC.global_position)
		spawned_NPC.emit()

#
func passive_tick() -> void:
	while(GlobalVariables.corruption_active):
		if (get_tree().get_node_count_in_group("Slimes") * slime_tick_chance) > randf():
			tick_slime.emit()
			var chosen_slime : Slime = get_tree().get_nodes_in_group("Slimes")[randi() % get_tree().get_node_count_in_group("Slimes")]
			chosen_slime.corrupt()
			
		elif (get_tree().get_node_count_in_group("NPCs") * npc_tick_chance) > randf():
			tick_NPC.emit()
			var chosen_NPC : NPC = get_tree().get_nodes_in_group("NPCs")[randi() % get_tree().get_node_count_in_group("NPCs")]
			chosen_NPC.corrupt()
		
		await get_tree().create_timer(tick_rate).timeout
		



func spawn_slime() -> Slime:
	var instance : Slime = slime_scene.instantiate()
	if instance == null:
		return null
	
	instance.timer = enemy_timer
	instance.main_character = main_character
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
	
	instance.name = "NPC_" + instance.npconfig.readable_name
	
	return instance
