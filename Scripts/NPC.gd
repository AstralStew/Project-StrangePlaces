class_name NPC extends CharacterBody2D

enum NpcTypes {WIZARD, THIEF, MERCHANT, FIGHTER}
enum NpcColours {BLUE, RED, GREEN, PURPLE}
enum FirstNames {Glorbund, Timmon, Slawgeld, Flipp, Bugothy, Wimble, Jamsen}
enum LastNames {Nilyx, Wumbucket, Glablewart, Bisqois, Krit, Shonx, Rectus}

@export_category("CONTROLS")

@export var randomise_on_start : bool = false
@export var chance_to_disappear : float = 0.65

@export_category("READ ONLY")

var _first_name : String = ""
var _last_name : String = ""
var _npc_colour : NpcColours = NpcColours.BLUE
var _npc_type : NpcTypes = NpcTypes.WIZARD

@export var full_name : String = "" :
	get: return (_first_name + " " + _last_name)

@export var npc_colour : String = "" :
	get: return NpcColours.keys()[_npc_colour]

@export var npc_type : String = "" :
	get: return NpcTypes.keys()[_npc_type]




func setup() -> void:
	if randomise_on_start:
		_npc_colour = (randi() % NpcColours.size()) as NpcColours
		_npc_type = (randi() % NpcTypes.size())  as NpcTypes
		_first_name = FirstNames.keys()[randi() % FirstNames.size()]
		_last_name = LastNames.keys()[randi() % LastNames.size()]
		
		#var label_text = str(npc_name) + "[" + str(npc_colour) + " " + str(npc_type) + "]"
		$Label.text = full_name + " [" + npc_colour + " " + npc_type + "]"
		
		name = "NPC_" + full_name + "_" + npc_colour + npc_type

func complete_interaction() -> void:
	
	if randf() <= chance_to_disappear:
		queue_free()
