class_name NPC extends CharacterBody2D


@onready var admin_window : AdminWindow = get_tree().get_first_node_in_group("AdminWindow")

@export_category("CONTROLS")

@export var randomise_on_start : bool = false
@export var chance_to_disappear : float = 0.65

@export_category("READ ONLY")

@export var npconfig : NPConfig = null



@export var destroy_enemy_on_click : bool = false :
	get: return (
		admin_window.selected_tab == AdminWindow.Tabs.NPCS &&
		admin_window.selected_npc_tool == AdminWindow.NPCTools.DESTROY
	) 


func setup() -> void:
	
	npconfig = NPConfig.rand() if randomise_on_start else NPConfig.blank()
	$Label.text = npconfig.readable_name
	name = "NPC_" + npconfig.full_name + "_" + npconfig.str_colour + npconfig.str_type



func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if destroy_enemy_on_click && event.is_action_pressed("AdminEnemyTool"):
		queue_free()





func complete_interaction() -> void:
	
	(get_tree().get_first_node_in_group("QuestWindow") as QuestWindow).finish_quest()
	
	if randf() <= chance_to_disappear:
		queue_free()
