class_name HUD
extends CanvasLayer
## Full HUD overlay with health bar, score display, and pause functionality.

@onready var _health_bar: HealthBar = $HealthBar
@onready var _score_label: Label = $ScoreLabel


func _ready() -> void:
	EventBus.score_changed.connect(_on_score_changed)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		GameManager.toggle_pause()


func _on_score_changed(new_score: int) -> void:
	_score_label.text = "Score: %d" % new_score
