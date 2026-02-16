class_name Enemy extends CharacterBody2D

@export var speed : float = 5
var player : Node2D = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]
	reset()


func _physics_process(delta: float) -> void:
	find_player(delta)
	move_and_slide()

func find_player(delta:float) -> void:
	
	var direction : Vector2 = (player.global_position - global_position).normalized()
	velocity = direction * speed


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("body = ", body)
	if body == player:
		reset()

func reset() -> void:
	global_position = Vector2( randf_range(-100,1200),randf_range(-100,1000) )
