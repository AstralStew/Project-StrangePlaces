extends Node

var chat_window : ChatWindow = null
var main_character : MainCharacter = null

var frustration : float = 0

@export_category("CONTROLS")
@export var typing_time : float = 1
@export var took_damage_msg_chance : float = 0.65
#@export var took_damage_msg_frequency : float = 0.65
@export var no_npc_msg_chance : float = 0.65
#@export var no_npc_msg_frequency : float = 0.65

@export_category("READ ONLY")
@export var typing : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	chat_window = get_tree().get_first_node_in_group("ChatWindow") as ChatWindow
	main_character = get_parent() as MainCharacter
	main_character.npc_not_found.connect(npc_not_found)
	main_character.took_damage.connect(took_damage)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if frustration <= 0:
		max_frustration_reached()
		return
	frustration -= delta

func max_frustration_reached() -> void:
	frustration = randf() * 5






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
	

func took_damage_message() -> String:
	match randi() % 6:
		0:
			return "my attack stopped working :("
		1:
			return "no auto-attack!!! this is bs"
		2:
			return "why can't I attack these mobs"
		3:
			return "WTF kiting and no attack comes out"
		4:
			return "how do u attack"
		5:
			return "attack is totally busted OTL"
		_: 
			return "[color=red]Oops, you shouldn't see this! ;) - Sean[/color]"




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

func no_npc_message() -> String:
	match randi() % 6:
		0:
			return "can't find this stupid NPC"
		1:
			return "does anyone know where NPC is?"
		2:
			return "there should be an NPC here..."
		3:
			return "i think this quest is broken"
		4:
			return "/find NPC"
		5:
			return "NPC hiding from me lol"
		_: 
			return "[color=red]Oops, you shouldn't see this! ;) - Sean[/color]"
