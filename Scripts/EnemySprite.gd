class_name EnemySprite extends MobSprite

@onready var enemy : Enemy = get_parent()
@onready var healthbar : ProgressBar = $"../Healthbar"
@export var corrupt_healthbar_style : StyleBoxFlat = null


@export var corrupt_healthbar_skew : Vector2 = Vector2(0.5,0.1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	
	enemy.on_took_damage.connect(took_damage)


func took_damage() -> void:
	modulate = Color.RED

func _set_corrupt_materials() -> void:
	super._set_corrupt_materials()
	healthbar.add_theme_stylebox_override("background",corrupt_healthbar_style.duplicate())
	healthbar.add_theme_stylebox_override("fill",corrupt_healthbar_style.duplicate())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if corrupted:
		(healthbar.get_theme_stylebox("fill") as StyleBoxFlat).skew = glitch_amount * corrupt_healthbar_skew
	
	if enemy.moving:
		if enemy.dir.x > 0:
			facing_right = true
		elif enemy.dir.x < 0:
			facing_right = false
	
	#if modulate != Color.WHITE:
		#modulate = modulate.lightened(fade_colour_speed * delta)
