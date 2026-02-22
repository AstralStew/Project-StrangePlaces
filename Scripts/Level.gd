class_name Level extends Node2D

enum CurrentLevel {Level1, Level2, Level3, Level4}

@onready var main_character : MainCharacter = get_tree().get_first_node_in_group("MainCharacter")
@onready var chat_window : ChatWindow = get_tree().get_first_node_in_group("ChatWindow")
@onready var mob_manager : MobManager = get_tree().get_first_node_in_group("MobManager")
@onready var quest_window : QuestWindow = get_tree().get_first_node_in_group("QuestWindow")
@onready var frustration_manager : FrustrationManager = get_tree().get_first_node_in_group("FrustrationManager")

@onready var level_ui_canvas : CanvasLayer = get_child(0)




#@export_category("General")
#
#@export var number_of_starting_players : int = 420
#@export var mins_before_server_restart : int = 5
#
#
#@export_category("Taking damage")
#
#@export var cost_of_taking_damage : Vector2 = Vector2(3,7)
#@export var chance_to_msg_about_taking_damage : float = 0.65
#
#@export_category("Spawning in sight")
#
#@export var cost_of_spawning_in_frustrum : Vector2 = Vector2(3,7)
#@export var chance_to_msg_about_seeing_spawn : float = 1.0
#
#
#@export_category("Destroying in sight")
#
#@export var cost_of_destroying_in_frustrum : Vector2 = Vector2(3,7)
#@export var chance_to_msg_about_destroying_in_frustrum : float = 1.0
#
#@export_category("Not feeling engaged")
#
#@export var engagement_time_added_when_seeing_new_enemy : float = 3
#@export var engagement_time_maximum_when_seeing_new_enemies : float = 15
#@export var cost_of_no_engagement_from_lack_of_enemies : Vector2 = Vector2(13,17)
#@export var chance_to_msg_about_no_engagement : float = 1.0
#
#
#@export_category("Not finding the NPC")
 #
#@export var cost_of_not_finding_the_NPC : Vector2 = Vector2(8,12)
#@export var chance_to_msg_about_not_finding_NPC : float = 0.65



func start_level(_levelConfig:LevelConfig) -> void:
	
	print("levelconfig number of starting players = ",_levelConfig.number_of_starting_players)
	
	chat_window.starting_player_count = _levelConfig.number_of_starting_players
	chat_window.game_length_mins = _levelConfig.mins_before_server_restart
	
	chat_window.cost_of_no_auto_attack = _levelConfig.cost_of_taking_damage
	frustration_manager.took_damage_msg_chance = _levelConfig.chance_to_msg_about_taking_damage
	
	chat_window.cost_of_see_spawn_in = _levelConfig.cost_of_spawning_in_frustrum
	frustration_manager.saw_spawn_in_msg_chance = _levelConfig.chance_to_msg_about_seeing_spawn
	
	chat_window.cost_of_see_destroy = _levelConfig.cost_of_destroying_in_frustrum
	frustration_manager.saw_destroyed_msg_chance = _levelConfig.chance_to_msg_about_destroying_in_frustrum
	
	chat_window.cost_of_cant_find_enemies = _levelConfig.cost_of_no_engagement_from_lack_of_enemies
	frustration_manager.no_enemies_msg_chance = _levelConfig.chance_to_msg_about_no_engagement
	
	frustration_manager.no_enemies_max_time = _levelConfig.engagement_time_maximum_when_seeing_new_enemies
	frustration_manager.saw_enemy_add_to_time = _levelConfig.engagement_time_added_when_seeing_new_enemy
	
	chat_window.cost_of_cant_find_NPC = _levelConfig.cost_of_not_finding_the_NPC
	frustration_manager.no_npc_msg_chance = _levelConfig.chance_to_msg_about_not_finding_NPC
	
	GlobalVariables.corruption_active = _levelConfig.corruption_active
	
	await get_tree().process_frame
	
	chat_window.level_start()
	mob_manager.level_start()
	quest_window.level_start()
	main_character.level_start()
	level_ui_canvas.visible = true
	#main_character.call_deferred("level_start")
