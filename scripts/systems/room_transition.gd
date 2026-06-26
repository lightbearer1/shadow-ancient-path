class_name RoomTransition
extends Area2D
## Detects player entry and switches the camera to the target room.

@export var target_room: int = 0


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is PlayerController:
		var cameras: Array[Node] = get_tree().get_nodes_in_group("camera")
		if not cameras.is_empty():
			var cam: CameraController = cameras[0] as CameraController
			if cam != null:
				cam.set_room(target_room)
