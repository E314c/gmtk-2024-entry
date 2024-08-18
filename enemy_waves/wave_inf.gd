extends Node2D

signal wave_finished # This won't ever be called

var enemy_scene = preload("res://enemy/enemy.tscn")

const MAX_SPAWN_TIME = 2.5
const MIN_SPAWN_TIME = 0.2

func start():
	print("Wave Inf started!")
	$EnemySpawnTimer.start()

func stop():
	print("wave Inf stopped!")
	$EnemySpawnTimer.stop()
	queue_free()

func spawn_enemy(scene: PackedScene, spawn_position: Vector2):
	var new_enemy = scene.instantiate()
	
	# TODO: handle start positions?
	new_enemy.position = spawn_position
	# Set them to target the player
	new_enemy.target = %Player
	
	# Add the enemy as a child under the main collection node
	$EnemyCollectionNode.add_child(new_enemy)


func _on_enemy_spawn_timer_timeout():
	var screen_limit = get_viewport_rect().size
	var start_position = Vector2(randf_range(0.0, screen_limit.x), 0.0)
	spawn_enemy(enemy_scene, start_position)
	
	# Setup next timer
	$EnemySpawnTimer.wait_time = randf_range(MIN_SPAWN_TIME, MAX_SPAWN_TIME)
	$EnemySpawnTimer.start()
	pass # Replace with function body.
