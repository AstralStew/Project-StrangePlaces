class_name Level extends Node2D


@onready var main_character : MainCharacter = get_tree().get_first_node_in_group("MainCharacter")
@onready var chat_window : ChatWindow = get_tree().get_first_node_in_group("ChatWindow")
@onready var mob_manager : MobManager = get_tree().get_first_node_in_group("MobManager")
@onready var quest_window : QuestWindow = get_tree().get_first_node_in_group("QuestWindow")

@onready var level_ui_canvas : CanvasLayer = get_child(0)





func start_level() -> void:
	chat_window.level_start()
	mob_manager.level_start()
	quest_window.level_start()
	main_character.level_start()
	level_ui_canvas.visible = true
	#main_character.call_deferred("level_start")
