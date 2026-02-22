class_name MainCharacter extends CharacterBody2D


@onready var weapon = $Weapon
@onready var weapon_particle = preload("res://Scenes/weapon_particle.tscn")
@onready var sight_circle : Area2D = $SearchCircle
@onready var sprite = $Sprite2D
@onready var healthbar : ProgressBar = $Healthbar
@onready var frustration_manager : FrustrationManager = $FrustrationManager
@onready var audio_sword_fx : AudioStreamPlayer = $"../../SwordFx"
@onready var location_label : Label = $FakeCamera/Location

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
@export var weapon_local_offset : Vector2 = Vector2(0,-16)


@export_category("READ ONLY")

@export var health : float = 100.0
@export var direction : Vector2 = Vector2.ZERO
@export var target : Vector2 = Vector2.ZERO

@export var moving : bool = false
@export var attacking : bool = false
@export var wandering : bool = false
@export var travelling : bool = false
@export var interacting : bool = false


@export var is_dir_rightward : bool = false

var wander_target_reached : bool = false


signal target_reached
signal npc_not_found
signal took_damage
signal saw_enemy


@onready var admin_window : AdminWindow = get_tree().get_first_node_in_group("AdminWindow")

@export var can_attack : bool = false :
	get: return admin_window.selected_tab == AdminWindow.Tabs.ATTACKING


@onready var quest_window : QuestWindow = get_tree().get_first_node_in_group("QuestWindow")


func level_start() -> void:
	set_weapon(false)
	set_sight_circle(false)
	health = max_health
	healthbar.value = health
	
	await get_tree().create_timer(3.5).timeout
	
	travel()


func lose_health(amount:float) -> void:
	health = maxi(health-amount,0)
	print("[MainCharacter] Losing ",amount," health, new health = ",health)
	healthbar.value = health
	
	took_damage.emit()


func _physics_process(delta: float) -> void:
	
	if moving:
		
		direction = target - global_position
		
		if direction.x > 0:
			is_dir_rightward = true
		elif direction.x < 0:
			is_dir_rightward = false
		
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
	
	await get_tree().process_frame
	
	travelling = true
	
	target = quest_window.waypoint.global_position
	location_label.text = "location: travelling..."
	
	print("[MainCharacter] Travelling - Moving towards '",quest_window.waypoint,"' at ",target)
	
	moving = true
	await target_reached
	print("[MainCharacter] Travelling - Waypoint reached! Transition to wandering...")	
	moving = false
	
	travelling = false
	
	location_label.text = "location: " + quest_window.waypoint.name
	
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
	
	while (GlobalVariables.game_running && wandering):
		
		# Check if we've waited long enough to pick a new wander target
		if time_waited < chosen_wait_time:
			time_waited += search_frequency
		else:
			# Pick a location near the waypoint to wander to
			if !chosen_wander_target:
				var randv = Vector2(randf_range(-1,1),randf_range(-1,1)).normalized() * randf_range(wander_range.x, wander_range.y)
				target = quest_window.waypoint.global_position + randv
				moving = true
				print("[MainCharacter] Wandering - Wandering towards ",target,"...")
				chosen_wander_target = true
			
			# Reset timer and wait for a while
			if wander_target_reached:
				chosen_wait_time = randf_range(wander_wait_time.x,wander_wait_time.y)
				time_waited = 0
				chosen_wander_target = false
				wander_target_reached = false
				target = global_position
				moving = false
				print("[MainCharacter] Wandering - Wander target reached! Starting to wait...")
				
				# Could not find the NPC
				npc_not_found.emit()
				
	
		# Wait a while for next search check
		await get_tree().create_timer(search_frequency).timeout
	




func _unhandled_input(event: InputEvent) -> void:
	if !GlobalVariables.game_running: return
	
	if can_attack && !attacking && event.is_action_pressed("AdminAttackTool"):
		attack()


func attack() -> void:
	attacking = true
	set_weapon(true)
	var particle = weapon_particle.instantiate()
	add_child(particle)
	particle.set_deferred("position", weapon.position)
	particle.set_deferred("rotation",weapon.rotation + deg_to_rad(-93) )
	particle.set_deferred("emitting", true)
	audio_sword_fx.play()
	await get_tree().create_timer(weapon_time).timeout
	set_weapon(false)
	attacking = false

var weapon_dir : Vector2 = Vector2.ZERO
func set_weapon(enable:bool) -> void:
	weapon_dir = (get_global_mouse_position() - weapon.global_position).normalized()
	weapon.position = (weapon_dir * weapon_distance) + weapon_local_offset if enable else weapon_local_offset
	weapon.rotation = weapon_dir.angle()
	weapon.process_mode = Node.PROCESS_MODE_INHERIT if enable else Node.PROCESS_MODE_DISABLED





func set_sight_circle(enable:bool) -> void:
	sight_circle.visible = enable
	sight_circle.set_deferred("monitoring", enable) 
	sight_circle.set_deferred("monitorable", enable) 


func _on_search_circle_body_entered(body: Node2D) -> void:
	if !GlobalVariables.game_running || !wandering: return
	print("[MainCharacter(",self,")] Search circle entered = ", body)
	
	# Make sure body is an NPC
	var _npc = (body as NPC)
	if _npc == null:
		print("[MainCharacter(",self,")] Body '",body,"' is not an NPC, ignoring.")
		return
	
	# Make sure this NPC isn't being ignored (due to already having been checked)
	if quest_window.check_if_ignored(_npc.npconfig):
		print("[MainCharacter(",self,")] NPC '",_npc,"' has already been checked this quest, ignoring.")
		return
	
	
	# Stop searching for NPC
	wandering = false
	set_sight_circle(false)
	
	# Move towards the NPC
	interacting = true
	target = _npc.global_position
	print("[MainCharacter] Search Finish - Moving towards NPC '",_npc,"'...")
	
	moving = true
	await target_reached
	print("[MainCharacter] Search Finish - Reached NPC '",_npc,"', interacting for a while...")
	moving = false
	
	
	# Interact with the NPC
	if body != null:
		set_chat_bubble(true)
		_npc.start_interaction()
		await get_tree().create_timer(randf_range(npc_interact_time.x,npc_interact_time.y)).timeout 
		if body != null:
			if Helpers.compare_npcs(_npc.npconfig,quest_window.active_quest.target):
				_npc.complete_interaction()
				print("[MainCharacter] Search Complete! - Successful interaction with NPC '",_npc,"'!")
			else:
				quest_window.ignore_npc(_npc.npconfig)
				print("[MainCharacter] Search Complete! - Failure! Ignoring NPC '",body,"' for this quest!")
		else: push_warning("[MainCharacter] Body not found! What's that about?")
		set_chat_bubble(false)
	else: push_warning("[MainCharacter] Body not found! What's that about?")
		
	
	interacting = false
	
	
	travel()


@onready var previous_speed : float = 0

func set_chat_bubble(enable:bool) -> void:
	if enable == $ChatBubble.visible:
		print("[MainCharacter] Set Chat Bubble > already the right speed, ignoring.")
		return
	if enable:
		previous_speed = speed
		print("[MainCharacter] Set Chat Bubble > Enabling and setting speed to 0, previous speed = ", speed)
		speed = 0
	else:
		speed = previous_speed
		print("[MainCharacter] Set Chat Bubble > Disabling and setting speed back to ", speed)
	$ChatBubble.visible = enable
