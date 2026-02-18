class_name Slime extends Enemy

@export_category("CONTROLS")

@export var awake_position_speed : float = 5
@export var awake_position_amount : Vector2 = Vector2(0,0.5)


func _sprite_effects_on_move(delta) -> void:
	
	var new_position = sin(sprite_moving_timer * awake_position_speed) * awake_position_amount
	sprite.position = initial_sprite_pos + new_position
	
	super._sprite_effects_on_move(delta)



func reached_character() -> void:
	if dying || !awake: return
	#super.reached_character()
	if _debugging: print("[",name,")] Slime reached the player!")
	main_character.lose_health(damage)
	lose_health(health)
