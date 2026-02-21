class_name AdminWindow extends VirtualWindow




enum Tabs {ATTACKING,ENEMIES,NPCS}

enum EnemyTools {SPAWN,DESTROY}
enum NPCTools {SPAWN,DESTROY}


@onready var enemy_tab_content : Control = $VBoxContainer/AdminWindow/MarginContainer/VBoxContainer2/EnemyTabContent
@onready var npc_tab_content : Control = $VBoxContainer/AdminWindow/MarginContainer/VBoxContainer2/NPCTabContent

@onready var selected_npc_firstname_field : LineEdit = $VBoxContainer/AdminWindow/MarginContainer/VBoxContainer2/NPCTabContent/VBoxContainer/NamesContainer/FirstField
@onready var selected_npc_lastname_field : LineEdit = $VBoxContainer/AdminWindow/MarginContainer/VBoxContainer2/NPCTabContent/VBoxContainer/NamesContainer/LastField
@onready var selected_npc_colour_group : ButtonGroup = preload("res://Assets/Theme/npc_colour_button_group.tres")
@onready var selected_npc_type_group : ButtonGroup = preload("res://Assets/Theme/npc_type_button_group.tres")



@export_category("READ ONLY")
@export var selected_tab : Tabs = Tabs.ATTACKING
@export var selected_enemy_tool : EnemyTools = EnemyTools.SPAWN

@export var selected_npc_tool : NPCTools = NPCTools.SPAWN

@export var selected_npc_firstname : String = ""
@export var selected_npc_lastname : String = ""
@export var selected_npc_colour : Helpers.NPCColours = Helpers.NPCColours.BLUE
@export var selected_npc_type : Helpers.NPCTypes = Helpers.NPCTypes.ALCHEMIST



func _ready() -> void:
	enemy_tab_content.visible = false
	npc_tab_content.visible = false
	
	selected_npc_colour_group.pressed.connect(change_npc_colour)
	selected_npc_type_group.pressed.connect(change_npc_type)
	selected_npc_firstname_field.text_changed.connect(change_npc_firstname)
	selected_npc_lastname_field.text_changed.connect(change_npc_lastname)


func change_selected_tab(tab:Tabs) -> void:
	
	match tab:
		Tabs.ATTACKING:
			print("[AdminWindow] Tabs.Attacking selected! Loading AttackTabContent...")
			enemy_tab_content.visible = false
			npc_tab_content.visible = false
		Tabs.ENEMIES:
			print("[AdminWindow] Tabs.Enemies selected! Loading EnemyTabContent...")
			enemy_tab_content.visible = true
			npc_tab_content.visible = false
		Tabs.NPCS:
			print("[AdminWindow] Tabs.NPCs selected! Loading NPCTabContent...")
			enemy_tab_content.visible = false
			npc_tab_content.visible = true
		_:
			push_error("[AdminWindowBar] ERROR -> Bad tab name! Ignoring :(")
			return
	
	print("[AdminWindowBar] Set tab to '",tab,"'")
	selected_tab = tab



func change_enemy_tool(tool:EnemyTools) -> void:
	
	match tool:
		EnemyTools.SPAWN:
			print("[AdminWindowBar] EnemyTools.Spawn selected!")
		EnemyTools.DESTROY:
			print("[AdminWindowBar] EnemyTools.Destroy selected!")
		_:
			push_error("[AdminWindowBar] ERROR -> Bad enemy tool name! Ignoring :(")
			return
	
	print("[AdminWindowBar] Selecting enemy tool '",tool,"'")
	selected_enemy_tool = tool


func change_npc_tool(tool:NPCTools) -> void:
	
	match tool:
		NPCTools.SPAWN:
			print("[AdminWindowBar] NPCTools.Spawn selected!")
		NPCTools.DESTROY:
			print("[AdminWindowBar] NPCTools.Destroy selected!")
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
