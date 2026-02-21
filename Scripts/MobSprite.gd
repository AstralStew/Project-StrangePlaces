class_name MobSprite extends Sprite2D



@export var shadermat : ShaderMaterial = null

@onready var shadow : Sprite2D =$Shadow


@export var fade_colour_speed = 1.0

@export var corrupt_amount = 0.05
@export var corrupt_speed = 0.05

@export_category("SHADER")

@export var corrupt_abberration_amount = 0.05
@export var corrupt_noise_amount = 0.1
@export var corrupt_noise_speeds : Vector2 = Vector2(0.1,0.3)
@export var corrupt_shadow_skew : float = -70

@export_category("READ ONLY")

@export var corrupt_noise_speed : float = 0

var _corrupted : bool = false
@export var corrupted : bool = false :
	get:
		return _corrupted
	set(value):
		if !_corrupted && value == true:
			_set_corrupt_materials()
		_corrupted = value

var facing_right : bool = false :
	set(value): 
		if value == flip_h: return
		flip_h = value
		offset.x = 20 if flip_h else 0

func took_damage() -> void:
	modulate = Color.RED



func _set_corrupt_materials() -> void:
	material = shadermat.duplicate(true) as ShaderMaterial
	(material as ShaderMaterial).set_shader_parameter("albedo_texture",texture)
	shadow.self_modulate = Color.html("e224ffff")
	material_timer += randf()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	corrupt_noise_speed =  randf_range(corrupt_noise_speeds.x,corrupt_noise_speeds.y)

var material_timer = 0.0
var glitch_amount = 0.0
func _physics_process(delta: float) -> void:
	
	if modulate != Color.WHITE:
		modulate = modulate.lightened(fade_colour_speed * delta)
	
	if corrupted:
		material_timer += delta
		glitch_amount = clamp((sin(material_timer) * 0.5) + 0.5 + randf_range(-0.25,0.25),0,1) #* corrupt_amount
		
		(material as ShaderMaterial).set_shader_parameter("chromatic_abberation",glitch_amount * corrupt_abberration_amount)
		(material as ShaderMaterial).set_shader_parameter("noise_amount",glitch_amount * corrupt_noise_amount)
		(material as ShaderMaterial).set_shader_parameter("noise_speed",corrupt_noise_speed)
		shadow.skew = deg_to_rad(glitch_amount * corrupt_shadow_skew)
	
