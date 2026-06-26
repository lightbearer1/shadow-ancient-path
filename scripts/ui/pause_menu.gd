class_name PauseMenu
extends Control
## Pause overlay with continue and quit buttons.

@onready var _continue_button: Button = $VBoxContainer/ContinueButton
@onready var _menu_button: Button = $VBoxContainer/MenuButton


func _ready() -> void:
	visible = false
	_continue_button.pressed.connect(_on_continue_pressed)
	_menu_button.pressed.connect(_on_menu_pressed)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if visible:
			_close()
		else:
			_open()


func _open() -> void:
	visible = true
	get_tree().paused = true


func _close() -> void:
	visible = false
	get_tree().paused = false


func _on_continue_pressed() -> void:
	_close()


func _on_menu_pressed() -> void:
	get_tree().paused = false
	GameManager.return_to_menu()
