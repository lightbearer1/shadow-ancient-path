class_name RoomTransition
extends Area2D
## Detects player entry, switches camera, and teleports player to the target room.

@export var room_a: int = 0
@export var room_b: int = 1
## Offset from transition center INTO room_a (usually negative X, going left)
@export var spawn_offset_a: Vector2 = Vector2(-60, 0)
## Offset from transition center INTO room_b (usually positive X, going right)
@export var spawn_offset_b: Vector2 = Vector2(60, 0)


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if not body is PlayerController:
		return

	var cameras: Array[Node] = get_tree().get_nodes_in_group("camera")
	if cameras.is_empty():
		return

	var cam: CameraController = cameras[0] as CameraController
	if cam == null:
		return

	var player: PlayerController = body as PlayerController
	var current_room: int = cam.get_current_room()

	if current_room == room_a:
		## Going to room_b: teleport player to the RIGHT of the transition
		cam.set_room(room_b)
		player.global_position = global_position + spawn_offset_b
	else:
		## Going to room_a: teleport player to the LEFT of the transition
		cam.set_room(room_a)
		player.global_position = global_position + spawn_offset_a

	## Force camera to snap instantly
	cam.snap_to_target()
