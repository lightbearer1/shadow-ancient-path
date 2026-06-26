extends SceneTree
## Headless test runner. Execute with: godot --headless --script run_tests.gd

var _total_tests: int = 0
var _passed_tests: int = 0
var _failed_tests: int = 0


func _init() -> void:
	print("=== 暗影古径 Test Suite ===")
	_run_test_scripts()
	_print_summary()
	quit(0 if _failed_tests == 0 else 1)


func _run_test_scripts() -> void:
	var test_dir: String = "res://tests"
	var dir_access: DirAccess = DirAccess.open(test_dir)
	if dir_access == null:
		print("ERROR: Cannot open test directory: " + test_dir)
		return

	_run_tests_in_dir(test_dir + "/unit")
	_run_tests_in_dir(test_dir + "/integration")


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


func _print_summary() -> void:
	print("\n========================================")
	print("Total: %d | Passed: %d | Failed: %d" % [_total_tests, _passed_tests, _failed_tests])
	print("========================================")
