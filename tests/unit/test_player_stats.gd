extends Node
## Unit tests for PlayerStats resource.

const PlayerStatsClass := preload("res://scripts/player/player_stats.gd")


func _ready() -> void:
	print("  test_default_values... ", "PASS" if test_default_values() else "FAIL")
	print("  test_apply_upgrades... ", "PASS" if test_apply_upgrades() else "FAIL")
	print("  test_apply_upgrades_preserves_original... ", "PASS" if test_apply_upgrades_preserves_original() else "FAIL")


func test_default_values() -> bool:
	var stats: PlayerStats = PlayerStatsClass.new()
	return stats.max_health == 100 and stats.move_speed == 200.0 and stats.attack_damage == 10


func test_apply_upgrades() -> bool:
	var stats: PlayerStats = PlayerStatsClass.new()
	var upgraded: PlayerStats = stats.apply_upgrades({"max_health": 20, "attack_damage": 5})
	return upgraded.max_health == 120 and upgraded.attack_damage == 15


func test_apply_upgrades_preserves_original() -> bool:
	var stats: PlayerStats = PlayerStatsClass.new()
	var _upgraded: PlayerStats = stats.apply_upgrades({"max_health": 50})
	return stats.max_health == 100  ## Original unchanged
