class_name CharacterSprite extends AnimatedSprite2D

@onready var main_character : MainCharacter = get_parent()
@onready var chat_bubble : AnimatedSprite2D = $"../ChatBubble"

@export var fade_colour_speed = 1.0

var moving : bool = false :
	get: return main_character.moving


var facing_right : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flip(false)
	main_character.took_damage.connect(took_damage)

func flip(face_right:bool):
	flip_h = face_right
	chat_bubble.flip_h = face_right
	offset.x = 20 if face_right else 0
	chat_bubble.offset.x = 60 if face_right else -60


func took_damage() -> void:
	self_modulate = Color.RED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
		
	if moving:
		if animation != "walk":
			animation = "walk"
	else:
		animation = "idle"
	
	if facing_right != main_character.is_dir_rightward:
		facing_right = main_character.is_dir_rightward
		flip(facing_right)
	
	if self_modulate != Color.WHITE:
		self_modulate = self_modulate.lightened(fade_colour_speed * delta)
