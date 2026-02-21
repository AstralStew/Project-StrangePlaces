class_name MobSprite extends Sprite2D

@export var fade_colour_speed = 1.0

var facing_right : bool = false :
	set(value): 
		if value == flip_h: return
		flip_h = value
		offset.x = 20 if flip_h else 0

func took_damage() -> void:
	modulate = Color.RED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if modulate != Color.WHITE:
		modulate = modulate.lightened(fade_colour_speed * delta)
