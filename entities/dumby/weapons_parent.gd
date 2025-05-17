extends Node2D
class_name WeaponsParent

@export var dumby : Dumby
@export var ammo_bar : ProgressBar
var ammo_text : Label
@export var current_weapon : Weapon

@onready var regen_bar: ProgressBar = %regen_bar
@onready var health_component: HealthComponent = %HealthComponent
@onready var reload_bar: ProgressBar = %reload_bar
@onready var max_ss_vis: ProgressBar = %max_ss_vis
@onready var min_ss_vis: ProgressBar = %min_ss_vis

signal Tactical_Reload

func _ready() -> void:
	ammo_text = ammo_bar.get_child(0)

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	regen_bar.visible = not Input.is_action_pressed("shoot") and health_component.hp < health_component.max_hp and not current_weapon.reloading
	ammo_handling(delta)
	reload_bar.visible = current_weapon.reloading
	max_ss_vis.visible = current_weapon.reloading
	min_ss_vis.visible = current_weapon.reloading
	if not current_weapon.reloading:
		if Input.is_action_pressed("shoot") and current_weapon.ammo > 0:
			%flashnim.play("flash")
			regen_time = 0
			regen_speed = 0.5
		else:
			regen_handling.call(delta)
			regen_bar.max_value = max_regen_time
			regen_bar.value = regen_time

### Below is stuff for ammo counts and reloading ###
var reload_time : float = 0 ## The amount of time that has passed since the start of the reload
func ammo_handling(delta: float) -> void:
	ammo_bar.max_value = current_weapon.stats.max_ammo
	ammo_bar.value = current_weapon.ammo
	
	ammo_text.text = str("Ammo : \n", current_weapon.ammo, " / ", current_weapon.stats.max_ammo)
	
	#if (Input.is_action_just_pressed("reload") and current_weapon.ammo != current_weapon.stats.max_ammo and current_weapon.ammo <= current_weapon.stats.max_ammo / 2) or current_weapon.ammo <= 0:
	if current_weapon.ammo <= 0:
		if not current_weapon.reloading:
			current_weapon.r_tact_pressed = false
			reload_time = 0
			reload_bar.max_value = current_weapon.max_reload_duration
			current_weapon.reloading = true
			
			max_ss_vis.max_value = current_weapon.max_reload_duration
			min_ss_vis.max_value = current_weapon.max_reload_duration
			
			max_ss_vis.value = current_weapon.max_sweet_spot - 0.05
			min_ss_vis.value = current_weapon.min_sweet_spot
	
	if current_weapon.reloading:
		reload_time += delta
		reload_bar.value = reload_time
		
		if reload_time >= current_weapon.max_reload_duration: ## Finished reloading
			finished_reload()
			current_weapon.buff_time = 0
		
		if Input.is_action_just_pressed("shoot") and not current_weapon.r_tact_pressed:
			current_weapon.r_tact_pressed = true
			if reload_time > current_weapon.min_sweet_spot and reload_time < current_weapon.max_sweet_spot:
				g.spawn_txt("Quick Reload", global_position)
				Tactical_Reload.emit()
				%tactical_reload_fx.rotation_degrees = randf_range(-180, 180)
				%shing.pitch_scale = randf_range(0.8, 1.2)
				%shing.play()
				%tactical_reloadnim.play("zing")
				current_weapon.buff_time = current_weapon.max_buff_time
				finished_reload()
			else:
				g.spawn_txt("Womp Womp", global_position)
				current_weapon.buff_time = 0
				
	else:
		reload_time = 0

### Below is all the stuff for regen ###
var regen_time : float = 0
var max_regen_time : float = 2
var regen_speed : float = 0.5
var regen_speed_limit : float = 1
# Goofy lmbda function stuff
var regen_handling : Callable = func(delta:float) -> void:
	if health_component.hp < health_component.max_hp:
		regen_speed += delta * 0.1
		regen_time += delta * regen_speed
	else:
		regen_time = 0
		regen_speed = 0.5
	
	if regen_speed >= regen_speed_limit:
		regen_speed = regen_speed_limit
	
	if regen_time >= max_regen_time:
		regen_time = 0
		heal()

func _on_hurtbox_component_plr_hit(_dmg: int) -> void:
	regen_speed = 0.2

func heal()->void:
	if health_component.hp < health_component.max_hp:
		health_component.hp += 1
		g.spawn_txt("+1 HP!", global_position)

func finished_reload() -> void:
	current_weapon.reloading = false
	current_weapon.ammo = current_weapon.stats.max_ammo
