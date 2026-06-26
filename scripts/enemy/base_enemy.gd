class_name BaseEnemy
extends CharacterBody2D
## Base enemy class with finite state machine.
## Extend for specific enemy types — override _execute_attack().

enum State {
	IDLE,
	PATROL,
	CHASE,
	ATTACK,
	HURT,
	DEAD,
}

@export var max_health: int = 30
@export var move_speed: float = 80.0
@export var detection_range: float = 200.0
@export var attack_range: float = 40.0
@export var attack_damage: int = 8
@export var attack_cooldown: float = 1.0
@export var knockback_resistance: float = 0.5
@export var score_value: int = 100

var _current_state: State = State.IDLE
var _current_health: int
var _attack_timer: float = 0.0
var _idle_timer: float = 0.0
var _attack_state_timer: float = 0.0
var _hurt_timer: float = 0.0
var _player_ref: PlayerController = null
var _patrol_direction: int = 1
var _gravity: float = 980.0


func _ready() -> void:
	_current_health = max_health


func _physics_process(delta: float) -> void:
	_update_timers(delta)
	_detect_player()

	match _current_state:
		State.IDLE:
			_handle_idle(delta)
		State.PATROL:
			_handle_patrol(delta)
		State.CHASE:
			_handle_chase(delta)
		State.ATTACK:
			_handle_attack_state(delta)
		State.HURT:
			_handle_hurt(delta)
		State.DEAD:
			pass

	if _current_state != State.DEAD:
		velocity.y += _gravity * delta
		move_and_slide()

	if _current_state == State.PATROL and is_on_wall():
		_patrol_direction *= -1


func _update_timers(delta: float) -> void:
	_attack_timer = max(0.0, _attack_timer - delta)


func _detect_player() -> void:
	if _current_state == State.DEAD or _current_state == State.HURT:
		return

	var players: Array[Node] = get_tree().get_nodes_in_group("player")
	if players.is_empty():
		_player_ref = null
		return

	_player_ref = players[0] as PlayerController
	if _player_ref == null or not _player_ref.is_alive():
		_player_ref = null
		return

	var distance: float = global_position.distance_to(_player_ref.global_position)

	if _current_state in [State.IDLE, State.PATROL]:
		if distance <= detection_range:
			_set_state(State.CHASE)
	elif _current_state == State.CHASE:
		if distance <= attack_range and _attack_timer <= 0.0:
			_set_state(State.ATTACK)
		elif distance > detection_range * 1.5:
			_set_state(State.PATROL)


func _handle_idle(delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0, move_speed * delta * 5.0)
	_idle_timer += delta
	if _idle_timer >= 1.0:
		_idle_timer = 0.0
		if _current_state == State.IDLE:
			_set_state(State.PATROL)


func _handle_patrol(delta: float) -> void:
	velocity.x = move_toward(velocity.x, _patrol_direction * move_speed * 0.5, move_speed * delta * 5.0)


func _handle_chase(delta: float) -> void:
	if _player_ref == null:
		_set_state(State.PATROL)
		return

	var direction: int = int(sign(_player_ref.global_position.x - global_position.x))
	velocity.x = move_toward(velocity.x, direction * move_speed, move_speed * delta * 10.0)


func _handle_attack_state(delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0, move_speed * delta * 10.0)
	if _attack_state_timer <= 0.0:
		_execute_attack()
	_attack_state_timer += delta
	if _attack_state_timer >= 0.3:
		_attack_state_timer = 0.0
		if _current_state == State.ATTACK:
			if _player_ref != null and global_position.distance_to(_player_ref.global_position) <= detection_range:
				_set_state(State.CHASE)
			else:
				_set_state(State.PATROL)


func _execute_attack() -> void:
	## Override in subclass for specific attack behavior.
	if _player_ref != null:
		_player_ref.take_damage(attack_damage, (_player_ref.global_position - global_position).normalized())
	_attack_timer = attack_cooldown


func take_damage(amount: int, knockback_direction: Vector2) -> void:
	if _current_state == State.DEAD:
		return

	_current_health = max(0, _current_health - amount)
	velocity = knockback_direction * 200.0 * (1.0 - knockback_resistance)

	if _current_health <= 0:
		_set_state(State.DEAD)
		EventBus.enemy_killed.emit(self)
		GameManager.add_score(score_value)
		queue_free()
	else:
		_hurt_timer = 0.0
		_set_state(State.HURT)


func _handle_hurt(delta: float) -> void:
	_hurt_timer += delta
	if _hurt_timer >= 0.2:
		_hurt_timer = 0.0
		if _current_state == State.HURT:
			if _player_ref != null and global_position.distance_to(_player_ref.global_position) <= detection_range:
				_set_state(State.CHASE)
			else:
				_set_state(State.PATROL)


func _set_state(new_state: State) -> void:
	if _current_state == new_state:
		return
	if _current_state == State.DEAD:
		return
	_current_state = new_state


func is_dead() -> bool:
	return _current_state == State.DEAD


func get_current_health() -> int:
	return _current_health
