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
	
	level.level_finished.connect(end_level)
	
	preamble()




func preamble() -> void:
	await get_tree().create_timer(3).timeout
	email_window.activate_email(current_level,EmailWindow.Type.Start)
	await get_tree().create_timer(5).timeout
	
	credentials.visible = true


func start_level() -> void:
	
	email_window.deactivate_email()
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
	game_logo.visible = false
	
	level.process_mode = Node.PROCESS_MODE_INHERIT
	await get_tree().process_frame
	level.call_deferred("start_level",_levelConfig)
	level.set_deferred("visible",true)


func end_level(won:bool) -> void:
	print("[Desktop] End level - we ", "won!" if won else "lost!")
	softwareBG.visible = true
	level.visible = false
	level.set_deferred("process_mode",Node.PROCESS_MODE_DISABLED)
	
	await get_tree().create_timer(3).timeout
	
	print("[Desktop] Checking if we won...")
	if won:
		print("[Desktop] We won!")
		if current_level != Level.CurrentLevel.Level4:
						
			print("[Desktop] Setting current level")
			match current_level:
				Level.CurrentLevel.Level1:
					print("[Desktop] Level1! Moving to Level2")
					current_level = Level.CurrentLevel.Level2
				Level.CurrentLevel.Level2:
					print("[Desktop] Level2! Moving to Level3")
					current_level = Level.CurrentLevel.Level3
				Level.CurrentLevel.Level3:
					print("[Desktop] Level3! Moving to Level4")
					current_level = Level.CurrentLevel.Level4
			
			email_window.activate_email(current_level,EmailWindow.Type.Start)
			
			await get_tree().create_timer(5).timeout
			credentials.visible = true
		else:
			print("[Desktop] Activating email window loss= ",current_level)
			email_window.activate_email(current_level,EmailWindow.Type.Lose)
	else:
		print("[Desktop] Activating email window loss = ",current_level)
		email_window.activate_email(current_level,EmailWindow.Type.Lose)
	
