extends Node
## Unit tests for HitBox and HurtBox combat components.

const HitBoxClass := preload("res://scripts/combat/hit_box.gd")
const HurtBoxClass := preload("res://scripts/combat/hurt_box.gd")


func _ready() -> void:
	print("  test_hit_box_default_damage... ", "PASS" if test_hit_box_default_damage() else "FAIL")
	print("  test_hit_box_starts_disabled... ", "PASS" if test_hit_box_starts_disabled() else "FAIL")
	print("  test_hurt_box_team_default... ", "PASS" if test_hurt_box_team_default() else "FAIL")


func test_hit_box_default_damage() -> bool:
	var hit_box: HitBox = HitBoxClass.new()
	return hit_box.damage == 10


func test_hit_box_starts_disabled() -> bool:
	var hit_box: HitBox = HitBoxClass.new()
	hit_box._ready()
	return not hit_box.monitoring


func test_hurt_box_team_default() -> bool:
	var hurt_box: HurtBox = HurtBoxClass.new()
	return hurt_box.team == "enemy"
