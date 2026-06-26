class_name Wraith
extends BaseEnemy
## Floating enemy with ranged projectile attack. Hovers above ground.

@export var hover_amplitude: float = 10.0
@export var hover_frequency: float = 2.0
@export var projectile_scene: PackedScene = null

var _hover_time: float = 0.0
var _base_y: float = 0.0


func _ready() -> void:
	super._ready()
	add_to_group("enemy")
	max_health = 20
	move_speed = 60.0
	detection_range = 300.0
	attack_range = 150.0
	attack_damage = 6
	attack_cooldown = 2.0
	score_value = 150
	_gravity = 0.0  ## Wraiths float — no gravity


func _setup_sprite() -> void:
	var sprite: AnimatedSprite2D = get_node_or_null("AnimatedSprite2D") as AnimatedSprite2D
	if sprite == null:
		return

	var sheet: ImageTexture = PixelSpriteGenerator.generate_wraith_sheet()
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
	frames.set_animation_speed("walk", 4.0)
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


func _physics_process(delta: float) -> void:
	_update_hover(delta)
	super._physics_process(delta)


func _update_hover(delta: float) -> void:
	_hover_time += delta
	if _base_y == 0.0:
		_base_y = global_position.y
	global_position.y = _base_y + sin(_hover_time * hover_frequency) * hover_amplitude


func _execute_attack() -> void:
	if _player_ref == null:
		return

	var direction: Vector2 = (_player_ref.global_position - global_position).normalized()

	## Create a simple projectile via Area2D as child
	var projectile: Area2D = Area2D.new()
	var collision_shape: CollisionShape2D = CollisionShape2D.new()
	var circle_shape: CircleShape2D = CircleShape2D.new()
	circle_shape.radius = 6.0
	collision_shape.shape = circle_shape
	projectile.add_child(collision_shape)

	projectile.global_position = global_position
	add_sibling(projectile)

	## Move projectile over time
	var tween: Tween = create_tween()
	var target_pos: Vector2 = global_position + direction * 400.0
	tween.tween_property(projectile, "global_position", target_pos, 0.8)
	tween.tween_callback(projectile.queue_free)

	## Check collision each frame
	await _check_projectile_hits(projectile, 0.8)
	_attack_timer = attack_cooldown


func _check_projectile_hits(projectile: Area2D, duration: float) -> void:
	var elapsed: float = 0.0
	while elapsed < duration and is_instance_valid(projectile):
		if _player_ref != null and projectile.global_position.distance_to(_player_ref.global_position) < 20.0:
			_player_ref.take_damage(attack_damage, (_player_ref.global_position - projectile.global_position).normalized())
			if is_instance_valid(projectile):
				projectile.queue_free()
			break
		await get_tree().process_frame
		elapsed += get_process_delta_time()
