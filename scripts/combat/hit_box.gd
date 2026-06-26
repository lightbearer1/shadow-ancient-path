class_name HitBox
extends Area2D
## Attached to attack animations. Deals damage to overlapping HurtBox areas.

@export var damage: int = 10
@export var knockback_force: float = 200.0

var _hit_targets: Array[Node] = []


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	monitoring = false  ## Enabled only during attack frames


func enable() -> void:
	_hit_targets.clear()
	monitoring = true


func disable() -> void:
	monitoring = false


func _on_area_entered(area: Area2D) -> void:
	if not area is HurtBox:
		return

	var target: Node = area.get_parent()
	if target in _hit_targets:
		return

	_hit_targets.append(target)

	var knockback_dir: Vector2 = (target.global_position - global_position).normalized()
	if knockback_dir == Vector2.ZERO:
		knockback_dir = Vector2(1, 0)

	if target.has_method("take_damage"):
		target.take_damage(damage, knockback_dir)
