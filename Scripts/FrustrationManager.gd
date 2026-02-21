class_name FrustrationManager extends Node

var chat_window : ChatWindow = null
var main_character : MainCharacter = null
var mob_manager : MobManager = null

var frustration : float = 0

@export_category("CONTROLS")
@export var typing_time : float = 1
@export var took_damage_msg_chance : float = 0.65
@export var no_npc_msg_chance : float = 0.65
@export var no_enemies_msg_chance : float = 1.0
@export var saw_spawn_in_msg_chance : float = 1.0
@export var no_enemies_time : float = 10.0

@export_category("READ ONLY")
@export var typing : bool = false :
	get: return typing
	set(value):
		typing = value
		main_character.set_chat_bubble(value)

@export var no_enemies_elapsed_time : float = 0.0


signal on_took_unnecessary_damage
signal on_cant_find_npc
signal on_enemies_missing
signal on_see_spawn_in



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	chat_window = get_tree().get_first_node_in_group("ChatWindow") as ChatWindow
	on_took_unnecessary_damage.connect(chat_window.took_unnecessary_damage)
	on_cant_find_npc.connect(chat_window.cant_find_npc)
	on_enemies_missing.connect(chat_window.enemies_missing)
	on_see_spawn_in.connect(chat_window.see_spawn_in)
	
	
	mob_manager = get_tree().get_first_node_in_group("MobManager") as MobManager
	mob_manager.spawned_slime.connect(check_spawn_position)
	mob_manager.spawned_NPC.connect(check_spawn_position)
	
	main_character = get_parent() as MainCharacter
	main_character.npc_not_found.connect(npc_not_found)
	main_character.took_damage.connect(took_damage)
	main_character.saw_enemy.connect(saw_enemy)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !GlobalVariables.game_running: return
	
	if !main_character.interacting:
	
		if no_enemies_elapsed_time >= no_enemies_time:
			no_enemies_elapsed_time = 0
			no_enemies()
		else: no_enemies_elapsed_time += delta




var _clicked_in_fake_camera : bool = false
func _fake_camera_input(event: InputEvent) -> void:
	if !GlobalVariables.game_running: return
	
	if event is InputEventMouseButton && event.button_index == 1:
		print("[FrustrationManager] Clicked in fake camera! Waiting to see if something was spawned...")
		_clicked_in_fake_camera = true
		set_deferred("_clicked_in_fake_camera", false)
	
func check_spawn_position() -> void:
	if _clicked_in_fake_camera:
		saw_spawn_in()

func saw_spawn_in() -> void:
	if typing:
		print("[FrustrationManager(",main_character,")] Caught something spawning in but already typing, cancelling...")
		return
	
	if randf() < saw_spawn_in_msg_chance:
		typing = true
		await get_tree().create_timer(typing_time).timeout
		print("[FrustrationManager(",main_character,")] Caught something spawning in + chose to msg...")
		chat_window.add_message(get_parent().name,saw_spawn_in_message())
		typing = false
		on_see_spawn_in.emit()

func saw_spawn_in_message() -> String:
	match randi() % 6:
		0:return "wtf it just spawned right in front of me"
		1:return "uhhh pop in much?"
		2:return "ergh appeared of nowhere"
		3:return "wow glitchy much"
		4:return "... why did that just appear??"
		5:return "devs pls fix things things teleporting"
		_:return "[color=red]Oops, you shouldn't see this! ;) - Sean[/color]"






func took_damage() -> void:
	if typing:
		print("[FrustrationManager(",main_character,")] Took damage but already typing, cancelling...")
		return
	
	if randf() < took_damage_msg_chance:
		typing = true
		await get_tree().create_timer(typing_time).timeout
		print("[FrustrationManager(",main_character,")] Took damage + chose to msg...")
		chat_window.add_message(get_parent().name,took_damage_message())
		typing = false
		on_took_unnecessary_damage.emit()
	

func took_damage_message() -> String:
	match randi() % 6:
		0:return "my attack stopped working :("
		1:return "no auto-attack!!! this is bs"
		2:return "why can't I attack these mobs"
		3:return "WTF kiting and no attack comes out"
		4:return "how do u attack"
		5:return "attack is totally busted OTL"
		_:return "[color=red]Oops, you shouldn't see this! ;) - Sean[/color]"



func saw_enemy() -> void:
	no_enemies_elapsed_time = 0

func no_enemies() -> void:
	if typing:
		print("[FrustrationManager(",main_character,")] No enemies for a while but already typing, cancelling...")
		return
	
	if randf() <= no_enemies_msg_chance:
		typing = true
		await get_tree().create_timer(typing_time).timeout
		print("[FrustrationManager(",main_character,")] No enemies found + chose to msg...")
		chat_window.add_message(get_parent().name,no_enemies_message())
		typing = false
		on_enemies_missing.emit()

func no_enemies_message() -> String:
	match randi() % 6:
		0:return "bored... no enemies around"
		1:return "do the mobs respawn"
		2:return "this place feels empty"
		3:return "no enemies LOL"
		4:return "why aren't any enemies in area??"
		5:return "uhhh, are there sposed to be mobs here?"
		_:return "[color=red]Oops, you shouldn't see this! ;) - Sean[/color]"


func npc_not_found() -> void:
	if typing:
		print("[FrustrationManager(",main_character,")] No npc found but already typing, cancelling...")
		return
	
	if randf() < no_npc_msg_chance:
		typing = true
		await get_tree().create_timer(typing_time).timeout
		print("[FrustrationManager(",main_character,")] No npc found + chose to msg...")
		chat_window.add_message(get_parent().name,no_npc_message())
		typing = false
		on_cant_find_npc.emit()

func no_npc_message() -> String:
	match randi() % 6:
		0:return "can't find this stupid NPC"
		1:return "does anyone know where NPC is?"
		2:return "there should be an NPC here..."
		3:return "i think this quest is broken"
		4:return "/find NPC"
		5:return "NPC hiding from me lol"
		_:return "[color=red]Oops, you shouldn't see this! ;) - Sean[/color]"
