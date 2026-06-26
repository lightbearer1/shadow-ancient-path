class_name HealthBar
extends ProgressBar
## Binds to EventBus.player_health_changed to display HP.

@export var show_numbers: bool = true

var _label: Label = null


func _ready() -> void:
	EventBus.player_health_changed.connect(_on_player_health_changed)

	if show_numbers:
		_label = Label.new()
		_label.add_theme_font_size_override("font_size", 14)
		_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		add_child(_label)
		_update_label()


func _on_player_health_changed(current_hp: int, max_hp: int) -> void:
	max_value = float(max_hp)
	value = float(current_hp)

	if current_hp < max_hp * 0.3:
		self_modulate = Color(1.0, 0.2, 0.2)
	else:
		self_modulate = Color(1.0, 1.0, 1.0)

	_update_label()


func _update_label() -> void:
	if _label != null:
		_label.text = "%d / %d" % [int(value), int(max_value)]
