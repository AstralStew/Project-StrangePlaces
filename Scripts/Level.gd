class_name Level extends Node2D

enum CurrentLevel {Level1, Level2, Level3, Level4}

@export var main_character : MainCharacter #= get_tree().get_first_node_in_group("MainCharacter")
@export var chat_window : ChatWindow #= get_tree().get_first_node_in_group("ChatWindow")
@export var mob_manager : MobManager #= get_tree().get_first_node_in_group("MobManager")
@export var quest_window : QuestWindow #= get_tree().get_first_node_in_group("QuestWindow")
@export var frustration_manager : FrustrationManager #= get_tree().get_first_node_in_group("FrustrationManager")
@export var server_window : ServerWindow #= get_tree().get_first_node_in_group("ServerWindow")
@export var world_map : WorldMap #= get_tree().get_first_node_in_group("WorldMap")

@export var level_ui_canvas : CanvasLayer #= get_child(0)

signal level_finished(won)


func start_level(_levelConfig:LevelConfig) -> void:
	
	main_character = get_tree().get_first_node_in_group("MainCharacter")
	chat_window = get_tree().get_first_node_in_group("ChatWindow")
	mob_manager = get_tree().get_first_node_in_group("MobManager")
	quest_window = get_tree().get_first_node_in_group("QuestWindow")
	frustration_manager = get_tree().get_first_node_in_group("FrustrationManager")
	server_window = get_tree().get_first_node_in_group("ServerWindow")
	world_map = get_tree().get_first_node_in_group("WorldMap")
	level_ui_canvas = get_child(0)
	
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
	server_window.visible = GlobalVariables.corruption_active
	
	
	server_window.spawn_slime_spread_chance = _levelConfig.chance_to_spread_corruption_when_spawn_slime
	server_window.spawn_slime_spread_amount = _levelConfig.amount_of_corruption_when_spawn_slime
	server_window.spawn_NPC_spread_chance = _levelConfig.chance_to_spread_corruption_when_spawn_NPC
	server_window.spawn_NPC_spread_amount = _levelConfig.amount_of_corruption_when_spawn_NPC

	server_window.bonus_spread_increase =_levelConfig.cumulative_bonus_to_spread_chance_on_fail
	server_window.bonus_spread_max =_levelConfig.max_bonus_to_spread_chance_on_fail

	server_window.tick_slime_spread_amount =_levelConfig.bonus_corruption_when_a_slime_gets_corrupted
	server_window.tick_NPC_spread_amount =_levelConfig.bonus_corruption_when_a_NPC_gets_corrupted

	mob_manager.tick_rate = _levelConfig.tick_rate_to_check_whether_to_corrupt_mob
	mob_manager.slime_tick_chance = _levelConfig.chance_to_corrupt_a_slime_on_tick
	mob_manager.npc_tick_chance =_levelConfig.chance_to_corrupt_a_NPC_on_tick
	
	world_map.chance_to_corrupt_map_tile = _levelConfig.chance_to_corrupt_map_tile_on_click
	
	server_window.time_to_restart_drive = _levelConfig.time_to_restart_drive	
	server_window.percentage_cubes_recovered = _levelConfig.percentage_of_corrupt_cubes_to_recover
	
	
	await get_tree().process_frame
	
	chat_window.level_finished.connect(on_level_finished)
	
	chat_window.level_start()
	mob_manager.level_start()
	quest_window.level_start()
	main_character.level_start()
	level_ui_canvas.visible = true
	#main_character.call_deferred("level_start")

func on_level_finished(won:bool):
	level_finished.emit(won)
	level_ui_canvas.visible = false
	
