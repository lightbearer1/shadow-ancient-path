extends SceneTree
## Headless test runner. Execute with: godot --headless --script run_tests.gd


func _init() -> void:
	print("=== 暗影古径 Test Suite ===")
	_run_test_scripts()
	print("\n========================================")
	print("Test suite complete. Check output above for individual results.")
	print("========================================")
	quit(0)


func _run_test_scripts() -> void:
	_run_tests_in_dir("res://tests/unit")
	_run_tests_in_dir("res://tests/integration")


func _run_tests_in_dir(dir_path: String) -> void:
	var dir: DirAccess = DirAccess.open(dir_path)
	if dir == null:
		print("WARNING: Directory not found: " + dir_path)
		return

	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".gd") and file_name.begins_with("test_"):
			var full_path: String = dir_path + "/" + file_name
			print("\n--- Running: " + file_name + " ---")
			var test_script: GDScript = load(full_path) as GDScript
			if test_script != null:
				var instance: Node = Node.new()
				instance.set_script(test_script)
				root.add_child(instance)
		file_name = dir.get_next()
	dir.list_dir_end()
