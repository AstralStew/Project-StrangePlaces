class_name EmailWindow extends VirtualWindow

enum Type {Start,Lose}

@onready var title : Label = $VBoxContainer/TitleBar/MarginContainer/TitleLabel
@onready var from : RichTextLabel = $VBoxContainer/EmailWindow/MarginContainer/VBoxContainer/MarginContainer/PanelContainer/VBoxContainer/FromContainer/From
@onready var date : RichTextLabel = $VBoxContainer/EmailWindow/MarginContainer/VBoxContainer/MarginContainer/PanelContainer/VBoxContainer/DateContainer/Date
@onready var to : RichTextLabel = $VBoxContainer/EmailWindow/MarginContainer/VBoxContainer/MarginContainer/PanelContainer/VBoxContainer/ToContainer/To
@onready var cc : RichTextLabel = $VBoxContainer/EmailWindow/MarginContainer/VBoxContainer/MarginContainer/PanelContainer/VBoxContainer/CCContainer/CC
@onready var subject : RichTextLabel = $VBoxContainer/EmailWindow/MarginContainer/VBoxContainer/MarginContainer/PanelContainer/VBoxContainer/SubjectContainer/Subject
@onready var content : RichTextLabel = $VBoxContainer/EmailWindow/MarginContainer/VBoxContainer/MarginContainer2/ContentPanel/Content

@export var move_speed : float = 2.5
@export var scale_speed : float = 0.025

func populate_email(_from:String,_date:String,_to:String,_cc:String,_subject:String,_content:String) -> void:
	from.text = _from
	date.text = _date
	to.text = _to
	cc.text = _cc
	subject.text = _subject
	title.text = "MailCoded - " + _subject
	content.text = _content


func activate_email(level:Level.CurrentLevel,type:Type) -> void:
	
	print("[EmailWindow] Activating email window")
	match(level):
		Level.CurrentLevel.Level1:
			match(type):
				Type.Start:
					activate_email_1_start()
				Type.Lose:
					activate_email_lose()
		Level.CurrentLevel.Level2:
			match(type):
				Type.Start:
					activate_email_2_start()
				Type.Lose:
					activate_email_lose()
		Level.CurrentLevel.Level3:
			match(type):
				Type.Start:
					activate_email_3_start()
				Type.Lose:
					activate_email_lose()
		Level.CurrentLevel.Level4:
			match(type):
				Type.Start:
					activate_email_4_start()
				Type.Lose:
					activate_email_lose()
	
	visible = true
	
	while (scale != Vector2.ONE || position != Vector2(170,90)):
		position = position.move_toward(Vector2(170,90),move_speed)
		scale = scale.move_toward(Vector2.ONE,scale_speed)
		await get_tree().process_frame
	

func deactivate_email() -> void:
	visible = false
	#while (scale != Vector2.ZERO || position != Vector2(170,200)):
	position = Vector2(170,200)
	scale = Vector2.ZERO



func activate_email_1_start() -> void:
	print("[EmailWindow] Activating email 1 start")
	populate_email(
		"b.parker@ptstudio.com",
		"Tuesday, February 22 1999,10:00pm",
		"Tempadminacount1024@ptstudio.com",
		"s.fencer@ptstudio.com, admin@placesonline.com, e.walace@placesonline.com",
		"Server Problems",
		"""Heyo,

I know your shifts have been going long but we got a problem.. Our scripting system just broke in this pos mmo. We’re trying to figure out what caused it, but we need you to keep the players from finding out.

We only have a small amount of players, so we’ve got everyone babysitting the players atm. We need you to use the admin tools to spawn enemies and npc’s for the players. Also careful with the NPC spawns - everytime you spawn one it’ll randomize the data you set.

Make sure the npcs match the quest the player is on and the player has finished travelling to the quest hub. You can spawn enemies at your discretion, make sure you keep the player engaged - though keep in mind, the autoattack is ALSO broken, so you will need to attack for the player. Yup. 

Basically if the player you are watching complains about anything just spawn it for them. Make sure you do it outside the purple box or they’ll know something is up. These players are pretty vocal so just watch the chat. 

Should take us about 3 mins to push the update, we’ll send messages to the chat as we get closer.

TTYL - B.Parker"""
	)


func activate_email_2_start() -> void:
	print("[EmailWindow] Activating email 2 start")
	populate_email(
		"b.parker@ptstudio.com",
		"Tuesday, February 22 1999,10:00pm",
		"Tempadminacount1024@ptstudio.com",
		"s.fencer@ptstudio.com, admin@placesonline.com, e.walace@placesonline.com",
		"Re: Server Problems",
		"""OKAY,

Server is back up and everythings busted. Dammit we are going to have no players by the end of this. Uhhh, we think something with the “places” system broke, we’re updating in another 3 minutes to try tinkering with it. 

Oh also the quest system got hit a bit more. Make sure you check the quest id before you place the npc. Double check where the player is on the top right as well if you’re in a pinch, should give you an idea of what npc to spawn. 

Some players came back online but we’re still down a few. 3 mins and this is finished though

Hope this is the last message - B.Parker"""
	)


func activate_email_3_start() -> void:
	print("[EmailWindow] Activating email 3 start")
	populate_email(
		"b.parker@ptstudio.com",
		"Tuesday, February 22 1999,11:00pm",
		"Tempadminacount1024@ptstudio.com",
		"s.fencer@ptstudio.com, admin@placesonline.com, e.walace@placesonline.com",
		"Re: Re: Server Problems",
		"""Hey,

Okay I know you’re on overtime. But shiz just hit the fan. That “places” system is doing something really effin strange to our server data.

We wanted to take the game offline but the boss won’t let us. Says we can’t lose revenue like the players are paying us by the hour or something. We should shut down but he’ll blow a gasket.

ANYWAYS long and short is the data is being corrupted - the more NPC’s or Enemies there are in an instance, the more unstable it seems to get. Looks super weird and broken, no idea wtf is going on. 

Anyways you see an enemy glitching out you need to delete it. Glitching NPC’s seem to not be deletable for some reason, but if you restart the drive it’ll fix things. This will disable the other tools but it’s a quick fix in a pinch. Make sure the drive doesn't get too corrupted or we’ll have no game left. 

Strap in I guess - B Parker 
"""
	)



func activate_email_4_start() -> void:
	print("[EmailWindow] Activating email 4 start")
	populate_email(
		"b.parker@ptstudio.com",
		"Tuesday, February 22 1999,12:00am",
		"Tempadminacount1024@ptstudio.com",
		"s.fencer@ptstudio.com, admin@placesonline.com, e.walace@placesonline.com",
		"Do you hear the singing?",
		"""Why is the reset taking so long

What happened to game

I hadd thing to do

I forget.

forget
"""
	)



func activate_email_lose() -> void:
	print("[EmailWindow] Activating email lose")
	populate_email(
		"b.parker@ptstudio.com",
		"Tuesday, February 23 1999,8:00am",
		"Tempadminacount1024@ptstudio.com",
		"",
		"Subject",
		"""To Whom it may concern:

We wanted to castigate you on your terrible performance last night. Thanks to your slow wit, we were unable to fool our playerbase, losing our revenue stream. That is unacceptable. 

Thanks to all your sloppy work, the game has failed. So with that in mind, we are letting you go. In no uncertain terms, you are fired. 

Please remember that you are under NDA. We thank you for your service.

CEO
Spil Fencer
Oh the “Places” you’ll go…
""")
