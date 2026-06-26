class_name ShadowCrawler
extends BaseEnemy
## Ground-based melee enemy. Patrols until player detected, then charges.

@export var charge_speed_multiplier: float = 1.8


func _ready() -> void:
	super._ready()
	add_to_group("enemy")
	max_health = 30
	move_speed = 80.0
	detection_range = 200.0
	attack_range = 40.0
	attack_damage = 10
	attack_cooldown = 1.2
	score_value = 100


func _execute_attack() -> void:
	if _player_ref == null:
		return

	var knockback_dir: Vector2 = (_player_ref.global_position - global_position).normalized()
	if knockback_dir == Vector2.ZERO:
		knockback_dir = Vector2(float(_patrol_direction), 0)

	_player_ref.take_damage(attack_damage, knockback_dir)
	_attack_timer = attack_cooldown


func _handle_chase(delta: float) -> void:
	if _player_ref == null:
		_set_state(State.PATROL)
		return

	var direction: int = int(sign(_player_ref.global_position.x - global_position.x))
	velocity.x = move_toward(velocity.x, direction * move_speed * charge_speed_multiplier, move_speed * delta * 15.0)
	_patrol_direction = direction
