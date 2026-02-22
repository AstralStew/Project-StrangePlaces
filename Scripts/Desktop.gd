extends Node

@export var level : Level

@export var game_logo : TextureRect
@export var softwareBG : Panel

@onready var email_window : EmailWindow = get_tree().get_first_node_in_group("EmailWindow")
@onready var credentials : VirtualWindow = $CanvasLayer/Credentials

@export_category("CONTROLS")

@export var current_level : Level.CurrentLevel = Level.CurrentLevel.Level1

@export var level_1_config : LevelConfig = LevelConfig.new()
@export var level_2_config : LevelConfig = LevelConfig.new()
@export var level_3_config : LevelConfig = LevelConfig.new()
@export var level_4_config : LevelConfig = LevelConfig.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	preamble()


func preamble() -> void:
	await get_tree().create_timer(3).timeout
	email_window.activate_email(current_level,EmailWindow.Type.Start)
	await get_tree().create_timer(5).timeout
	
	credentials.visible = true


func start_level() -> void:
	
	email_window.deactivate()
	credentials.visible = false
	
	await get_tree().create_timer(1).timeout
	game_logo.visible = true
	
	var _levelConfig : LevelConfig
	match(current_level):
		Level.CurrentLevel.Level1:
			_levelConfig = level_1_config
			GlobalVariables.level = 1
			
		Level.CurrentLevel.Level2:
			_levelConfig = level_2_config
			GlobalVariables.level = 2
			
		Level.CurrentLevel.Level3:
			_levelConfig = level_3_config
			GlobalVariables.level = 3
			
		Level.CurrentLevel.Level4:
			_levelConfig = level_4_config
			GlobalVariables.level = 4
	
	
	await get_tree().create_timer(3).timeout
	
	softwareBG.visible = false
	
	level.process_mode = Node.PROCESS_MODE_INHERIT
	await get_tree().process_frame
	level.call_deferred("start_level",_levelConfig)
	level.set_deferred("visible",true)
