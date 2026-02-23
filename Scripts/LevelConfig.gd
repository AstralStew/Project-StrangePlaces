class_name LevelConfig extends Resource


@export_category("General")

@export var number_of_starting_players : int = 420
@export var mins_before_server_restart : int = 5
@export var corruption_active : bool = false

@export_category("Taking damage")

@export var cost_of_taking_damage : Vector2 = Vector2(3,7)
@export var chance_to_msg_about_taking_damage : float = 0.65

@export_category("Spawning in sight")

@export var cost_of_spawning_in_frustrum : Vector2 = Vector2(3,7)
@export var chance_to_msg_about_seeing_spawn : float = 1.0


@export_category("Destroying in sight")

@export var cost_of_destroying_in_frustrum : Vector2 = Vector2(3,7)
@export var chance_to_msg_about_destroying_in_frustrum : float = 1.0

@export_category("Not feeling engaged")

@export var engagement_time_added_when_seeing_new_enemy : float = 3
@export var engagement_time_maximum_when_seeing_new_enemies : float = 15
@export var cost_of_no_engagement_from_lack_of_enemies : Vector2 = Vector2(13,17)
@export var chance_to_msg_about_no_engagement : float = 1.0


@export_category("Not finding the NPC")
 
@export var cost_of_not_finding_the_NPC : Vector2 = Vector2(8,12)
@export var chance_to_msg_about_not_finding_NPC : float = 0.65


@export_category("Corruption Spread")
@export var chance_to_spread_corruption_when_spawn_slime : float = 0.05
@export var amount_of_corruption_when_spawn_slime : Vector2i = Vector2i(1,2)


@export var chance_to_spread_corruption_when_spawn_NPC : float = 0.15
@export var amount_of_corruption_when_spawn_NPC : Vector2i = Vector2i(2,4)

@export var cumulative_bonus_to_spread_chance_on_fail : float = 0.06
@export var max_bonus_to_spread_chance_on_fail : float = 0.36

@export var  bonus_corruption_when_a_slime_gets_corrupted : Vector2i = Vector2i(1,1)
@export var  bonus_corruption_when_a_NPC_gets_corrupted : Vector2i = Vector2i(1,2)


@export_category("Corruption Effects")

@export var  tick_rate_to_check_whether_to_corrupt_mob : float = 0.5
@export var  chance_to_corrupt_a_slime_on_tick : float = 0.01
@export var  chance_to_corrupt_a_NPC_on_tick : float = 0.02
@export var  chance_to_corrupt_map_tile_on_click : float = 0.5


@export_category("Restarting Drive")
@export var  time_to_restart_drive : float = 10
@export var  percentage_of_corrupt_cubes_to_recover : float = 0.9

func _init() -> void:
	number_of_starting_players = 420
	mins_before_server_restart = 5
	cost_of_taking_damage = Vector2(3,7)
	chance_to_msg_about_taking_damage = 0.65

	cost_of_spawning_in_frustrum = Vector2(3,7)
	chance_to_msg_about_seeing_spawn = 1.0

	cost_of_destroying_in_frustrum = Vector2(3,7)
	chance_to_msg_about_destroying_in_frustrum = 1.0

	engagement_time_added_when_seeing_new_enemy = 3
	engagement_time_maximum_when_seeing_new_enemies = 15
	cost_of_no_engagement_from_lack_of_enemies = Vector2(13,17)
	chance_to_msg_about_no_engagement = 1.0
	
	cost_of_not_finding_the_NPC = Vector2(8,12)
	chance_to_msg_about_not_finding_NPC = 0.65
	
	corruption_active = false
	
	chance_to_spread_corruption_when_spawn_slime = 0.05
	amount_of_corruption_when_spawn_slime = Vector2i(1,2)
	chance_to_spread_corruption_when_spawn_NPC = 0.15
	amount_of_corruption_when_spawn_NPC = Vector2i(2,4)

	cumulative_bonus_to_spread_chance_on_fail = 0.06
	max_bonus_to_spread_chance_on_fail = 0.36

	bonus_corruption_when_a_slime_gets_corrupted = Vector2i(1,1)
	bonus_corruption_when_a_NPC_gets_corrupted = Vector2i(1,2)
	
	tick_rate_to_check_whether_to_corrupt_mob = 0.5
	chance_to_corrupt_a_slime_on_tick = 0.01
	chance_to_corrupt_a_NPC_on_tick = 0.02
	chance_to_corrupt_map_tile_on_click = 0.5
		
	time_to_restart_drive = 10
	percentage_of_corrupt_cubes_to_recover = 0.9
