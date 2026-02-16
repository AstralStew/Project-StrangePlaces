class_name Enemy extends CharacterBody2D

@export_category("REFERENCES")

@export var player : MainCharacter = null
@export var timer : Timer = null

@export_category("CONTROLS")

@export var reset_on_start : bool = true
@export var speed : float = 5
@export var activation_distance : float = 50
@export var damage : float = 5

@export_category("READ ONLY")

@export var awake : bool = false
@export var dir : Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func setup() -> void:
	timer.timeout.connect(find_player)	
	if reset_on_start: reset()



func _physics_process(delta: float) -> void:
	if awake:
		move_around()
		move_and_slide()


func find_player() -> void:
	
	dir = player.global_position - global_position
	if !awake && dir.length_squared() < (activation_distance * activation_distance):
		wake_up()

func move_around() -> void:
	find_player()
	velocity = dir.normalized() * speed


func wake_up() -> void:
	print("[Enemy(",self,")] I am awake")
	awake = true



func reset() -> void:
	awake = false
	dir = Vector2.ZERO
	global_position = Vector2( randf_range(-100,1200),randf_range(-100,1000) )


## NOT WORKING FOR SOME REASON
func _on_body_2d_body_entered(body: Node2D) -> void:
	print("[Enemy(",self,")] Body entered = ", body)
	
	if body == (player as Node2D):
		reset()
		player.lose_health(damage)


func _on_area_2d_area_entered(area: Area2D) -> void:
	print("[Enemy(",self,")] Area entered = ", area)
	
	if area.name.contains("Weapon"):
		reset()
	elif area.name.contains("Hurtbox"): 
		reset()
		player.lose_health(damage)
	
