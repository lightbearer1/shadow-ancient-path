class_name EnemySpawner
extends Node2D
## Spawns enemy waves at configured marker positions.
## Emits all_clear signal when all spawned enemies are dead.

@export var enemy_scenes: Array[PackedScene] = []
@export var spawn_markers: Array[Marker2D] = []
@export var waves: Array[EnemyWave] = []
@export var auto_start: bool = true

signal all_clear()

var _spawned_enemies: Array[Node] = []
var _current_wave_index: int = -1
var _room_index: int = 0


func _ready() -> void:
	for marker in get_children():
		if marker is Marker2D and marker not in spawn_markers:
			spawn_markers.append(marker)

	if auto_start:
		start_spawning()


func start_spawning() -> void:
	_spawn_next_wave()


func _spawn_next_wave() -> void:
	_current_wave_index += 1
	if _current_wave_index >= waves.size():
		return

	var wave: EnemyWave = waves[_current_wave_index]

	for i in wave.count:
		var scene: PackedScene = enemy_scenes[i % enemy_scenes.size()]
		var enemy: Node = scene.instantiate()

		var spawn_pos: Vector2 = global_position
		if i < spawn_markers.size():
			spawn_pos = spawn_markers[i].global_position
		else:
			spawn_pos.x += i * 40.0

		enemy.global_position = spawn_pos
		get_parent().add_child(enemy)
		_spawned_enemies.append(enemy)

		## Connect to death signal
		if enemy.has_signal("tree_exited"):
			enemy.tree_exited.connect(_on_enemy_removed.bind(enemy))


func _on_enemy_removed(enemy: Node) -> void:
	_spawned_enemies.erase(enemy)
	_check_all_clear()


func _check_all_clear() -> void:
	if _spawned_enemies.is_empty() and _current_wave_index >= waves.size() - 1:
		all_clear.emit()
		EventBus.room_cleared.emit(_room_index)
	elif _spawned_enemies.is_empty():
		await get_tree().create_timer(1.0).timeout
		_spawn_next_wave()


func set_room_index(index: int) -> void:
	_room_index = index
