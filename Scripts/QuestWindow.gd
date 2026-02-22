class_name QuestWindow extends VirtualWindow

@onready var quest_list : Control = $VBoxContainer/QuestWindow/MarginContainer/VBoxContainer/QuestListPanel/HBoxContainer/QuestList
@onready var active_quest_field : RichTextLabel = $VBoxContainer/QuestWindow/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/CurrentContainer/ActiveQuest



@export var quests_over_time : Vector2i = Vector2i(10,30)

@export_category("READ ONLY")

@export var player_level : int = 1
@export var current_xp : int = 0

@export var max_xp : int = 100:
	get:
		return 100 * (player_level**2)


@export var waypoint : Node2D = null

@export var tracked_quests : Array[Quest] = []

@export var active_quest : Quest = null

var ignored_npcs : Array[NPConfig] = []



func _ready() -> void:
	
	for i in (GlobalVariables.level):   #(1+(randi() % 1)
		add_random_quest()
	#update_quest_list()
	
	set_active_quest(random_tracked_quest())
	#adding_quests_over_time()





func set_active_quest(quest:Quest) -> void:
	active_quest = quest
	waypoint = get_waypoint_from_name(active_quest.waypoint)
	active_quest_field.text = (
		"[color=dim_gray]wp" + active_quest.waypoint.right(1) + "_" +
		active_quest.tagline + "_" +
		"[color=slate_blue]" + active_quest.qid
	)

func add_random_quest() -> void:
	if tracked_quests.size() == 6:
		print("[QuestWindow] Add Random Quest - Max number of quests reached! Ignoring.")
		return
	
	var quest = Quest.new(random_waypoint_name(),GlobalVariables.level)
	print("[QuestWindow] Adding new random quest = ",quest.qid)
	tracked_quests.append(quest)
	#update_quest_list()
	call_deferred("update_quest_list")



func ignore_npc(_npc:NPConfig) -> void:
	ignored_npcs.append(_npc)

func check_if_ignored(_npc:NPConfig) -> bool:
	return ignored_npcs.has(_npc)

func wipe_ignored_npcs() -> void:
	ignored_npcs.clear()

func random_tracked_quest() -> Quest:
	return tracked_quests[randi() % tracked_quests.size()]


func random_waypoint() -> Node2D:
	return get_tree().get_nodes_in_group("Waypoints")[randi() % get_tree().get_node_count_in_group("Waypoints")] as Node2D


func random_waypoint_name() -> StringName:
	return random_waypoint().name


func get_waypoint_from_name(_name:String) -> Node2D:
	for _node2D in get_tree().get_nodes_in_group("Waypoints"):
		if _node2D.name == _name:
			return _node2D
	push_error("[QuestWindow] ERROR -> No waypoint called '",_name,"' found! Ignoring :(")
	return null


func update_xp():
	pass
	

func update_quest_list() -> void:
	
	var _list_entry : Control = null
	var _id_label : RichTextLabel = null
	var _location_label : RichTextLabel = null
	var _target_label : Label = null
	var _target : NPConfig = null
	
	for i in tracked_quests.size():
		_list_entry = quest_list.get_child(i+1)
		_id_label = _list_entry.get_child(0)
		_location_label = _list_entry.get_child(1)
		_target_label = _list_entry.get_child(2)
		_target = tracked_quests[i].target
	
		_id_label.text = tracked_quests[i].qid
		_location_label.text = tracked_quests[i].waypoint
		_target_label.text = (
			((_target.first_name) if _target.has_first_name else "") +
			((" " + _target.last_name) if _target.has_first_name && _target.has_last_name else "") +
			([" the ", ", "][randi() % 2] if (_target.has_colour || _target.has_type) && (_target.has_first_name || _target.has_last_name) else "") +
			("any " if (_target.has_colour || _target.has_type) && (!_target.has_first_name && !_target.has_last_name) else "") +
			(_target.str_colour + " " if _target.has_colour else "") +
			(_target.str_type if _target.has_type else "")
		)


func finish_quest() -> void:
	print("[QuestWindow] Finishing active quest '",active_quest.qid,"', found in tracked quests = ",tracked_quests.find(active_quest))
	tracked_quests.remove_at(tracked_quests.find(active_quest))
	wipe_ignored_npcs()
	await get_tree().process_frame
	
	# Add 1-2 random quests
	for i in (1+(randi() % 1)):
		add_random_quest()
	
	set_active_quest(random_tracked_quest())
	#set_active_quest(tracked_quests.back())  # Set the last quest gained as the active
	call_deferred("update_quest_list")




## NOTE > Works but not being used right now
func adding_quests_over_time() -> void:
	while (true):
		await get_tree().create_timer(randi_range(quests_over_time.x,quests_over_time.y)).timeout
		add_random_quest()
