class_name PlayerController
extends CharacterBody2D
## Player character controller with finite state machine.
## Handles input, movement, combat, and state transitions.

enum State {
	IDLE,
	RUN,
	JUMP,
	FALL,
	DASH,
	ATTACK,
	HURT,
	DEAD,
}

@export var stats: PlayerStats

var _current_state: State = State.IDLE
var _current_health: int
var _facing_direction: int = 1  ## 1 = right, -1 = left
var _dash_timer: float = 0.0
var _dash_cooldown_timer: float = 0.0
var _attack_timer: float = 0.0
var _invincibility_timer: float = 0.0
var _combo_step: int = 0
var _combo_timeout: float = 0.0
var _double_jump_used: bool = false
var _can_dash: bool = true


func _ready() -> void:
	if stats == null:
		stats = load("res://resources/player/default_stats.tres") as PlayerStats
	_current_health = stats.max_health
	EventBus.player_health_changed.emit(_current_health, stats.max_health)
	_setup_sprite()


func _physics_process(delta: float) -> void:
	_update_timers(delta)

	match _current_state:
		State.IDLE, State.RUN:
			_handle_movement(delta)
		State.JUMP, State.FALL:
			_handle_air_movement(delta)
		State.DASH:
			_handle_dash(delta)
		State.ATTACK:
			_handle_attack_state(delta)
		State.HURT:
			_handle_hurt(delta)
		State.DEAD:
			pass

	move_and_slide()
	_check_state_transitions()


func _update_timers(delta: float) -> void:
	_dash_cooldown_timer = max(0.0, _dash_cooldown_timer - delta)
	_dash_timer = max(0.0, _dash_timer - delta)
	_attack_timer = max(0.0, _attack_timer - delta)
	_invincibility_timer = max(0.0, _invincibility_timer - delta)

	if _dash_cooldown_timer <= 0.0 and not _can_dash:
		_can_dash = true

	if _combo_step > 0:
		_combo_timeout = max(0.0, _combo_timeout - delta)
		if _combo_timeout <= 0.0:
			_combo_step = 0
			EventBus.combo_changed.emit(_combo_step)


func _handle_movement(delta: float) -> void:
	var input_dir: float = Input.get_axis("move_left", "move_right")

	if input_dir != 0:
		_facing_direction = int(sign(input_dir))
		velocity.x = input_dir * stats.move_speed
		_set_state(State.RUN)
	else:
		velocity.x = move_toward(velocity.x, 0, stats.move_speed * delta * 10.0)
		_set_state(State.IDLE)

	if is_on_floor():
		_double_jump_used = false

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = stats.jump_velocity
		_set_state(State.JUMP)

	if not is_on_floor():
		_set_state(State.FALL)

	if Input.is_action_just_pressed("dash") and _can_dash:
		_start_dash(input_dir if input_dir != 0 else _facing_direction)

	if Input.is_action_just_pressed("attack"):
		_start_attack()

	if Input.is_action_just_pressed("jump") and not _double_jump_used:
		velocity.y = stats.jump_velocity * 0.8
		_double_jump_used = true

	velocity.y += stats.gravity * delta


func _handle_air_movement(delta: float) -> void:
	var input_dir: float = Input.get_axis("move_left", "move_right")

	if input_dir != 0:
		_facing_direction = int(sign(input_dir))
		velocity.x = input_dir * stats.move_speed

	if Input.is_action_just_pressed("dash") and _can_dash:
		_start_dash(input_dir if input_dir != 0 else _facing_direction)

	if Input.is_action_just_pressed("attack"):
		_start_attack()

	if Input.is_action_just_pressed("jump") and not _double_jump_used:
		velocity.y = stats.jump_velocity * 0.8
		_double_jump_used = true

	velocity.y += stats.gravity * delta

	if velocity.y < 0:
		_set_state(State.JUMP)
	else:
		_set_state(State.FALL)

	if is_on_floor():
		_set_state(State.IDLE)


func _start_dash(direction: int) -> void:
	velocity.y = 0
	velocity.x = direction * stats.dash_speed
	_dash_timer = stats.dash_duration
	_dash_cooldown_timer = stats.dash_cooldown
	_can_dash = false
	_set_state(State.DASH)


func _handle_dash(_delta: float) -> void:
	if _dash_timer <= 0.0:
		velocity.x = 0
		if is_on_floor():
			_set_state(State.IDLE)
		else:
			_set_state(State.FALL)


func _start_attack() -> void:
	if _attack_timer > 0.0:
		return

	## Combo logic: step 0->1->2, max 2 (3 hits total: step 0,1,2)
	_combo_step = (_combo_step + 1) % 3
	_combo_timeout = 1.5  ## Reset combo if no attack within 1.5s
	EventBus.combo_changed.emit(_combo_step)

	_attack_timer = stats.attack_cooldown
	_set_state(State.ATTACK)

	## Combo damage multiplier: step 2 (third hit) deals 1.8x
	var combo_mult: float = 1.0
	if _combo_step == 2:
		combo_mult = 1.8

	var hit_boxes: Array[Node] = get_tree().get_nodes_in_group("player_hitbox")
	for hit_box: Area2D in hit_boxes:
		if hit_box is HitBox:
			(hit_box as HitBox).damage = int(float(stats.attack_damage) * combo_mult)
		hit_box.monitoring = true
		await get_tree().create_timer(0.15).timeout
		if hit_box is HitBox:
			(hit_box as HitBox).damage = stats.attack_damage  ## Reset
		hit_box.monitoring = false

	if _current_state == State.ATTACK:
		_set_state(State.IDLE)


func _handle_attack_state(_delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0, stats.move_speed * _delta * 5.0)
	velocity.y += stats.gravity * _delta


func take_damage(amount: int, knockback_direction: Vector2) -> void:
	if _invincibility_timer > 0.0 or _current_state == State.DEAD:
		return

	var actual_damage: int = max(1, amount)
	_current_health = max(0, _current_health - actual_damage)
	_invincibility_timer = stats.invincibility_duration
	velocity = knockback_direction * stats.attack_knockback
	EventBus.player_health_changed.emit(_current_health, stats.max_health)

	if _current_health <= 0:
		_set_state(State.DEAD)
		await get_tree().create_timer(1.5).timeout
		GameManager.end_game()
	else:
		_set_state(State.HURT)


func _handle_hurt(_delta: float) -> void:
	velocity.y += stats.gravity * _delta
	if _invincibility_timer <= stats.invincibility_duration - 0.3:
		if is_on_floor():
			_set_state(State.IDLE)
		else:
			_set_state(State.FALL)


func _check_state_transitions() -> void:
	if _current_state == State.DEAD or _current_state == State.DASH or _current_state == State.HURT:
		return

	if _current_state == State.ATTACK and _attack_timer > (stats.attack_cooldown - 0.15):
		return

	if not is_on_floor() and _current_state not in [State.JUMP, State.FALL]:
		_set_state(State.FALL)


func _set_state(new_state: State) -> void:
	if _current_state == new_state:
		return
	if _current_state == State.DEAD:
		return
	_current_state = new_state
	_update_animation()


func _setup_sprite() -> void:
	var sprite: AnimatedSprite2D = get_node_or_null("AnimatedSprite2D") as AnimatedSprite2D
	if sprite == null:
		return

	var sheet: ImageTexture = PixelSpriteGenerator.generate_player_sheet()
	var frames: SpriteFrames = SpriteFrames.new()

	## Slice the sheet into 6 frames (each 32x32)
	for i in 6:
		var frame_img: Image = Image.create(32, 32, false, Image.FORMAT_RGBA8)
		frame_img.blit_rect(sheet.get_image(), Rect2i(i * 32, 0, 32, 32), Vector2i.ZERO)
		var frame_tex: ImageTexture = ImageTexture.create_from_image(frame_img)
		frames.add_frame("default", frame_tex)

	## Create animations
	frames.set_animation_speed("default", 5.0)
	frames.add_animation("idle")
	frames.set_animation_speed("idle", 1.0)
	frames.set_animation_loop("idle", true)
	frames.add_frame("idle", frames.get_frame_texture("default", 0))

	frames.add_animation("run")
	frames.set_animation_speed("run", 8.0)
	frames.set_animation_loop("run", true)
	frames.add_frame("run", frames.get_frame_texture("default", 1))
	frames.add_frame("run", frames.get_frame_texture("default", 2))

	frames.add_animation("jump")
	frames.set_animation_loop("jump", false)
	frames.add_frame("jump", frames.get_frame_texture("default", 3))

	frames.add_animation("attack")
	frames.set_animation_speed("attack", 12.0)
	frames.set_animation_loop("attack", false)
	frames.add_frame("attack", frames.get_frame_texture("default", 4))

	frames.add_animation("hurt")
	frames.set_animation_loop("hurt", false)
	frames.add_frame("hurt", frames.get_frame_texture("default", 5))

	sprite.sprite_frames = frames
	sprite.play("idle")


func _update_animation() -> void:
	var sprite: AnimatedSprite2D = get_node_or_null("AnimatedSprite2D") as AnimatedSprite2D
	if sprite == null:
		return

	match _current_state:
		State.IDLE:
			sprite.play("idle")
		State.RUN:
			sprite.play("run")
		State.JUMP, State.FALL:
			sprite.play("jump")
		State.ATTACK:
			sprite.play("attack")
		State.HURT:
			sprite.play("hurt")
		State.DASH:
			sprite.play("jump")

	sprite.flip_h = _facing_direction < 0


func get_current_health() -> int:
	return _current_health


func get_facing_direction() -> int:
	return _facing_direction


func is_alive() -> bool:
	return _current_state != State.DEAD
