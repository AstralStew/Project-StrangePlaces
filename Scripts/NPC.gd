class_name NPC extends CharacterBody2D


var npc_sprite : NPCSprite 
#var npc_label : RichTextLabel
@onready var admin_window : AdminWindow = get_tree().get_first_node_in_group("AdminWindow")

@export_category("CONTROLS")

@export var randomise_on_start : bool = false
@export var chance_to_disappear : float = 0.65

@export_category("READ ONLY")

@export var npconfig : NPConfig = null

@export var corrupted : bool = false


@export var destroy_enemy_on_click : bool = false :
	get: return (
		admin_window.selected_tab == AdminWindow.Tabs.NPCS &&
		admin_window.selected_npc_tool == AdminWindow.NPCTools.DESTROY
	) 


func setup() -> void:
	
	npconfig = NPConfig.rand() if randomise_on_start else NPConfig.blank()
	
	#npc_label = $Label
	#npc_label.text = npconfig.label_name
	#npc_label.size.x = 0
	
	npc_sprite = $Sprite2D
	npc_sprite.texture = Helpers.get_npc_texture(npconfig)
	npc_sprite.npc = self
	
	npc_sprite.setup()
	
	#name = "NPC_" + npconfig.full_name + "_" + npconfig.str_colour + npconfig.str_type
	



func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if destroy_enemy_on_click && event.is_action_pressed("AdminEnemyTool"):
		queue_free()


func corrupt() -> void:
	if !corrupted:
		print("[NPC] Corrupt called for the first time!")
		corrupted = true
		npc_sprite.corrupted = true
		name = name + " [corrupt]"
		return
	
	print("[NPC] Corrupt called again")
	
	# Turn into a monster
	



func complete_interaction() -> void:
	
	(get_tree().get_first_node_in_group("QuestWindow") as QuestWindow).finish_quest()
	
	if randf() <= chance_to_disappear:
		queue_free()
