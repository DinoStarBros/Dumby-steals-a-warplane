extends Node

var game : Game 
var cam : PlrCamera
var camRect : ColorRect
var screen_corners : Rect2
var player : CharacterBody2D
var enemy_arrows : Node

var attack : Attack = Attack.new()

var game_state : game_states = g.game_states.Title#: set = new_game_state

var score : int = 0
var killscore : int = 0

var xp : int = 0
var next_lvl_xp : int = 20
var level : int = 1

var mobile : bool = false

enum game_states {
	Title, Combat, Lost, LevelUp
}
var gs_string : Array = [
	"Title", "Combat", "Lost", "LevelUp"
]
const txt_scn : PackedScene = preload("res://scenes/DmgNum/dmg_num.tscn")
func spawn_txt(text: String, global_pos: Vector2)->void: ## Spawns a splash text effect, can be used for damage numbers, or score
	var txt : DmgNum = txt_scn.instantiate()
	txt.text = text
	txt.global_position = global_pos
	game.add_child(txt)

func _ready() -> void:
	
	process_mode = Node.PROCESS_MODE_ALWAYS

var master_volume : float
var music_volume : float
var sfx_volume : float
var screen_shake_value : bool 
var frame_freeze_value : bool
var resolution_index : int

const exp_scn : PackedScene = preload("res://scenes/exp/exp.tscn")
func spawn_xp(global_pos : Vector2, amount : int) -> void:
	var xpn : XpOrb = exp_scn.instantiate()
	g.game.add_child(xpn)
	xpn.xp_amount = amount
	xpn.global_position = global_pos

func _process(_delta:float)->void:
	AudioServer.set_bus_volume_db(
		0,
		linear_to_db(master_volume)
	)
	AudioServer.set_bus_volume_db(
		1,
		linear_to_db(music_volume)
	)
	AudioServer.set_bus_volume_db(
		2,
		linear_to_db(sfx_volume)
	)

func frame_freeze(timescale: float, duration: float) -> void: ## Slows down the engine's time scale, slowing down the time, for a certain duration. Use for da juice
	if frame_freeze_value:
		Engine.time_scale = timescale
		await get_tree().create_timer(duration, true, false, true).timeout
		Engine.time_scale = 1.0
