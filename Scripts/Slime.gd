class_name Slime extends Enemy


@onready var server_window : ServerWindow = get_tree().get_first_node_in_group("ServerWindow")


func reached_character() -> void:
	if dying || !awake: return
	#super.reached_character()
	if _debugging: print("[",name,")] Slime reached the player!")
	if corrupted:
		audio_glitch_fx.play()
		server_window.corrupt(1)
	else:
		audio_enemy_fx.play()
		main_character.lose_health(damage)
		lose_health(health)
