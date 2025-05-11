extends Node

var game : Game 
var cam : Camera2D
var player : CharacterBody2D

var attack : Attack = Attack.new()

var game_state : game_states = game_states.Title
var score : int = 0
var killscore : int = 0
var mobile : bool = false

enum game_states {
	Title, Combat, Lost
}

var txt_scn : = preload("res://scenes/DmgNum/dmg_num.tscn")
func spawn_txt(text: String, global_pos: Vector2)->void: ## Spawns a splash text effect, can be used for damage numbers, or score
	var txt = txt_scn.instantiate()
	txt.text = text
	txt.global_position = global_pos
	game.add_child(txt)
