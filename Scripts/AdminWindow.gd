class_name AdminWindow extends VirtualWindow

enum ToolNames {SPAWN_ENEMY,SPAWN_NPC,TRIGGER_ATTACK}

@export_category("READ ONLY")
@export var selected_tool : ToolNames = ToolNames.SPAWN_ENEMY


func change_selected_tool(tool:ToolNames) -> void:
	
	match tool:
		ToolNames.SPAWN_ENEMY:
			print("[AdminWindowBar] Spawning enemy...")
		ToolNames.SPAWN_NPC:
			print("[AdminWindowBar] Spawning NPC...")
		ToolNames.TRIGGER_ATTACK:
			print("[AdminWindowBar] Triggering attack...")
		_:
			push_error("[AdminWindowBar] ERROR -> Bad tool name! Ignoring :(")
			return
	
	print("[AdminWindowBar] Selecting tool '",tool,"'")
	selected_tool = tool
