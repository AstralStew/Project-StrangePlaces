class_name AdminWindow extends PanelContainer

@export_category("CONTROLS")
@export var min_pos : Vector2 = Vector2.ZERO
@export var max_pos : Vector2 = Vector2.ZERO

var dragging : bool = false
var offset : Vector2 = Vector2.ZERO


func _on_gui_input(event: InputEvent) -> void:
	print("[AdminWindowBar] Input! Event = ", event)
	if event is InputEventMouseButton:
		if event.button_index == 1:
			print("[AdminWindowBar] Mouse pressed on me!")
			offset = global_position - get_global_mouse_position()
		dragging = event.pressed

func _process(delta: float) -> void:
	if dragging:
		print("[AdminWindowBar] Dragging...")
		global_position = (get_global_mouse_position() + offset).clamp(min_pos, get_viewport_rect().size - size)
