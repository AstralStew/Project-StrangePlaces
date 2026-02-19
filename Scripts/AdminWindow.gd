class_name AdminWindow extends VirtualWindow


enum Tabs {ATTACKING,ENEMIES,NPCS}

enum EnemyTools {SPAWN,DESTROY}
enum NPCTools {SPAWN,DESTROY}

@onready var enemy_tab_content : Control = $VBoxContainer/AdminWindow/MarginContainer/VBoxContainer2/EnemyTabContent
@onready var npc_tab_content : Control = $VBoxContainer/AdminWindow/MarginContainer/VBoxContainer2/NPCTabContent

@export_category("READ ONLY")
@export var selected_tab : Tabs = Tabs.ATTACKING
@export var selected_enemy_tool : EnemyTools = EnemyTools.SPAWN
@export var selected_npc_tool : NPCTools = NPCTools.SPAWN




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
