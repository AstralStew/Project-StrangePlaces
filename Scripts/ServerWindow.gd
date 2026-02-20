class_name ServerWindow extends VirtualWindow


@onready var data_cube = preload("res://Scenes/data_cube.tscn")
@onready var cube_grid = $VBoxContainer/ServerWindow/MarginContainer/VBoxContainer/DataCubeHolderPanel/CenterContainer/DataCubeGrid

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
@export var tick_slime_spread_amount: int = 1
@export var tick_NPC_spread_amount: int = 1


@export_category("READ ONLY")
@export var healthy_cubes : Array[Panel] = []
@export var corrupted_cubes : Array[Panel] = []


@export var bonus_spread_chance : float = 0.0

@export var corruption : int = 0 :
	get: return corrupted_cubes.size()


var randf : float = 0.0


func _ready() -> void:
	var instance : Panel = null
	for i in number_of_data_cubes:
		instance = data_cube.instantiate()
		instance.name = "DataCube_" + str(i) + "_Healthy"
		instance.modulate = healthy_colour
		cube_grid.add_child(instance)
		healthy_cubes.append(instance)
	
	# Corrupt a few data cubes to start
	corrupt(3)


func corrupt(amount:int) -> void:
	print("[ServerWindow] Corrupting ",amount," cubes")
	var chosen_cube_index = -1
	var chosen_cube : Panel = null
	for i in amount:
		chosen_cube_index = randi() % healthy_cubes.size()
		chosen_cube = healthy_cubes[chosen_cube_index]
		
		corrupted_cubes.append(chosen_cube)
		healthy_cubes.remove_at(chosen_cube_index)
		
		chosen_cube.name = chosen_cube.name.replace("Healthy","Corrupt")
		chosen_cube.modulate = corrupted_colour


func tick_slime() -> void:
	print("[ServerWindow] Tick slime!")
	corrupt(tick_slime_spread_amount)

func tick_NPC() -> void:
	print("[ServerWindow] Tick NPC!")
	corrupt(tick_slime_spread_amount)


func spawn_slime() -> void:
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
	print("[ServerWindow] NPC spawned, spread chance = ",spawn_NPC_spread_chance," (+",bonus_spread_chance,")")
	randf = randf()
	if spawn_NPC_spread_chance + bonus_spread_chance >= randf:
		print("[ServerWindow] Roll = ",randf,", chance exceeded! Corrupting... ")
		corrupt(randi_range(spawn_NPC_spread_amount.x,spawn_NPC_spread_amount.y))
		bonus_spread_chance = 0
	else: 
		bonus_spread_chance = clampf(bonus_spread_chance + bonus_spread_increase, 0, bonus_spread_max)
		print("[ServerWindow] Rolld = ",randf,", no corruption. Bonus spread chance now +",bonus_spread_chance)
