class_name CameraController
extends Camera2D
## Follows the player and clamps to room boundaries.

@export var follow_target: Node2D = null
@export var follow_speed: float = 5.0
@export var room_bounds: Array[Rect2] = []
@export var current_room: int = 0

var _target_bounds: Rect2


func _ready() -> void:
	if follow_target == null:
		var players: Array[Node] = get_tree().get_nodes_in_group("player")
		if not players.is_empty():
			follow_target = players[0] as Node2D

	if room_bounds.is_empty():
		room_bounds.append(Rect2(0, 0, 1280, 720))

	_target_bounds = room_bounds[0]
	enabled = true
	position_smoothing_enabled = true
	position_smoothing_speed = follow_speed


func _physics_process(_delta: float) -> void:
	if follow_target == null:
		return

	global_position = follow_target.global_position

	## Clamp to current room bounds
	limit_left = int(_target_bounds.position.x)
	limit_top = int(_target_bounds.position.y)
	limit_right = int(_target_bounds.position.x + _target_bounds.size.x)
	limit_bottom = int(_target_bounds.position.y + _target_bounds.size.y)


func set_room(room_index: int) -> void:
	if room_index >= 0 and room_index < room_bounds.size():
		current_room = room_index
		_target_bounds = room_bounds[room_index]
		limit_smoothed = true


func snap_to_target() -> void:
	## Instantly snap camera to follow target, resetting smoothing
	if follow_target != null:
		global_position = follow_target.global_position
		reset_smoothing()


func get_current_room() -> int:
	return current_room
