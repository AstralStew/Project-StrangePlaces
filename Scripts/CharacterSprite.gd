class_name CharacterSprite extends Sprite2D

@onready var main_character : MainCharacter = get_parent()

@export var fade_colour_speed = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_character.took_damage.connect(took_damage)

func took_damage() -> void:
	modulate = Color.RED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if modulate != Color.WHITE:
		modulate = modulate.lightened(fade_colour_speed * delta)
