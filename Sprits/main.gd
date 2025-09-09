extends Node2D

@export var enemy_scene:PackedScene
@export var spawn_timer:Timer

func start_new_game():
	$RestartTimer.start()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn_timer.wait_time -= 0.02 * delta
	spawn_timer.wait_time = clamp(spawn_timer.wait_time,1,3)


func _on_timer_timeout() -> void:
	$Player.buff(spawn_timer.wait_time)
	var enemy = enemy_scene.instantiate()
	enemy.position = Vector2(367,randf_range(49,117))
	add_child(enemy)
	
	enemy.hit.connect($Hud._on_hit_enemy.bind())


func _on_player_hit() -> void:
	$Hud.game_over()


func _on_restart_timer_timeout() -> void:
	get_tree().reload_current_scene()
