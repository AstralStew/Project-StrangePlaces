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
