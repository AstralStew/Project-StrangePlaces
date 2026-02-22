class_name EmailWindow extends VirtualWindow

enum Type {Start,Win,Lose}

@onready var from : RichTextLabel = $VBoxContainer/QuestWindow/MarginContainer/VBoxContainer/MarginContainer/PanelContainer/VBoxContainer/FromContainer/From
@onready var date : RichTextLabel = $VBoxContainer/QuestWindow/MarginContainer/VBoxContainer/MarginContainer/PanelContainer/VBoxContainer/DateContainer/Date
@onready var to : RichTextLabel = $VBoxContainer/QuestWindow/MarginContainer/VBoxContainer/MarginContainer/PanelContainer/VBoxContainer/ToContainer/To
@onready var cc : RichTextLabel = $VBoxContainer/QuestWindow/MarginContainer/VBoxContainer/MarginContainer/PanelContainer/VBoxContainer/CCContainer/CC
@onready var subject : RichTextLabel = $VBoxContainer/QuestWindow/MarginContainer/VBoxContainer/MarginContainer/PanelContainer/VBoxContainer/SubjectContainer/Subject
@onready var content : RichTextLabel = $VBoxContainer/QuestWindow/MarginContainer/VBoxContainer/MarginContainer2/ContentPanel/Content

@export var move_speed : float = 2.5
@export var scale_speed : float = 0.025

func populate_email(_from:String,_date:String,_to:String,_cc:String,_subject:String,_content:String) -> void:
	from.text = _from
	date.text = _date
	to.text = _to
	cc.text = _cc
	subject.text = _subject
	content.text = _content


func activate_email(level:Level.CurrentLevel,type:Type) -> void:
	match(level):
		Level.CurrentLevel.Level1:
			match(type):
				Type.Start:
					activate_email_1_start()
				Type.Win:
					activate_email_1_win()
				Type.Lose:
					activate_email_1_lose()
		Level.CurrentLevel.Level2:
			match(type):
				Type.Start:
					activate_email_2_start()
				Type.Win:
					activate_email_2_win()
				Type.Lose:
					activate_email_2_lose()
		Level.CurrentLevel.Level3:
			match(type):
				Type.Start:
					activate_email_3_start()
				Type.Win:
					activate_email_3_win()
				Type.Lose:
					activate_email_3_lose()
		Level.CurrentLevel.Level4:
			match(type):
				Type.Start:
					activate_email_4_start()
				Type.Win:
					activate_email_4_win()
				Type.Lose:
					activate_email_4_lose()
	
	visible = true
	
	while (scale != Vector2.ONE || position != Vector2(170,90)):
		position = position.move_toward(Vector2(170,90),move_speed)
		scale = scale.move_toward(Vector2.ONE,scale_speed)
		await get_tree().process_frame
	

func deactivate() -> void:
	visible = false
	#while (scale != Vector2.ZERO || position != Vector2(170,200)):
	position = Vector2(170,200)
	scale = Vector2.ZERO



func activate_email_1_start() -> void:
	populate_email(
		"Something",
		"Dodad",
		"Scrimscram",
		"Bugger",
		"Boyhowdy",
		"Yup",
	)


func activate_email_1_win() -> void:
	populate_email(
		"",
		"",
		"",
		"",
		"",
		"",
	)


func activate_email_1_lose() -> void:
	populate_email(
		"",
		"",
		"",
		"",
		"",
		"",
	)

func activate_email_2_start() -> void:
	populate_email(
		"",
		"",
		"",
		"",
		"",
		"",
	)


func activate_email_2_win() -> void:
	populate_email(
		"",
		"",
		"",
		"",
		"",
		"",
	)


func activate_email_2_lose() -> void:
	populate_email(
		"",
		"",
		"",
		"",
		"",
		"",
	)

func activate_email_3_start() -> void:
	populate_email(
		"",
		"",
		"",
		"",
		"",
		"",
	)


func activate_email_3_win() -> void:
	populate_email(
		"",
		"",
		"",
		"",
		"",
		"",
	)


func activate_email_3_lose() -> void:
	populate_email(
		"",
		"",
		"",
		"",
		"",
		"",
	)
func activate_email_4_start() -> void:
	populate_email(
		"",
		"",
		"",
		"",
		"",
		"",
	)


func activate_email_4_win() -> void:
	populate_email(
		"",
		"",
		"",
		"",
		"",
		"",
	)


func activate_email_4_lose() -> void:
	populate_email(
		"",
		"",
		"",
		"",
		"",
		"",
	)
