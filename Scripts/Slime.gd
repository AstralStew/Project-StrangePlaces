class_name Slime extends Enemy



func reached_player() -> void:
	reset()
	player.lose_health(damage)
