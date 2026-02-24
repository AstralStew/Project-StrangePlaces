class_name AdminWindow extends VirtualWindow


@onready var frustration_manager : FrustrationManager = get_tree().get_first_node_in_group("FrustrationManager")


enum Tabs {ATTACKING,ENEMIES,NPCS,DISABLED}

enum EnemyTools {SPAWN,DESTROY}
enum NPCTools {SPAWN,DESTROY}


@onready var attacking_tab_content : Control = $VBoxContainer/AdminWindow/MarginContainer/VBoxContainer2/AttackTabContent
@onready var enemy_tab_content : Control = $VBoxContainer/AdminWindow/MarginContainer/VBoxContainer2/EnemyTabContent
@onready var npc_tab_content : Control = $VBoxContainer/AdminWindow/MarginContainer/VBoxContainer2/NPCTabContent

@onready var enemy_sighted_label : RichTextLabel = $VBoxContainer/AdminWindow/MarginContainer/VBoxContainer2/EnemyTabContent/VBoxContainer/CurrentTool2/LastEnemy

@onready var selected_npc_firstname_field : LineEdit = $VBoxContainer/AdminWindow/MarginContainer/VBoxContainer2/NPCTabContent/VBoxContainer/NamesContainer/FirstField
@onready var selected_npc_lastname_field : LineEdit = $VBoxContainer/AdminWindow/MarginContainer/VBoxContainer2/NPCTabContent/VBoxContainer/NamesContainer/LastField
@onready var selected_npc_colour_group : ButtonGroup = preload("res://Assets/Theme/npc_colour_button_group.tres")
@onready var selected_npc_type_group : ButtonGroup = preload("res://Assets/Theme/npc_type_button_group.tres")

@onready var enemy_helpbox : RichTextLabel = $VBoxContainer/AdminWindow/MarginContainer/VBoxContainer2/EnemyTabContent/VBoxContainer/HelpBox
@onready var npc_helpbox : RichTextLabel = $VBoxContainer/AdminWindow/MarginContainer/VBoxContainer2/NPCTabContent/VBoxContainer/HelpBox

@export_category("READ ONLY")
@export var selected_tab : Tabs = Tabs.ATTACKING
@export var selected_enemy_tool : EnemyTools = EnemyTools.SPAWN

@export var selected_npc_tool : NPCTools = NPCTools.SPAWN

@export var selected_npc_firstname : String = ""
@export var selected_npc_lastname : String = ""
@export var selected_npc_colour : Helpers.NPCColours = Helpers.NPCColours.BLUE
@export var selected_npc_type : Helpers.NPCTypes = Helpers.NPCTypes.ALCHEMIST



func _ready() -> void:
	attacking_tab_content.visible = true
	enemy_tab_content.visible = false
	npc_tab_content.visible = false
	
	selected_npc_colour_group.pressed.connect(change_npc_colour)
	selected_npc_type_group.pressed.connect(change_npc_type)
	selected_npc_firstname_field.text_changed.connect(change_npc_firstname)
	selected_npc_lastname_field.text_changed.connect(change_npc_lastname)

var _sighted_color : Color
func _physics_process(delta: float) -> void:
	if selected_tab == Tabs.ENEMIES:
		_sighted_color = lerp(
			Color.WEB_GREEN,
			Color.DARK_RED,
			clampf(
				frustration_manager.no_enemies_real_elapsed_time / frustration_manager.no_enemies_max_time,
				0,
				frustration_manager.no_enemies_max_time
			)
		)
		enemy_sighted_label.text = (
			"[color=" + _sighted_color.to_html() + "] " +
			str(floori(frustration_manager.no_enemies_real_elapsed_time)) + 
			" seconds ago"
		)



func change_selected_tab(tab:Tabs) -> void:
	
	match tab:
		Tabs.ATTACKING:
			print("[AdminWindow] Tabs.Attacking selected! Loading AttackTabContent...")
			attacking_tab_content.visible = true
			enemy_tab_content.visible = false
			npc_tab_content.visible = false
		Tabs.ENEMIES:
			print("[AdminWindow] Tabs.Enemies selected! Loading EnemyTabContent...")
			attacking_tab_content.visible = false
			enemy_tab_content.visible = true
			npc_tab_content.visible = false
		Tabs.NPCS:
			print("[AdminWindow] Tabs.NPCs selected! Loading NPCTabContent...")
			attacking_tab_content.visible = false
			enemy_tab_content.visible = false
			npc_tab_content.visible = true
		Tabs.DISABLED:
			print("[AdminWindow] Tabs disabled! Unloading content...")
			attacking_tab_content.visible = false
			enemy_tab_content.visible = false
			npc_tab_content.visible = false
		_:
			push_error("[AdminWindowBar] ERROR -> Bad tab name! Ignoring :(")
			return
	
	print("[AdminWindowBar] Set tab to '",tab,"'")
	selected_tab = tab



func change_enemy_tool(tool:EnemyTools) -> void:
	
	match tool:
		EnemyTools.SPAWN:
			print("[AdminWindowBar] EnemyTools.Spawn selected!")
			enemy_helpbox.text = (
				"[b]Spawn mode:[/b]\n" +
				"Click the map to spawn an Enemy at the mouse"
			)
		EnemyTools.DESTROY:
			print("[AdminWindowBar] EnemyTools.Destroy selected!")
			enemy_helpbox.text = (
				"[b]Destroy mode:[/b]\n" +
				"Click an enemy to destroy it"
			)
		_:
			push_error("[AdminWindowBar] ERROR -> Bad enemy tool name! Ignoring :(")
			return
	
	print("[AdminWindowBar] Selecting enemy tool '",tool,"'")
	selected_enemy_tool = tool


func change_npc_tool(tool:NPCTools) -> void:
	
	match tool:
		NPCTools.SPAWN:
			print("[AdminWindowBar] NPCTools.Spawn selected!")
			npc_helpbox.text = (
				"[b]Spawn mode:[/b]\n" +
				"Click the map to spawn an NPC at the mouse with the settings chosen below"
			)
		NPCTools.DESTROY:
			print("[AdminWindowBar] NPCTools.Destroy selected!")
			npc_helpbox.text = ("[b]Destroy mode:[/b]\n" +
				"Click an NPC to destroy it" +
				"[b]Note:[/b] Cannot delete corrupted NPCs"
			)
		_:
			push_error("[AdminWindowBar] ERROR -> Bad NPC tool name! Ignoring :(")
			return
	
	print("[AdminWindowBar] Selecting NPC tool '",tool,"'")
	selected_npc_tool = tool

func change_npc_firstname(_name:String) -> void:
	selected_npc_firstname = _name

func change_npc_lastname(_name:String) -> void:
	selected_npc_lastname = _name

func change_npc_colour(_colour:Button) -> void:
	match _colour.name:
		"Blue": selected_npc_colour = Helpers.NPCColours.BLUE
		"Green": selected_npc_colour = Helpers.NPCColours.GREEN
		"Purple": selected_npc_colour = Helpers.NPCColours.PURPLE
		"Red": selected_npc_colour = Helpers.NPCColours.RED
		_: push_error("[AdminWindow] ERROR -> Bad button received for Change NPC Colour! Ignoring :(")

func change_npc_type(_type:Button) -> void:
	match _type.name:
		"Alchemist": selected_npc_type = Helpers.NPCTypes.ALCHEMIST
		"Blacksmith": selected_npc_type = Helpers.NPCTypes.BLACKSMITH
		"Merchant": selected_npc_type = Helpers.NPCTypes.MERCHANT
		"Wizard": selected_npc_type = Helpers.NPCTypes.WIZARD
		_: push_error("[AdminWindow] ERROR -> Bad button received for Change NPC Type! Ignoring :(")

func reset_npc_tool() -> void:
	selected_npc_firstname_field.text = ""
	selected_npc_lastname_field.text = ""
	selected_npc_colour_group.get_buttons()[randi() % selected_npc_colour_group.get_buttons().size()].button_pressed = true
	selected_npc_type_group.get_buttons()[randi() % selected_npc_type_group.get_buttons().size()].button_pressed = true
