class_name HUD
extends CanvasLayer
## Full HUD overlay with health bar, score display, combo counter, and pause.

@onready var _health_bar: HealthBar = $HealthBar
@onready var _score_label: Label = $ScoreLabel
@onready var _combo_label: Label = $ComboLabel


func _ready() -> void:
	EventBus.score_changed.connect(_on_score_changed)
	EventBus.combo_changed.connect(_on_combo_changed)


func _on_score_changed(new_score: int) -> void:
	_score_label.text = "Score: %d" % new_score


func _on_combo_changed(combo_step: int) -> void:
	if combo_step <= 0:
		_combo_label.visible = false
	else:
		_combo_label.visible = true
		_combo_label.text = "%dx COMBO" % (combo_step + 1)
		## Flash effect: scale up briefly
		var tween: Tween = create_tween()
		tween.tween_property(_combo_label, "scale", Vector2(1.3, 1.3), 0.1)
		tween.tween_property(_combo_label, "scale", Vector2(1.0, 1.0), 0.15)
