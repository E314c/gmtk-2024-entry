extends Node2D

signal wave_finished

var enemy_scene = preload("res://enemy/enemy.tscn")
var simple_shooter = preload("res://enemy/enemy_simple_shooter.tscn")

var next_round_func: Callable = create_round_1

func start():
	print("Wave 1 started!")
	#create_round_1()
	create_round_5()
	
func stop():
	print("Wave 1 stopped!")
	$RoundTimer.stop()
	queue_free()

func spawn_enemy(scene: PackedScene, spawn_position: Vector2, args: Dictionary):
	var new_enemy = scene.instantiate()
	
	new_enemy.position = spawn_position
	
	# Set the enemy specific arugments
	for key in args:
		new_enemy[key] = args[key]
	
	# Add the enemy as a child under the main collection node
	$EnemyCollectionNode.add_child(new_enemy)

# Left Side Homing
func create_round_1():
	var screen_limit = get_viewport_rect().size
	spawn_enemy(enemy_scene, Vector2(0, 0), { "target": %Player })
	spawn_enemy(enemy_scene, Vector2(0, screen_limit.y * 1 / 4), { "target": %Player })
	spawn_enemy(enemy_scene, Vector2(0, screen_limit.y * 2 / 4), { "target": %Player })
	spawn_enemy(enemy_scene, Vector2(0, screen_limit.y * 3 / 4), { "target": %Player })
	
	# Setup timer until next round
	$RoundTimer.wait_time = 3.0 # 3 seconds before next wave
	$RoundTimer.start()
	next_round_func = create_round_2
	pass

# Right side homing
func create_round_2():
	var screen_limit = get_viewport_rect().size
	spawn_enemy(enemy_scene, Vector2(screen_limit.x, 0), { "target": %Player })
	spawn_enemy(enemy_scene, Vector2(screen_limit.x, screen_limit.y * 1 / 4), { "target": %Player })
	spawn_enemy(enemy_scene, Vector2(screen_limit.x, screen_limit.y * 2 / 4), { "target": %Player })
	spawn_enemy(enemy_scene, Vector2(screen_limit.x, screen_limit.y * 3 / 4), { "target": %Player })
	
	# Setup timer until next round
	$RoundTimer.wait_time = 3.0 # 3 seconds before next wave
	$RoundTimer.start()
	next_round_func = create_round_3
	pass

# Top row homing
func create_round_3():
	var screen_limit = get_viewport_rect().size
	spawn_enemy(enemy_scene, Vector2(0, 0), { "target": %Player })
	spawn_enemy(enemy_scene, Vector2(screen_limit.x * 1/5, 0), { "target": %Player })
	spawn_enemy(enemy_scene, Vector2(screen_limit.x * 2/5, 0), { "target": %Player })
	spawn_enemy(enemy_scene, Vector2(screen_limit.x * 3/5, 0), { "target": %Player })
	spawn_enemy(enemy_scene, Vector2(screen_limit.x * 4/5, 0), { "target": %Player })
	spawn_enemy(enemy_scene, Vector2(screen_limit.x, 0), { "target": %Player })
	
	# Setup timer until next round
	$RoundTimer.wait_time = 3.0 # 3 seconds before next wave
	$RoundTimer.start()
	next_round_func = create_round_4
	pass

# Side crawling Simples
func create_round_4():
	var screen_limit = get_viewport_rect().size
	
	var simple_shooter_offset = 8
	# Left Side
	spawn_enemy(simple_shooter, Vector2(0 + simple_shooter_offset, 0), {"shoot_direction": Vector2(1,0), "health": 5 })
	spawn_enemy(simple_shooter, Vector2(0 + simple_shooter_offset, -200), {"shoot_direction": Vector2(1,1), "health": 5 })
	spawn_enemy(simple_shooter, Vector2(0 + simple_shooter_offset, -400), {"shoot_direction": Vector2(1,0), "health": 5 })

	# Right Side
	spawn_enemy(
		simple_shooter, 
		Vector2(screen_limit.x - simple_shooter_offset, 0),
		{ "shoot_direction": Vector2(-1,0), "health": 5 }
	)
	spawn_enemy(
		simple_shooter,
		Vector2(screen_limit.x - simple_shooter_offset, -200), 
		{"shoot_direction": Vector2(-1,1), "health": 5 }
	)
	spawn_enemy(
		simple_shooter,
		Vector2(screen_limit.x - simple_shooter_offset, -400),
		{"shoot_direction": Vector2(-1,0), "health": 5 }
	)
	
	# Setup timer until next round
	$RoundTimer.wait_time = 5.0 # 3 seconds before next wave
	$RoundTimer.start()
	next_round_func = create_round_5
	pass


# Diagonal simples
func create_round_5():
	var screen_limit = get_viewport_rect().size
	
	var simple_shooter_offset = 8
	# Left Side
	spawn_enemy(
		simple_shooter, 
		Vector2(0 + simple_shooter_offset, 0),
		{"shoot_direction": Vector2(1,0), "health": 5, "movement_direction": Vector2(1,1) }
	)
	spawn_enemy(
		simple_shooter, 
		Vector2(-100, -100),
		{"shoot_direction": Vector2(1,0), "health": 5, "movement_direction": Vector2(1,1) }
	)
	spawn_enemy(
		simple_shooter, 
		Vector2(-200, -200),
		{"shoot_direction": Vector2(1,0), "health": 5, "movement_direction": Vector2(1,1) }
	)
	
	# Right Side
	spawn_enemy(
		simple_shooter, 
		Vector2(screen_limit.x, 0),
		{ "shoot_direction": Vector2(-1,0), "health": 5, "movement_direction": Vector2(-1,1) }
	)
	spawn_enemy(
		simple_shooter, 
		Vector2(screen_limit.x +100 , -100),
		{ "shoot_direction": Vector2(-1,0), "health": 5, "movement_direction": Vector2(-1,1) }
	)
	spawn_enemy(
		simple_shooter, 
		Vector2(screen_limit.x +200 , -200),
		{ "shoot_direction": Vector2(-1,0), "health": 5, "movement_direction": Vector2(-1,1) }
	)
	
	# Setup timer until next round
	$RoundTimer.wait_time = 5.0 # TODO: next round only when all mobs gone?
	$RoundTimer.start()
	next_round_func = end_wave
	pass

func end_wave():
	wave_finished.emit();


func _on_round_timer_timeout():
	next_round_func.call()
