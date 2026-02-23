class_name WorldMap extends Node2D

@onready var server_window : ServerWindow = get_tree().get_first_node_in_group("ServerWindow")

@export var chance_to_corrupt_map_tile = 0.5

@onready var Plains: TileMapLayer = $Plains
@onready var Water: TileMapLayer = $Plains/Water
@onready var Plains2: TileMapLayer = $Plains/Plains2

@export var corrupted_tiles : Array[Vector2i] = []

@export var new_tiles_per_spread : Vector2i = Vector2i(3,6)
@export var adjacent_tiles_per_spread : Vector2i = Vector2i(5,10)
#@export var heal_time_per_tile : float = 0.1

var healthyTileSet = 0
var corruptedTileSet = 1
#var grassTile = Vector2i(1,1)

func _ready() -> void:
	server_window.on_corrupt.connect(spread)
	server_window.server_restart_start.connect(heal)


func _input(event: InputEvent) -> void:
	if !GlobalVariables.corruption_active || server_window.restarting: return
	
	if event is InputEventMouseButton && Input.is_action_just_pressed("AdminAttackTool"):
		
		if randf() < chance_to_corrupt_map_tile:
			
			var tilePosition = Plains.local_to_map(get_global_mouse_position() - Plains.global_position)
			corrupt_tile(tilePosition)

func spread():
	var tile : Vector2i
	
	if corrupted_tiles.size() > 0:
		for i in adjacent_tiles_per_spread:
			tile = corrupted_tiles[randi() % corrupted_tiles.size()]
			tile = tile + Vector2i(randi_range(-1,1),randi_range(-1,1))
			if !corrupted_tiles.has(tile):
				corrupt_tile(tile)
	
	for i in randi_range(new_tiles_per_spread.x,new_tiles_per_spread.y):
		tile = Plains.local_to_map(Vector2(randi_range(0,1400),randi_range(0,800)))
		if !corrupted_tiles.has(tile):
			corrupt_tile(tile)

func heal():
	
	print("Number of corrupted tiles: ", corrupted_tiles.size())
	var size : int = corrupted_tiles.size()
	var time : float = (server_window.time_to_restart_drive - 1) / size
	
	for tile in size:
		
		var PlainsCoords = Plains.get_cell_atlas_coords(corrupted_tiles[tile])
		var WaterCoords = Water.get_cell_atlas_coords(corrupted_tiles[tile])
		var Plains2Coords = Plains2.get_cell_atlas_coords(corrupted_tiles[tile])
	
		Plains.set_cell(corrupted_tiles[tile], healthyTileSet, PlainsCoords)
		Water.set_cell(corrupted_tiles[tile], healthyTileSet, WaterCoords)
		Plains2.set_cell(corrupted_tiles[tile], healthyTileSet, Plains2Coords)
		
		if server_window.restarting:
			await get_tree().create_timer(time).timeout
	
	corrupted_tiles.clear()
	
	print("Number of corrupted tiles: ", corrupted_tiles.size())
	


func corrupt_tile(tile_position:Vector2i):
	
	if !corrupted_tiles.has(tile_position):
		corrupted_tiles.append(tile_position)
		
		var PlainsCoords = Plains.get_cell_atlas_coords(tile_position)
		var WaterCoords = Water.get_cell_atlas_coords(tile_position)
		var Plains2Coords = Plains2.get_cell_atlas_coords(tile_position)
		
		Plains.set_cell(tile_position, corruptedTileSet, PlainsCoords)
		Water.set_cell(tile_position, corruptedTileSet, WaterCoords)
		Plains2.set_cell(tile_position, corruptedTileSet, Plains2Coords)
