class_name PlayerStats
extends Resource
## Configurable player stat block. Create .tres instances for different builds.

@export var max_health: int = 100
@export var move_speed: float = 200.0
@export var jump_velocity: float = -800.0
@export var dash_speed: float = 500.0
@export var dash_duration: float = 0.15
@export var dash_cooldown: float = 1.0
@export var attack_damage: int = 10
@export var attack_knockback: float = 200.0
@export var attack_cooldown: float = 0.4
@export var gravity: float = 980.0
@export var invincibility_duration: float = 1.0

## Returns a copy of stats modified by upgrades (v0.2+).
func apply_upgrades(upgrades: Dictionary) -> PlayerStats:
	var new_stats: PlayerStats = duplicate()
	for key in upgrades:
		match key:
			"max_health":
				new_stats.max_health += upgrades[key]
			"move_speed":
				new_stats.move_speed += upgrades[key]
			"attack_damage":
				new_stats.attack_damage += upgrades[key]
			"dash_cooldown":
				new_stats.dash_cooldown = max(0.1, new_stats.dash_cooldown - upgrades[key])
	return new_stats
