class_name ServerWindow extends VirtualWindow


@onready var data_cube = preload("res://Scenes/data_cube.tscn")
@onready var cube_grid = $VBoxContainer/ServerWindow/MarginContainer/VBoxContainer/DataCubeHolderPanel/CenterContainer/DataCubeGrid

@export_category("CONTROLS")
@export var number_of_data_cubes : int = 96
@export var healthy_colour : Color = Color.hex(0x2e96ff)
@export var corrupted_colour : Color = Color.hex(0xef00f0)

@export_category("READ ONLY")
@export var healthy_cubes : Array[Panel] = []
@export var corrupted_cubes : Array[Panel] = []



@export var corruption : int = 0 :
	get: return corrupted_cubes.size()

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
