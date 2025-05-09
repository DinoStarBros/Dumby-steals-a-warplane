extends Camera2D
class_name PlrCamera

@export var target : CharacterBody2D
@export var sensitivity := .5
var target_position

func _ready():
	g.cam = self

func _physics_process(_delta: float) -> void:
	target_position = target.aim_position * sensitivity
	position = position.lerp(target_position, 0.25)

@export var randStrength : float = 30.0
@export var shakefade : float = 5.0

var rng = RandomNumberGenerator.new()
var shake_strength : float = 0.0

func apply_shake(strength : float):
	#shake_strength = randStrength
	shake_strength = strength

func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))

func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength,0,shakefade*delta)
		
		offset = randomOffset()
