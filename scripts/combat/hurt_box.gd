class_name HurtBox
extends Area2D
## Receives damage from HitBox areas. Parent node should implement take_damage().

signal health_depleted()

## Team identifier — prevents friendly fire.
@export var team: String = "player"
