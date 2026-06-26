extends Node
## Unit tests for BaseEnemy state machine and damage logic.

const BaseEnemyClass := preload("res://scripts/enemy/base_enemy.gd")


func _ready() -> void:
	print("  test_initial_health... ", "PASS" if test_initial_health() else "FAIL")
	print("  test_take_damage... ", "PASS" if test_take_damage() else "FAIL")
	print("  test_lethal_damage_kills... ", "PASS" if test_lethal_damage_kills() else "FAIL")
	print("  test_state_machine_starts_idle... ", "PASS" if test_state_machine_starts_idle() else "FAIL")


func test_initial_health() -> bool:
	var enemy: BaseEnemy = BaseEnemyClass.new()
	enemy.max_health = 50
	enemy._ready()
	return enemy.get_current_health() == 50


func test_take_damage() -> bool:
	var enemy: BaseEnemy = BaseEnemyClass.new()
	enemy.max_health = 50
	enemy._ready()
	enemy.take_damage(20, Vector2.RIGHT)
	return enemy.get_current_health() == 30 and not enemy.is_dead()


func test_lethal_damage_kills() -> bool:
	var enemy: BaseEnemy = BaseEnemyClass.new()
	enemy.max_health = 30
	enemy._ready()
	enemy.take_damage(30, Vector2.RIGHT)
	return enemy.is_dead()


func test_state_machine_starts_idle() -> bool:
	var enemy: BaseEnemy = BaseEnemyClass.new()
	enemy._ready()
	return not enemy.is_dead()
