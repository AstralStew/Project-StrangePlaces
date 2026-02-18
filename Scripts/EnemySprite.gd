class_name EnemySprite extends MobSprite

@onready var enemy : Enemy = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy.on_took_damage.connect(took_damage)


func took_damage() -> void:
	modulate = Color.RED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if enemy.moving:
		if enemy.dir.x > 0:
			facing_right = true
		elif enemy.dir.x < 0:
			facing_right = false
	
	if modulate != Color.WHITE:
		modulate = modulate.lightened(fade_colour_speed * delta)
