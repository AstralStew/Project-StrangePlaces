class_name MainCharacter extends CharacterBody2D


@onready var weapon = $Weapon
@onready var sight_circle : Area2D = $SearchCircle
@onready var sprite = $Sprite2D
@onready var healthbar : ProgressBar = $Healthbar

@export_category("STATS")
@export var max_health : float = 5
@export_category("TRAVELLING")
@export var speed : float = 5
@export var travel_end_distance : float = 4
@export_category("WANDERING")
@export var wander_range : Vector2 = Vector2(2,10)
@export var wander_wait_time : Vector2 = Vector2(1,5)
@export_category("INTERACTING")
@export var npc_interact_time : Vector2 = Vector2(4,6)
@export var npc_end_distance : float = 3

@export_category("ATTACK")
@export var weapon_time : float = 1
@export var weapon_damage : float = 5
@export var weapon_distance : float = 10


@export_category("READ ONLY")

@export var health : float = 100.0
@export var direction : Vector2 = Vector2.ZERO
@export var target : Vector2 = Vector2.ZERO
@export var last_waypoint : Node2D = null

@export var moving : bool = false
@export var attacking : bool = false
@export var wandering : bool = false
@export var travelling : bool = false
@export var interacting : bool = false


var wander_target_reached : bool = false

signal target_reached

signal npc_not_found

signal took_damage

@onready var admin_window : AdminWindow = get_tree().get_first_node_in_group("AdminWindow")

@export var can_attack : bool = false :
	get: return admin_window.selected_tool == AdminWindow.ToolNames.TRIGGER_ATTACK



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_weapon(false)
	set_sight_circle(false)
	health = max_health
	healthbar.value = health
	
	travel()



func lose_health(amount:float) -> void:
	health = maxi(health-amount,0)
	print("[MainCharacter] Losing ",amount," health, new health = ",health)
	healthbar.value = health
	
	took_damage.emit()


func _physics_process(delta: float) -> void:
	
	if moving:
		
		direction = target - global_position
		
		if travelling && direction.length() < travel_end_distance:
			target_reached.emit()
		elif interacting && direction.length() < npc_end_distance:
			target_reached.emit()
		elif direction.length() < 1.0:
			if wandering: wander_target_reached = true
			else: target_reached.emit()
		else:
			velocity = direction.normalized() * speed 
			move_and_slide()





func travel() -> void:
	
	travelling = true
	
	last_waypoint = get_tree().get_nodes_in_group("Waypoints")[randi() % get_tree().get_node_count_in_group("Waypoints")] as Node2D
	target = last_waypoint.global_position
	
	print("[MainCharacter] Travelling - Moving towards '",last_waypoint,"' at ",target)
	
	moving = true
	await target_reached
	print("[MainCharacter] Travelling - Waypoint reached! Transition to wandering...")	
	moving = false
	
	travelling = false
	
	await get_tree().physics_frame
	
	wander()
	





func wander() -> void:
	
	wandering = true
	
	set_sight_circle(true)
	
	var chosen_wait_time = randf_range(wander_wait_time.x,wander_wait_time.y)
	var search_frequency = 0.3 
	var time_waited = 0.0
	var chosen_wander_target = false
	wander_target_reached = false
	
	while (wandering):
		
		# Check if we've waited long enough to pick a new wander target
		if time_waited < chosen_wait_time:
			time_waited += search_frequency
		else:
			# Pick a location near the waypoint to wander to
			if !chosen_wander_target:
				var randv = Vector2(randf_range(-1,1),randf_range(-1,1)).normalized() * randf_range(wander_range.x, wander_range.y)
				target = last_waypoint.global_position + randv
				moving = true
				print("[MainCharacter] Wandering - Wandering towards ",target,"...")
				chosen_wander_target = true
			
			# Reset timer and wait for a while
			if wander_target_reached:
				chosen_wait_time = randf_range(wander_wait_time.x,wander_wait_time.y)
				time_waited = 0
				chosen_wander_target = false
				wander_target_reached = false
				direction = Vector2.ZERO
				moving = false
				print("[MainCharacter] Wandering - Wander target reached! Starting to wait...")
				
				# Could not find the NPC
				npc_not_found.emit()
				
	
		# Wait a while for next search check
		await get_tree().create_timer(search_frequency).timeout
	




func _unhandled_input(event: InputEvent) -> void:
	if can_attack && !attacking && event.is_action_pressed("Attack"):
		attack()


func attack() -> void:
	attacking = true
	set_weapon(true)
	await get_tree().create_timer(weapon_time).timeout
	set_weapon(false)
	attacking = false

func set_weapon(enable:bool) -> void:
	weapon.position = (get_global_mouse_position() - global_position).normalized() * weapon_distance if enable else Vector2.ZERO
	weapon.visible = enable
	weapon.set_deferred("monitoring", enable) 
	weapon.set_deferred("monitorable", enable) 





func set_sight_circle(enable:bool) -> void:
	sight_circle.visible = enable
	sight_circle.set_deferred("monitoring", enable) 
	sight_circle.set_deferred("monitorable", enable) 


func _on_search_circle_body_entered(body: Node2D) -> void:
	print("[MainCharacter(",self,")] Search circle entered = ", body)
	
	# Stop searching for NPC
	wandering = false
	set_sight_circle(false)
	
	
	# Move towards the NPC
	interacting = true
	target = body.global_position
	print("[MainCharacter] Search Finish - Moving towards NPC '",body,"'...")
	
	moving = true
	await target_reached
	print("[MainCharacter] Search Finish - Reached NPC '",body,"', interacting for a while...")
	moving = false
	
	
	# Interact with the NPC
	await get_tree().create_timer(randf_range(npc_interact_time.x,npc_interact_time.y)).timeout 
	(body as NPC).complete_interaction()
	interacting = false
	print("[MainCharacter] Search Finish - Completed interaction with NPC '",body,"', time to travel")
	
	travel()
