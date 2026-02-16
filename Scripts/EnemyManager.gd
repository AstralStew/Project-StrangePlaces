class_name EnemyManager extends Node

@onready var enemy_timer = $EnemyAwakeTimer
@onready var player = get_tree().get_nodes_in_group("Player")[0]

@export_category("REFERENCES")

@export var number_of_enemies : int = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var enemy_scene = preload("res://Scenes/enemy.tscn")
	
	for i in number_of_enemies:
		var instance = enemy_scene.instantiate() as Enemy
		instance.name = "Enemy" + str(i)
		instance.timer = enemy_timer
		instance.player = player
		instance.setup()
		add_child(instance)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
