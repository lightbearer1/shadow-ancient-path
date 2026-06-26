class_name GameOverScreen
extends Control
## Death screen showing score and offering restart or quit.

@onready var _score_label: Label = $ScoreLabel
@onready var _restart_button: Button = $VBoxContainer/RestartButton
@onready var _quit_button: Button = $VBoxContainer/QuitButton


func _ready() -> void:
	_score_label.text = "Score: %d\nBest: %d" % [GameManager.get_score(), GameManager.get_high_score()]
	_restart_button.pressed.connect(_on_restart_pressed)
	_quit_button.pressed.connect(_on_quit_pressed)


func _on_restart_pressed() -> void:
	GameManager.restart_game()


func _on_quit_pressed() -> void:
	GameManager.return_to_menu()
