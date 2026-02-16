class_name MainCharacter extends CharacterBody2D

@export var speed : float = 5
@export var moving_time : Vector2 = Vector2(3,10)
@export var waiting_time : Vector2 = Vector2(1,4)

var direction : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pick_direction()


func _physics_process(delta: float) -> void:
	velocity = direction * speed 
	move_and_slide()

func pick_direction() -> void:
	
	while (true):
		
		direction = Vector2(randf_range(-1,1),randf_range(-1,1)).normalized()
		await get_tree().create_timer(randf_range(moving_time.x,moving_time.y)).timeout
		direction = Vector2.ZERO		
		await get_tree().create_timer(randf_range(waiting_time.x,waiting_time.y)).timeout
