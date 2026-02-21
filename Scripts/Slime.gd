class_name Slime extends Enemy




func reached_character() -> void:
	if dying || !awake: return
	#super.reached_character()
	if _debugging: print("[",name,")] Slime reached the player!")	
	audio_enemy_fx.play()
	main_character.lose_health(damage)
	lose_health(health)
