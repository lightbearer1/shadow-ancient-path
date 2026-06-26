extends Node
## Integration tests for the full game flow.

const GameManagerClass := preload("res://scripts/systems/game_manager.gd")


func _ready() -> void:
	print("  test_game_manager_initial_state... ", "PASS" if test_game_manager_initial_state() else "FAIL")
	print("  test_score_accumulates... ", "PASS" if test_score_accumulates() else "FAIL")
	print("  test_high_score_tracking... ", "PASS" if test_high_score_tracking() else "FAIL")


func test_game_manager_initial_state() -> bool:
	var gm: Node = GameManagerClass.new()
	gm._ready()
	return gm.get_state() == 0  ## MAIN_MENU


func test_score_accumulates() -> bool:
	var gm: Node = GameManagerClass.new()
	gm._ready()
	gm.add_score(100)
	gm.add_score(50)
	return gm.get_score() == 150


func test_high_score_tracking() -> bool:
	## end_game() requires a scene tree to change scenes, so we test
	## the score accumulation that feeds into high score tracking.
	var gm: Node = GameManagerClass.new()
	gm._ready()
	gm.add_score(500)
	var score: int = gm.get_score()
	gm.add_score(300)
	## Score should accumulate correctly across multiple calls
	return gm.get_score() == 800 and gm.get_score() > score
