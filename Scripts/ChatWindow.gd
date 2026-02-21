class_name ChatWindow extends VirtualWindow


@onready var chat_log : RichTextLabel = $VBoxContainer/ChatWindow/MarginContainer/ChatLog
@onready var players_label : RichTextLabel = $VBoxContainer/PlayersLabel


@export_category("CONTROLS")

@export var game_length_mins : int = 5

@export var starting_player_count : int = 419
@export var random_msg_frequency : Vector2 = Vector2(1,4)


@export_category("REDUCTIONS")

@export var adjust_speed : float = 0.15
@export var random_fluctuations_amount : Vector2i = Vector2i(1,3)
@export var random_fluctuations_frequency : Vector2i = Vector2i(5,10)
@export var reduce_from_unnecessary_damage : Vector2i = Vector2i(3,7)
@export var reduce_from_cant_find_npc : Vector2i = Vector2i(8,12)
@export var reduce_from_enemies_missing : Vector2i = Vector2i(13,17)
@export var reduce_from_see_spawn_in : Vector2i = Vector2i(3,7)

@export_category("READ ONLY")

@onready var player_count : float = starting_player_count

var amount_to_adjust : float = 0
var new_col : Color = Color.RED

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
	add_server_message("Welcome to [b][i]Places Online[/i]™[/b]\n" +
	"Thank you for joining us for our launch! :^)\n" +
	"Please send any bugs to [i]placesonlinebugs@mailcoded.net[/i]!"
	)
	server_restart_timer()
	
	random_msgs()
	player_count_fluctuations()


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




func adjust_player_count(amount:int):
	print("[ChatWindow] Adjusting player count (", floori(player_count),") by ",amount)
	amount_to_adjust += amount

func reduce_player_count(amount:int):
	print("[ChatWindow] Reducing player count (", floori(player_count),") by ",amount)
	amount_to_adjust -= amount



func server_restart_timer() -> void:
	while (game_length_mins > 0):
		add_server_message("[bgcolor=69696978][b]NOTE > server will restart in "+str(game_length_mins)+" minutes[/b][/bgcolor]")
		await get_tree().create_timer(60).timeout
		




func player_count_fluctuations():
	var fluctuation : int = 0
	var neg : bool = false
	while (true):
		await get_tree().create_timer(randi_range(random_fluctuations_frequency.x,random_fluctuations_frequency.y)).timeout
		
		neg = randf() > 0.5
		fluctuation = randi_range(random_fluctuations_amount.x,random_fluctuations_amount.y)
		print("[ChatWindow] Random fluctuation: +",fluctuation)
		adjust_player_count(fluctuation * (-1 if neg else 1))
		
		await get_tree().create_timer(randi_range(random_fluctuations_frequency.x,random_fluctuations_frequency.y)).timeout
		
		print("[ChatWindow] Reducing previous random fluctuation: -",fluctuation)
		reduce_player_count(fluctuation * (-1 if neg else 1))





func no_more_players():
	print("[ChatWindow] NO MORE PLAYERS > YOU LOSE THE GAME YA DUNCE")
	Engine.time_scale = 0.0

func _physics_process(delta: float) -> void:
	if amount_to_adjust != 0:
		
		amount_to_adjust = move_toward(amount_to_adjust,0,adjust_speed)
		
		if amount_to_adjust < 0:
			player_count = max(move_toward(player_count,player_count-adjust_speed,adjust_speed),0)
		else:
			player_count = max(move_toward(player_count,player_count+adjust_speed,adjust_speed),0)
		
		if floori(player_count) == 0:
			no_more_players()
		
		update_count_gfx()


func update_count_gfx():
	#print("[ChatWindow] Clamped player count = ", str(clamp(player_count/starting_player_count,0,starting_player_count)),", Color = ",Color.GREEN.lerp(Color.RED,clamp(player_count/starting_player_count,0,starting_player_count)))
	new_col = Color.RED.lerp(Color.GREEN,clamp(player_count/starting_player_count,0,starting_player_count))
	players_label.text = "Players online:  [b][color="+new_col.to_html()+"]"+str(ceili(player_count))




func took_unnecessary_damage() -> void:
	var amount = randi_range(reduce_from_unnecessary_damage.x,reduce_from_unnecessary_damage.y)
	print("[ChatWindow] MainCharacter told chat they took unnecessary damage! Reducing player count by ",amount)
	reduce_player_count(amount)
	
func cant_find_npc() -> void:
	var amount = randi_range(reduce_from_cant_find_npc.x,reduce_from_cant_find_npc.y)
	print("[ChatWindow] MainCharacter told chat they can't find NPC! Reducing player count by ",amount)
	reduce_player_count(amount)
	
func enemies_missing() -> void:
	var amount = randi_range(reduce_from_enemies_missing.x,reduce_from_enemies_missing.y)
	print("[ChatWindow] MainCharacter told chat there are no enemies! Reducing player count by ",amount)
	reduce_player_count(amount)
	
func see_spawn_in() -> void:
	var amount = randi_range(reduce_from_see_spawn_in.x,reduce_from_see_spawn_in.y) 
	print("[ChatWindow] MainCharacter told chat they saw something spawn in! Reducing player count by ",amount)
	reduce_player_count(amount)







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
