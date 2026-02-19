class_name ChatWindow extends VirtualWindow


@onready var chat_log : RichTextLabel = $VBoxContainer/ChatWindow/MarginContainer/ChatLog

@export_category("CONTROLS")

@export var random_msg_frequency : Vector2 = Vector2(1,4)

@export_category("READ ONLY")

@export var user_colours : Dictionary = {
	"MainCharacter":Color.GREEN
}
@export var random_users : Array = [
	"Deo4",
	"serpentine",
	"xX_Arthus_Xx",
	"RoGRebel",
	"OggieRock",
	"astralstew",
	"purpledonkey",
	"DurgBurger",
	"voms",
	"Fawxy",
	"ch0wdeR",
	]

func _ready() -> void:
	add_server_message("Server host credentials (x46290)")
	add_server_message("Welcome to [b][i]Places Online[/i]™[/b]")
	add_server_message("Thank you for joining us for our launch! :^)")
	add_server_message("Please send any bugs to [i]placesonlinebugs@mailcoded.net[/i]!")
	
	random_msgs()


func add_message (username:String, msg_text:String, random:bool = false):
	
	if !user_colours.has(username):
		user_colours[username] = Color.from_hsv(randf(),0.7 if random else 1,0.7 if random else 1)
	var msg_colour : Color = user_colours.get(username)
	var time_string = Time.get_time_string_from_system()
	
	if random:
		chat_log.append_text("[color="+msg_colour.to_html(false)+"][[i]"+ time_string + "[/i]] <[b]"+  username + "[/b]>: " + msg_text + "[/color]\n")
	else:
		chat_log.append_text("[bgcolor=69696978][color="+msg_colour.to_html(false)+"][[i]"+ time_string + "[/i]] <[b]"+  username + "[/b]>: " + msg_text + "[/color][/bgcolor]\n")


func add_server_message(msg_text:String):
	chat_log.append_text("[color=white][b]Server[/b]: " + msg_text + "\n")





func random_msgs() -> void:
	while(true):
		await get_tree().create_timer(randf_range(random_msg_frequency.x,random_msg_frequency.y)).timeout
		add_message(random_users[randi() % random_users.size()],random_msg(), true)

func random_msg() -> String:
	match randi() % 20:
		0:return "i think so"
		1:return "these places are pretty strange..."
		2:return "anyone see the latest Twin Peaks?"
		3:return "kilroy was here"
		4:return "dancing_baby.gif"
		5:return "how do u get potions??"
		6:return "Train to zone!"
		7:return "corpse run LOL"
		8:return "Ding!"
		9:return "can u stop campin pls :("
		10:return "WTB any rare drops, PST"
		11:return "afk"
		12:return "gotta bio lol brb"
		13:return "<~ WTT? JOIN [color=cyan]#MUDUnitedAU[/color] 4 FREE LOOT ~>"
		14:return "aLL your base are belong to us"
		15:return "the game zoot"
		16:return "lfg need IW"
		17:return "ummmm no"
		18:return "are the devs in here??"
		19:return "OTL OTL OTL OTL"
		_:return "[color=red]Oops, you shouldn't see this! ;) - Sean[/color]"
