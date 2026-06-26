extends Node
## Global signal bus for decoupled system communication.
## Autoloaded as "EventBus" — access from any script via EventBus.<signal>.

## Emitted when any enemy dies. Passes the enemy node.
signal enemy_killed(enemy: Node2D)

## Emitted when the player dies.
signal player_died()

## Emitted when all enemies in a room are cleared.
signal room_cleared(room_index: int)

## Emitted when the player's health changes.
signal player_health_changed(current_hp: int, max_hp: int)

## Emitted when the player picks up an ability (v0.2+).
signal ability_acquired(ability_name: String)

## Emitted when game state changes (main_menu, playing, paused, game_over).
signal game_state_changed(new_state: String)

## Emitted when score changes.
signal score_changed(new_score: int)
