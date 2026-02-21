class_name Helpers

enum NPCColours {BLUE, RED, GREEN, PURPLE, NONE = -1}
enum NPCTypes {WIZARD, BLACKSMITH, MERCHANT, ALCHEMIST, NONE = -1}
enum NPCFirstNames {Glorbund, Timmon, Slawgeld, Flipp, Bugothy, Wimble, Jamsen}
enum NPCLastNames {Nilyx, Wumbucket, Glablewart, Bisqois, Krit, Shonx, Rectus}

enum FantasyWords {obsidian, emerald, silver, gold, crimson, sylvan, dark, sun, moon, thorns, hammer,guard, watch, night, dawn, whisper, mountain, forest, plains, tower, castle,merchant,goblin,dragon,sorceror,thieves,cut}

static func rand_quest_qid() -> StringName:
	return  ["a","b","c"][randi() % 3] + str(randi_range(0,999)) + ["a","b","c"][randi() % 3] + str(randi_range(0,9))

static func rand_quest_tagline() -> StringName:
	return FantasyWords.keys()[randi() % FantasyWords.size()] + "." + FantasyWords.keys()[randi() % FantasyWords.size()]


static func rand_quest_npconfig() -> NPConfig:
	var _do_first_name : bool = randf() >= 0.5
	var _do_last_name : bool = _do_first_name && randf() >= 0.5
	var _do_colour : bool = randf() >= 0.5
	var _do_type : bool = (!_do_first_name && !_do_last_name && !_do_colour) || randf() >= 0.5
	
	return NPConfig.new(
		Helpers.rand_npc_firstname() if _do_first_name else "",
		Helpers.rand_npc_lastname() if _do_last_name else "",
		Helpers.rand_npc_colour() if _do_colour else Helpers.NPCColours.NONE,
		Helpers.rand_npc_type() if _do_type else Helpers.NPCTypes.NONE
	)

static func scaled_quest_npconfig(_level:int) -> NPConfig:
	var _chance = 0.1 + (0.1*clamp(_level,1,5))
	var _do_first_name : bool = randf() < _chance
	var _do_last_name : bool = _do_first_name && randf() < _chance
	var _do_colour : bool = randf() < _chance
	var _do_type : bool = (!_do_first_name && !_do_last_name && !_do_colour) || randf() < _chance
	
	return NPConfig.new(
		Helpers.rand_npc_firstname() if _do_first_name else "",
		Helpers.rand_npc_lastname() if _do_last_name else "",
		Helpers.rand_npc_colour() if _do_colour else Helpers.NPCColours.NONE,
		Helpers.rand_npc_type() if _do_type else Helpers.NPCTypes.NONE
	)



static func rand_npc_firstname() -> String:
	return NPCFirstNames.keys()[randi() % NPCFirstNames.size()]

static func rand_npc_lastname() -> String:
	return NPCLastNames.keys()[randi() % NPCLastNames.size()]

static func rand_npc_colour() -> NPCColours:
	return (randi() % (NPCColours.size() - 1)) as NPCColours

static func rand_npc_type() -> NPCTypes:
	return (randi() % (NPCTypes.size() - 1))  as NPCTypes



static func get_npc_texture(npconfig : NPConfig) -> Texture2D:
	if npconfig.npc_colour == NPCColours.BLUE:
		if npconfig.npc_type == NPCTypes.ALCHEMIST:
			return blue_alchemist_texture
		elif npconfig.npc_type == NPCTypes.BLACKSMITH:
			return blue_blacksmith_texture
		elif npconfig.npc_type == NPCTypes.MERCHANT:
			return blue_merchant_texture
		elif npconfig.npc_type == NPCTypes.WIZARD:
			return blue_wizard_texture
		else: return null
	elif npconfig.npc_colour == NPCColours.GREEN:
		if npconfig.npc_type == NPCTypes.ALCHEMIST:
			return green_alchemist_texture
		elif npconfig.npc_type == NPCTypes.BLACKSMITH:
			return green_blacksmith_texture
		elif npconfig.npc_type == NPCTypes.MERCHANT:
			return green_merchant_texture
		elif npconfig.npc_type == NPCTypes.WIZARD:
			return green_wizard_texture
		else: return null
	elif npconfig.npc_colour == NPCColours.PURPLE:
		if npconfig.npc_type == NPCTypes.ALCHEMIST:
			return purple_alchemist_texture
		elif npconfig.npc_type == NPCTypes.BLACKSMITH:
			return purple_blacksmith_texture
		elif npconfig.npc_type == NPCTypes.MERCHANT:
			return purple_merchant_texture
		elif npconfig.npc_type == NPCTypes.WIZARD:
			return purple_wizard_texture
		else: return null
	elif npconfig.npc_colour == NPCColours.RED:
		if npconfig.npc_type == NPCTypes.ALCHEMIST:
			return red_alchemist_texture
		elif npconfig.npc_type == NPCTypes.BLACKSMITH:
			return red_blacksmith_texture
		elif npconfig.npc_type == NPCTypes.MERCHANT:
			return red_merchant_texture
		elif npconfig.npc_type == NPCTypes.WIZARD:
			return red_wizard_texture
		else: return null
	else: return null


static var blue_alchemist_texture : Texture2D = preload("res://Assets/Sprites/NPC's/Alchemist/Alchemist_Blue.png")
static var green_alchemist_texture : Texture2D = preload("res://Assets/Sprites/NPC's/Alchemist/Alchemist_Green.png")
static var purple_alchemist_texture : Texture2D = preload("res://Assets/Sprites/NPC's/Alchemist/Alchemist_Purple.png")
static var red_alchemist_texture : Texture2D = preload("res://Assets/Sprites/NPC's/Alchemist/Alchemist_Red.png")

static var blue_blacksmith_texture : Texture2D = preload("res://Assets/Sprites/NPC's/Blacksmith/Blacksmith_Blue.png")
static var green_blacksmith_texture : Texture2D = preload("res://Assets/Sprites/NPC's/Blacksmith/Blacksmith_Green.png")
static var purple_blacksmith_texture : Texture2D = preload("res://Assets/Sprites/NPC's/Blacksmith/Blacksmith_Purple.png")
static var red_blacksmith_texture : Texture2D = preload("res://Assets/Sprites/NPC's/Blacksmith/Blacksmith_Red.png")

static var blue_merchant_texture : Texture2D = preload("res://Assets/Sprites/NPC's/Merchant/Merchant_Blue.png")
static var green_merchant_texture : Texture2D = preload("res://Assets/Sprites/NPC's/Merchant/Merchant_Green.png")
static var purple_merchant_texture : Texture2D = preload("res://Assets/Sprites/NPC's/Merchant/Merchant_Purple.png")
static var red_merchant_texture : Texture2D = preload("res://Assets/Sprites/NPC's/Merchant/Merchant_Red.png")

static var blue_wizard_texture : Texture2D = preload("res://Assets/Sprites/NPC's/Wizard/Wizard_Blue.png")
static var green_wizard_texture : Texture2D = preload("res://Assets/Sprites/NPC's/Wizard/Wizard_Green.png")
static var purple_wizard_texture : Texture2D = preload("res://Assets/Sprites/NPC's/Wizard/Wizard_Purple.png")
static var red_wizard_texture : Texture2D = preload("res://Assets/Sprites/NPC's/Wizard/Wizard_Red.png")





static func compare_npcs(npc1:NPConfig,npc2:NPConfig) -> bool:
	print("[Helpers] Comparing npcs '",npc1.readable_name,"' and '", npc2.readable_name,"'...")
	if npc1.first_name != "" && npc2.first_name != "" && npc1.first_name != npc2.first_name:
		print("[Helpers] Neither first name is blank + they do not match, returning false")
		return false
	elif npc1.last_name != "" && npc2.last_name != "" && npc1.last_name != npc2.last_name:
		print("[Helpers] Neither last name is blank + they do not match, returning false")
		return false
	elif npc1.str_colour != "" && npc2.str_colour != "" && npc1.str_colour != npc2.str_colour:
		print("[Helpers] Neither colour is NONE + they do not match, returning false")
		return false
	elif npc1.str_type != "" && npc2.str_type != "" && npc1.str_type != npc2.str_type:
		print("[Helpers] Neither type is NONE + they do not match, returning false")
		return false
	else:
		print("[Helpers] All filled fields match! Returning true :)")
		return true
