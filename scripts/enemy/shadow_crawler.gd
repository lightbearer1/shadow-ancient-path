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


func _setup_sprite() -> void:
	var sprite: AnimatedSprite2D = get_node_or_null("AnimatedSprite2D") as AnimatedSprite2D
	if sprite == null:
		return

	var sheet: ImageTexture = PixelSpriteGenerator.generate_crawler_sheet()
	var frames: SpriteFrames = SpriteFrames.new()

	for i in 5:
		var frame_img: Image = Image.create(32, 32, false, Image.FORMAT_RGBA8)
		frame_img.blit_rect(sheet.get_image(), Rect2i(i * 32, 0, 32, 32), Vector2i.ZERO)
		var frame_tex: ImageTexture = ImageTexture.create_from_image(frame_img)
		frames.add_frame("default", frame_tex)

	frames.add_animation("idle")
	frames.set_animation_loop("idle", true)
	frames.add_frame("idle", frames.get_frame_texture("default", 0))

	frames.add_animation("walk")
	frames.set_animation_speed("walk", 6.0)
	frames.set_animation_loop("walk", true)
	frames.add_frame("walk", frames.get_frame_texture("default", 1))
	frames.add_frame("walk", frames.get_frame_texture("default", 2))

	frames.add_animation("attack")
	frames.set_animation_loop("attack", false)
	frames.add_frame("attack", frames.get_frame_texture("default", 3))

	frames.add_animation("hurt")
	frames.set_animation_loop("hurt", false)
	frames.add_frame("hurt", frames.get_frame_texture("default", 4))

	sprite.sprite_frames = frames
	sprite.play("idle")


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
