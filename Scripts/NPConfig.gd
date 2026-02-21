class_name NPConfig extends Resource

var first_name : String = ""
var last_name : String = ""
var npc_colour : Helpers.NPCColours = Helpers.NPCColours.NONE
var npc_type : Helpers.NPCTypes = Helpers.NPCTypes.NONE


func _init(_first_name:String="",_last_name:String="",_npc_colour:Helpers.NPCColours=-1,_npc_type:Helpers.NPCTypes=-1) -> void:
	first_name = _first_name
	last_name = _last_name
	npc_colour = _npc_colour
	npc_type = _npc_type

static func blank() -> NPConfig:
	return NPConfig.new("","",Helpers.NPCColours.NONE,Helpers.NPCTypes.NONE)

static func rand() -> NPConfig:
	return NPConfig.new(Helpers.rand_npc_firstname(),Helpers.rand_npc_lastname(),Helpers.rand_npc_colour(),Helpers.rand_npc_type())



@export var readable_name : String = "":
	get: return full_name + " [" + str_colour + " " + str_type + "]"


@export var full_name : String = "" :
	get: return (first_name + " " + last_name)

@export var str_colour : String = "" :
	get:
		#print("npc_colour = ",npc_colour) 
		return "" if (npc_colour == -1) else (Helpers.NPCColours.keys()[npc_colour] as String).capitalize()

@export var str_type : String = "" :
	
	get: 
		#print("npc_type = ",npc_type)
		return "" if (npc_type == -1) else (Helpers.NPCTypes.keys()[npc_type] as String).capitalize()



@export var has_first_name : bool :
	get: return first_name != ""

@export var has_last_name : bool :
	get: return last_name != ""

@export var has_colour : bool :
	get: return str_colour != ""

@export var has_type : bool :
	get: return str_type != ""
