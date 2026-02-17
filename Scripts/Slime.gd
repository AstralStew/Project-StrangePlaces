class_name Slime extends Enemy



func reached_player() -> void:
	if _debugging: print("[",name,")] Slime reached the player!")
	player.lose_health(damage)
	die()
