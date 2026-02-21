class_name Quest extends Resource

@export var qid : StringName = ""
@export var tagline : StringName = ""
@export var waypoint : StringName = ""
@export var target : NPConfig = null

func _init(_waypoint:StringName,_level:int) -> void:
	qid = Helpers.rand_quest_qid()
	tagline = Helpers.rand_quest_tagline()
	waypoint = _waypoint
	target = Helpers.scaled_quest_npconfig(_level)
	print("[Quest] Created quest '_wp3_",tagline,"_",qid,"   |   Target = ", target.full_name, "[C",target.str_colour,"T",target.str_type,"]")
