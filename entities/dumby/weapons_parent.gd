extends Node2D
class_name WeaponsParent

@export var dumby : Dumby

@onready var regen_bar: ProgressBar = %regen_bar
@onready var health_component: HealthComponent = %HealthComponent

func _ready() -> void:
	pass

var regen_time : float = 0
var max_regen_time : float = 2
var regen_speed : float = 0.5
var regen_speed_limit : float = 1.5
func _process(delta: float) -> void:
	
	look_at(get_global_mouse_position())
	
	%regen_bar.visible = not Input.is_action_pressed("shoot") and health_component.hp < health_component.max_hp
	
	if Input.is_action_pressed("shoot"):
		%flashnim.play("flash")
		regen_time = 0
		regen_speed = 0.5
	else:
		if health_component.hp < health_component.max_hp:
			regen_speed += delta * 0.4
			regen_time += delta * regen_speed
		else:
			regen_time = 0
			regen_speed = 0.5
		
		if regen_speed >= regen_speed_limit:
			regen_speed = regen_speed_limit
		
		if regen_time >= max_regen_time:
			regen_time = 0
			heal()
		
		regen_bar.max_value = max_regen_time
		regen_bar.value = regen_time

func heal()->void:
	if health_component.hp < health_component.max_hp:
		health_component.hp += 1
		spawn_txt("+1 HP!")

var txt_scn : = preload("res://scenes/DmgNum/dmg_num.tscn")
func spawn_txt(text:String)->void:
	var txt = txt_scn.instantiate()
	txt.text = text
	txt.global_position = global_position
	g.game.add_child(txt)
