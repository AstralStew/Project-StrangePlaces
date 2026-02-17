class_name Enemy extends CharacterBody2D

@export var _debugging : bool = false

@export_category("REFERENCES")

@export var player : MainCharacter = null
@export var timer : Timer = null
@export var healthbar : ProgressBar = null

@export_category("CONTROLS")

@export var reset_on_start : bool = true
@export var max_health : float = 1
@export var speed : float = 5
@export var activation_distance : float = 50
@export var damage : float = 5

@export_category("READ ONLY")

@export var awake : bool = false
@export var dir : Vector2 = Vector2.ZERO
@export var health : float = 1


# Called when the node enters the scene tree for the first time.
func setup() -> void:
	healthbar = $Healthbar
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
	if _debugging: print("[Enemy(",self,")] I am awake")
	awake = true



func reset() -> void:
	awake = false
	dir = Vector2.ZERO
	
	healthbar.value = max_health
	healthbar.max_value = max_health
	


## NOT WORKING FOR SOME REASON
func _on_hurtbox_body_entered(body: Node2D) -> void:
	if _debugging: print("[Enemy(",self,")] Body entered = ", body)
	
	if body == (player as Node2D):
		reset()
		player.lose_health(damage)


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if _debugging: print("[Enemy(",self,")] Area entered = ", area)
	
	if area.name.contains("Weapon"):
		hit_by_weapon()
	elif area.name.contains("HurtBox"): 
		reached_player()
	

func reached_player() -> void:
	if _debugging: print("[Enemy(",self,")] Default reached player (does nothing)")

func hit_by_weapon() -> void:
	if _debugging: print("[Enemy(",self,")] Default hit by weapon...")
	lose_health(player.weapon_damage)

func lose_health(amount:float) -> void:
	health = maxi(health-amount,0)
	if _debugging: print("[Enemy(",self,")] Lost ",amount," health, new health = ",health)
	
	# Check if they are dead
	if health <= 0:
		die()
		return
	
	healthbar.value = health

func die() -> void:
	if _debugging: print("[Enemy(",self,")] Dying.")
	queue_free()
