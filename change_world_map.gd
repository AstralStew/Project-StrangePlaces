extends Node2D

@onready var Plains: TileMapLayer = $Plains
@onready var Water: TileMapLayer = $Plains/Water
@onready var Plains2: TileMapLayer = $Plains/Plains2

var tileSetNumber = 1
var grassTile = Vector2i(1,1)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		
		var mousePosition = get_global_mouse_position()
		var PlainsTilePosition = Plains.local_to_map(mousePosition - Plains.global_position)
		var WaterTilePosition = Water.local_to_map(mousePosition - Water.global_position)
		var Plains2TilePosition = Plains2.local_to_map(mousePosition - Plains2.global_position)
		
		var PlainsCoords = Plains.get_cell_atlas_coords(PlainsTilePosition)
		var WaterCoords = Water.get_cell_atlas_coords(WaterTilePosition)
		var Plains2Coords = Plains2.get_cell_atlas_coords(Plains2TilePosition)

		if Input.is_action_just_pressed("AdminAttackTool"):
			#print("Ding, tilePosition = " ,tilePosition, " tileSetNumber = ", tileSetNumber)
			Plains.set_cell(PlainsTilePosition, tileSetNumber, PlainsCoords)
			Water.set_cell(WaterTilePosition, tileSetNumber, WaterCoords)
			Plains2.set_cell(Plains2TilePosition, tileSetNumber, Plains2Coords)
