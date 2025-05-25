extends CanvasLayer

# The script for handling xp, upgrades, and levels

@onready var p : Dumby = get_parent() ## Reference to the Parent Node, Dumby

signal Level_Up(level : int)
signal Level_Up_Finished

func _init() -> void:
	Level_Up.connect(_on_level_up)
	Level_Up_Finished.connect(_on_level_up_finished)

func _ready() -> void:
	g.next_lvl_xp = (10 * (g.level + 1) ) - 5
	g.xp = 0
	g.level = 1
	hide()
	g.next_lvl_xp = (10 * (g.level + 1) ) - 5

func _process(_delta: float) -> void:
	level_xp_handling()

func level_xp_handling() -> void:
	%"2next".text = str(
	"EXP: \n",
	g.xp, " / ", g.next_lvl_xp, "\n",
	"LVL:", g.level
	)
	
	
	
	if g.xp >= g.next_lvl_xp:
		if g.game_state == g.game_states.Combat:
			%newgunim.play("newgun")
			g.xp = 0
			g.level += 1
			Level_Up.emit(g.level)
	
	#if g.game_state == g.game_states.LevelUp:
	#	if get_tree().paused:
	#		Level_Up_Finished.emit()

func _on_level_up(level: int) -> void:
	get_tree().paused = true
	g.game_state = g.game_states.LevelUp
	show()
	g.next_lvl_xp = (10 * (level + 1) ) - 5
	Level_Up_Finished.emit()

func _on_level_up_finished() -> void:
	get_tree().paused = false
	g.game_state = g.game_states.Combat
	hide()

func _on_choose_pressed() -> void:
	Level_Up_Finished.emit()

func _on_reroll_pressed() -> void:
	print("Reroll Upgrades")

func _on_skip_pressed() -> void:
	Level_Up_Finished.emit()
