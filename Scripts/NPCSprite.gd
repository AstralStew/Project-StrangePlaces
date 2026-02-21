class_name NPCSprite extends MobSprite


@onready var label : RichTextLabel = $"../Label"

@export var label_tornado_radius = 0.4
@export var label_tornado_freq = 100
@export var label_letters_max = 10

var label_text : String = ""

var all_chars : String = " '!#$%&()*+,-./0123456789:;<>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ^_`abcdefghijklmnopqrst|uvwxyz}{~';"

var modified_string = ""
var random_index : int = 0

func _set_corrupt_materials() -> void:
	super._set_corrupt_materials()
	label_text = label.text
	modified_string = label_text


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if corrupted:
		
		if glitch_amount > 0.25 && randf() > 0.75:
			var modified_string_a : String = label_text.get_slice("\n",0)
			var modified_string_b : String = label_text.get_slice("\n",1)
			var number_of_letters = randi() % floori(glitch_amount * label_letters_max)
			for rand_letter in number_of_letters:
				if rand_letter > number_of_letters / 2:
					random_index = randi() % modified_string_a.length()
					if modified_string_a[random_index] != "[" && modified_string_a[random_index] != "]" && modified_string_a[random_index] != "b": 
						modified_string_a = modified_string_a.substr(0,random_index) + all_chars[randi_range(0, all_chars.length() - 1)] + modified_string_a.substr(random_index+1,modified_string_a.length())
				else:
					random_index = randi() % modified_string_b.length()
					if modified_string_b[random_index] != "[" && modified_string_b[random_index] != "]" && modified_string_b[random_index] != "b": 
						modified_string_b = modified_string_b.substr(0,random_index) + all_chars[randi_range(0, all_chars.length() - 1)] + modified_string_b.substr(random_index+1,modified_string_b.length())
			modified_string = modified_string_a + "\n" + modified_string_b
	
		label.text = (
			"[tornado radius="+str(glitch_amount*label_tornado_radius)+" freq="+str(glitch_amount*label_tornado_freq)+"]" +
			modified_string
		)
	
