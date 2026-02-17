class_name MainCharacter extends CharacterBody2D


@onready var weapon = $Weapon
@onready var healthbar = $Healthbar

@export_category("MOVEMENT")
@export var speed : float = 5
@export var moving_time : Vector2 = Vector2(3,10)
@export var waiting_time : Vector2 = Vector2(1,4)
@export_category("WEAPON")
@export var weapon_time : float = 1
@export var weapon_damage : float = 5
@export var weapon_distance : float = 10


@export_category("READ ONLY")

@export var health : float = 100.0
@export var direction : Vector2 = Vector2.ZERO
@export var attacking : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	weapon.visible = false
	healthbar.value = 100
	pick_direction()


func lose_health(amount:float) -> void:
	health = maxi(health-amount,0)
	print("[MainCharacter] Losing ",amount," health, new health = ",health)	
	healthbar.value = health



func _process(delta: float) -> void:
	if !attacking && Input.is_action_just_pressed("Attack"):
		attack()


func _physics_process(delta: float) -> void:
	velocity = direction * speed 
	move_and_slide()


func pick_direction() -> void:
	
	while (true):
		
		direction = Vector2(randf_range(-1,1),randf_range(-1,1)).normalized()
		await get_tree().create_timer(randf_range(moving_time.x,moving_time.y)).timeout
		direction = Vector2.ZERO
		await get_tree().create_timer(randf_range(waiting_time.x,waiting_time.y)).timeout



func attack() -> void:
	attacking = true	
	set_weapon(true)
	await get_tree().create_timer(weapon_time).timeout
	set_weapon(false)
	attacking = false


func set_weapon(enable:bool) -> void:
	if enable:
		var mouse_dir = (get_global_mouse_position() - global_position).normalized()
		weapon.position = mouse_dir * weapon_distance
		weapon.visible = true
		weapon.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		weapon.position = Vector2.ZERO
		weapon.visible = false
		weapon.process_mode = Node.PROCESS_MODE_DISABLED
