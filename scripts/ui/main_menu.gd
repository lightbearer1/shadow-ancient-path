class_name MainMenu
extends Control
## Title screen with Start and Quit buttons.

@onready var _start_button: Button = $VBoxContainer/StartButton
@onready var _quit_button: Button = $VBoxContainer/QuitButton


func _ready() -> void:
	_start_button.pressed.connect(_on_start_pressed)
	_quit_button.pressed.connect(_on_quit_pressed)


func _on_start_pressed() -> void:
	GameManager.start_game()


func _on_quit_pressed() -> void:
	GameManager.quit_game()
