class_name Enemy extends CharacterBody2D


@onready var sprite : Sprite2D = $Sprite2D
@onready var shadow : Sprite2D = $Sprite2D/Shadow
@onready var body_collider : CollisionShape2D = $BodyCollider

@export var _debugging : bool = false

@export_category("REFERENCES")

@export var main_character : MainCharacter = null
@export var timer : Timer = null
@export var healthbar : ProgressBar = null

@export_category("CONTROLS")

@export var reset_on_start : bool = true
@export var max_health : float = 1
@export var speed : float = 5
@export var damage : float = 5
@export var activation_distance : float = 50

@export_category("MOVEMENT")

@export var moving_rotation_speed : float = 18
@export var moving_rotation_amount : float = 0.05
@export var moving_position_speed : float = 5
@export var moving_position_amount : Vector2 = Vector2(0,0.5)
@export var reached_distance : float = 1
@export var reached_leave_margin : float = 1

@export_category("DEATH")

@export var death_speed : float = 1.0
@export var death_rotation_speed : float = 0.3
@export var death_rotation_amount : float = 1.0
@export var death_position_speed : float = 2.0
@export var death_position_amount : Vector2 = Vector2(0,-5)

@export_category("READ ONLY")

@export var awake : bool = false
@export var moving : bool = false
@export var dying : bool = false
@export var near_character : bool = false
@export var dir : Vector2 = Vector2.ZERO
@export var health : float = 1

@onready var initial_sprite_pos : Vector2 = sprite.position
@onready var initial_sprite_color : Color = sprite.self_modulate
@onready var initial_shadow_color : Color = shadow.self_modulate


signal on_awake
signal on_reached_character
signal on_took_damage


# Called when the node enters the scene tree for the first time.
func setup() -> void:
	healthbar = $Healthbar
	timer.timeout.connect(find_player)
	if reset_on_start: reset()

func reset() -> void:
	awake = false
	near_character = false
	dir = Vector2.ZERO
	
	healthbar.value = max_health
	healthbar.max_value = max_health


var sprite_moving_timer = 0.0
var sprite_die_timer = 0.0
func _physics_process(delta: float) -> void:
	if dying:
		sprite_die_timer += delta
		_sprite_effects_on_die(delta)
	elif awake:
		if moving:
			sprite_moving_timer += delta
			_sprite_effects_on_move(delta)
			move_to_player()
			move_and_slide()

func _sprite_effects_on_move(delta) -> void:
	if moving_rotation_amount != 0:
		var new_rotation = sin(sprite_moving_timer * moving_rotation_speed) * moving_rotation_amount
		sprite.rotation = 0 + new_rotation
	if moving_position_amount != Vector2.ZERO:
		var new_position = sin(sprite_moving_timer * moving_position_speed) * moving_position_amount
		sprite.position = initial_sprite_pos + new_position

func move_to_player() -> void:
	find_player()
	velocity = dir.normalized() * speed


func find_player() -> void:
	dir = (main_character.global_position - global_position)
		
	if awake:
		
		if near_character && dir.length_squared() > ((reached_distance + reached_leave_margin) ** 2):
			print("player left")
			near_character = false
		
		# Reach the player if in range
		if !near_character && dir.length_squared() < (reached_distance ** 2):
			near_character = true
			on_reached_character.emit()
			reached_character()
	
	# Wake up if player is in range
	if !awake && dir.length_squared() < (activation_distance ** 2):
		wake_up()
		main_character.saw_enemy.emit()
	



func wake_up() -> void:
	if dying: return
	if _debugging: print("[Enemy(",self,")] I am awake")
	awake = true
	moving = true
	on_awake.emit()


func reached_character() -> void:
	if _debugging: print("[Enemy(",self,")] Default 'reached character' (does nothing)")



## NOT WORKING FOR SOME REASON
#func _on_hurtbox_body_entered(body: Node2D) -> void:
	#if _debugging: print("[Enemy(",self,")] Body entered = ", body)
	#
	#if body == (main_character as Node2D):
		#reset()
		#main_character.lose_health(damage)


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if dying: return
	if _debugging: print("[Enemy(",self,")] Area entered = ", area)
	
	if area.name.contains("Weapon"):
		hit_by_weapon()
	


func hit_by_weapon() -> void:
	if _debugging: print("[Enemy(",self,")] Default hit by weapon...")
	lose_health(main_character.weapon_damage)

func lose_health(amount:float) -> void:
	if dying: return
	health = maxi(health-amount,0)
	if _debugging: print("[Enemy(",self,")] Lost ",amount," health, new health = ",health)
	
	on_took_damage.emit()
	
	# Check if they are dead
	if health <= 0:
		die()
		return
	
	healthbar.value = health	

func die() -> void:
	if dying: return
	if _debugging: print("[Enemy(",self,")] Dying.")
	dying = true
	awake = false
	body_collider.set_deferred("disabled", true)
	sprite_die_timer = 0.0
	healthbar.visible = false
	await get_tree().create_timer(death_speed).timeout
	queue_free()

func _sprite_effects_on_die(delta) -> void:
	var new_position = sin(sprite_die_timer * death_position_speed) * death_position_amount
	sprite.position = initial_sprite_pos + new_position
	var new_rotation = sin(sprite_die_timer * death_rotation_speed) * death_rotation_amount
	sprite.rotation = 0 + new_rotation
	
	sprite.self_modulate = initial_sprite_color.lerp(Color(Color.RED,0),sprite_die_timer/death_speed)
	shadow.self_modulate = initial_shadow_color.lerp(Color(initial_shadow_color,0),sprite_die_timer/death_speed)
