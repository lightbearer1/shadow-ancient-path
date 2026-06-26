extends Node
## Unit tests for PlayerController state transitions and health logic.

const PlayerControllerClass := preload("res://scripts/player/player_controller.gd")
const PlayerStatsClass := preload("res://scripts/player/player_stats.gd")


func _ready() -> void:
	print("  test_initial_state... ", "PASS" if test_initial_state() else "FAIL")
	print("  test_take_damage_reduces_health... ", "PASS" if test_take_damage_reduces_health() else "FAIL")
	print("  test_fatal_damage_kills... ", "PASS" if test_fatal_damage_kills() else "FAIL")
	print("  test_invincibility_prevents_damage... ", "PASS" if test_invincibility_prevents_damage() else "FAIL")


func test_initial_state() -> bool:
	var player: PlayerController = PlayerControllerClass.new()
	var stats: PlayerStats = PlayerStatsClass.new()
	stats.max_health = 100
	player.stats = stats
	player._ready()
	return player.get_current_health() == 100 and player.is_alive()


func test_take_damage_reduces_health() -> bool:
	var player: PlayerController = PlayerControllerClass.new()
	var stats: PlayerStats = PlayerStatsClass.new()
	stats.max_health = 100
	stats.invincibility_duration = 0.01
	player.stats = stats
	player._ready()
	player.take_damage(20, Vector2.LEFT)
	return player.get_current_health() == 80 and player.is_alive()


func test_fatal_damage_kills() -> bool:
	var player: PlayerController = PlayerControllerClass.new()
	var stats: PlayerStats = PlayerStatsClass.new()
	stats.max_health = 100
	stats.invincibility_duration = 0.01
	player.stats = stats
	player._ready()
	player.take_damage(100, Vector2.LEFT)
	return not player.is_alive()


func test_invincibility_prevents_damage() -> bool:
	var player: PlayerController = PlayerControllerClass.new()
	var stats: PlayerStats = PlayerStatsClass.new()
	stats.max_health = 100
	stats.invincibility_duration = 99.0
	player.stats = stats
	player._ready()
	player.take_damage(50, Vector2.LEFT)
	var health_after_first: int = player.get_current_health()
	player.take_damage(50, Vector2.LEFT)
	return health_after_first == player.get_current_health()
