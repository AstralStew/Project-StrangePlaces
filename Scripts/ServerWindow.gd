class_name ServerWindow extends VirtualWindow

@onready var bsod : AnimatedSprite2D =$"../BSOD"

@onready var admin_window : AdminWindow = get_tree().get_first_node_in_group("AdminWindow")
@onready var quest_window : QuestWindow = get_tree().get_first_node_in_group("QuestWindow")
@onready var plase_wait_window : PanelContainer = $"../PleaseWaitWindow"

@onready var data_cube = preload("res://Scenes/data_cube.tscn")
@onready var cube_grid = $VBoxContainer/ServerWindow/MarginContainer/VBoxContainer/DataCubeHolderPanel/CenterContainer/DataCubeGrid
@onready var audio_glitch_fx : AudioStreamPlayer = $"../../GlitchFx"

@export var number_of_data_cubes : int = 96
@export var healthy_colour : Color = Color.hex(0x2e96ff)
@export var corrupted_colour : Color = Color.hex(0xef00f0)

@export_category("SPAWN SPREAD")
@export var bonus_spread_increase : float = 0.06
@export var bonus_spread_max : float = 0.36
@export var spawn_slime_spread_chance : float = 0.05
@export var spawn_slime_spread_amount : Vector2i = Vector2(1,2)
@export var spawn_NPC_spread_chance : float = 0.15
@export var spawn_NPC_spread_amount : Vector2i  = Vector2(2,4)
@export var tick_slime_spread_amount: Vector2i  = Vector2(1,1)
@export var tick_NPC_spread_amount: Vector2i  = Vector2(1,2)

@export_category("RESTART DRIVE")
@export var time_to_restart_drive : float = 10
@export var percentage_cubes_recovered : float = 0.9

@export_category("READ ONLY")
@export var healthy_cubes : Array[Panel] = []
@export var corrupted_cubes : Array[Panel] = []


@export var bonus_spread_chance : float = 0.0

@export var corruption : int = 0 :
	get: return corrupted_cubes.size()

@export var restarting : bool = false

var randf : float = 0.0


signal on_corrupt
signal server_restart_start
signal server_restart_complete

func _ready() -> void:
	
	var instance : Panel = null
	for i in number_of_data_cubes:
		instance = data_cube.instantiate()
		instance.name = "DataCube_" + str(i) + "_Healthy"
		instance.modulate = healthy_colour
		cube_grid.add_child(instance)
		healthy_cubes.append(instance)
	
	if GlobalVariables.corruption_active:
		# Corrupt a few data cubes to start
		corrupt(3)




func corrupt(amount:int) -> void:
	if !GlobalVariables.corruption_active || restarting:
		push_error("[ServerWindow] ERROR -> Trying to corrupt but corruption isn't active in global_variables")
		return
	print("[ServerWindow] Corrupting ",amount," cubes")
	var chosen_cube_index = -1
	var chosen_cube : Panel = null
	
	print("[ServerWindow] Adding ",amount," to corruption (at ",corruption,"/",number_of_data_cubes,")")
	if healthy_cubes.size() - amount <= 0:
		game_over()
	
	for i in amount:
		if restarting: break
			
		chosen_cube_index = randi() % healthy_cubes.size()
		chosen_cube = healthy_cubes[chosen_cube_index]
		
		corrupted_cubes.append(chosen_cube)
		healthy_cubes.remove_at(chosen_cube_index)
		
		chosen_cube.name = chosen_cube.name.replace("Healthy","Corrupt")
		chosen_cube.modulate = corrupted_colour
		
		audio_glitch_fx.play()
		await get_tree().create_timer(0.25)
	
	on_corrupt.emit()

func game_over() -> void:
	bsod.visible = true
	bsod.play("default")
	await bsod.animation_finished
	get_tree().quit()




func tick_slime() -> void:
	print("[ServerWindow] Tick slime!")
	corrupt(randi_range(tick_slime_spread_amount.x,tick_slime_spread_amount.y))

func tick_NPC() -> void:
	print("[ServerWindow] Tick NPC!")
	corrupt(randi_range(tick_NPC_spread_amount.x,tick_NPC_spread_amount.y))


func spawn_slime() -> void:
	if !GlobalVariables.corruption_active || restarting: return
	print("[ServerWindow] Slime spawned, spread chance = ",spawn_slime_spread_chance," (+",bonus_spread_chance,")")
	randf = randf()
	if spawn_slime_spread_chance + bonus_spread_chance >= randf:
		print("[ServerWindow] Roll = ",randf,", chance exceeded! Corrupting... ")
		corrupt(randi_range(spawn_slime_spread_amount.x,spawn_slime_spread_amount.y))
		bonus_spread_chance = 0
	else: 
		bonus_spread_chance = clampf(bonus_spread_chance + bonus_spread_increase, 0, bonus_spread_max)
		print("[ServerWindow] Rolld = ",randf,", no corruption. Bonus spread chance now +",bonus_spread_chance)
		

func spawn_NPC() -> void:
	if !GlobalVariables.corruption_active || restarting: return
	print("[ServerWindow] NPC spawned, spread chance = ",spawn_NPC_spread_chance," (+",bonus_spread_chance,")")
	randf = randf()
	if spawn_NPC_spread_chance + bonus_spread_chance >= randf:
		print("[ServerWindow] Roll = ",randf,", chance exceeded! Corrupting... ")
		corrupt(randi_range(spawn_NPC_spread_amount.x,spawn_NPC_spread_amount.y))
		bonus_spread_chance = 0
	else: 
		bonus_spread_chance = clampf(bonus_spread_chance + bonus_spread_increase, 0, bonus_spread_max)
		print("[ServerWindow] Rolld = ",randf,", no corruption. Bonus spread chance now +",bonus_spread_chance)


func restart_drive() -> void:
	restarting = true
	await get_tree().process_frame
	
	server_restart_start.emit()
	
	admin_window.visible = false
	admin_window.change_selected_tab(AdminWindow.Tabs.DISABLED)
	quest_window.visible = false
	visible = false
	
	plase_wait_window.visible = true
	
	print("[ServerWindow] Recovering ",floori(corruption * percentage_cubes_recovered),"/",corruption," corrupted cubes")
	var chosen_cube_index = -1
	var chosen_cube : Panel = null
	
	for i in floori(corruption * percentage_cubes_recovered):
		chosen_cube_index = randi() % corrupted_cubes.size()
		chosen_cube = corrupted_cubes[chosen_cube_index]
		
		healthy_cubes.append(chosen_cube)
		corrupted_cubes.remove_at(chosen_cube_index)
		
		chosen_cube.name = chosen_cube.name.replace("Corrupt","Healthy")
		chosen_cube.modulate = healthy_colour
	
	await get_tree().create_timer(time_to_restart_drive).timeout
	
	plase_wait_window.visible = false
	
	visible = true
	admin_window.visible = true
	admin_window.change_selected_tab(AdminWindow.Tabs.ATTACKING)
	quest_window.visible = true
	
	restarting = false
	
	server_restart_complete.emit()
	
