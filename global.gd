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
