class_name HurtBox
extends Area2D
## Receives damage from HitBox areas. Parent node should implement take_damage().

signal health_depleted()

## Team identifier — prevents friendly fire.
@export var team: String = "enemy"


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	if not area is HitBox:
		return

	## Damage is handled by HitBox calling take_damage() on parent.
	## This Area2D exists to be detected by HitBox overlap.
	pass
