extends Node
## Game state manager — autoloaded as "GameManager".
## Manages game state transitions, scene loading, and global score.

enum GameState {
	MAIN_MENU,
	PLAYING,
	PAUSED,
	GAME_OVER,
}

const MAIN_MENU_SCENE: String = "res://scenes/ui/main_menu.tscn"
const LEVEL_01_SCENE: String = "res://scenes/levels/level_01.tscn"
const GAME_OVER_SCENE: String = "res://scenes/ui/game_over_screen.tscn"

var _current_state: GameState = GameState.MAIN_MENU
var _score: int = 0
var _high_score: int = 0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func start_game() -> void:
	_score = 0
	_change_state(GameState.PLAYING)
	var _err: int = get_tree().change_scene_to_file(LEVEL_01_SCENE)


func end_game() -> void:
	if _score > _high_score:
		_high_score = _score
	_change_state(GameState.GAME_OVER)
	EventBus.player_died.emit()
	var _err: int = get_tree().change_scene_to_file(GAME_OVER_SCENE)


func restart_game() -> void:
	start_game()


func quit_game() -> void:
	get_tree().quit()


func return_to_menu() -> void:
	_change_state(GameState.MAIN_MENU)
	var _err: int = get_tree().change_scene_to_file(MAIN_MENU_SCENE)


func toggle_pause() -> void:
	if _current_state == GameState.PLAYING:
		_change_state(GameState.PAUSED)
		get_tree().paused = true
	elif _current_state == GameState.PAUSED:
		_change_state(GameState.PLAYING)
		get_tree().paused = false


func add_score(amount: int) -> void:
	_score += amount
	if _score < 0:
		_score = 0
	EventBus.score_changed.emit(_score)


func get_score() -> int:
	return _score


func get_high_score() -> int:
	return _high_score


func get_state() -> GameState:
	return _current_state


func _change_state(new_state: GameState) -> void:
	var old_state: GameState = _current_state
	_current_state = new_state
	EventBus.game_state_changed.emit(GameState.keys()[new_state].to_lower())
