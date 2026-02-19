class_name NPC extends CharacterBody2D


@export_category("CONTROLS")

@export var randomise_on_start : bool = false
@export var chance_to_disappear : float = 0.65

@export_category("READ ONLY")

@export var npconfig : NPConfig = null


func setup() -> void:
	
	npconfig = NPConfig.rand() if randomise_on_start else NPConfig.blank()
	$Label.text = npconfig.readable_name
	name = "NPC_" + npconfig.full_name + "_" + npconfig.str_colour + npconfig.str_type

func complete_interaction() -> void:
	
	(get_tree().get_first_node_in_group("QuestWindow") as QuestWindow).finish_quest()
	
	if randf() <= chance_to_disappear:
		queue_free()
