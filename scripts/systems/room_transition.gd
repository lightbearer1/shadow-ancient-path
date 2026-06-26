class_name RoomTransition
extends Area2D
## Detects player entry and switches the camera to the opposite room.
## Bidirectional: room_a <-> room_b

@export var room_a: int = 0
@export var room_b: int = 1


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

	## Switch to the OTHER room
	var current_room: int = cam.get_current_room()
	if current_room == room_a:
		cam.set_room(room_b)
	else:
		cam.set_room(room_a)
