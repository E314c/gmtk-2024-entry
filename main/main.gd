extends Node

var enemy_scene = preload("res://enemy/enemy.tscn")
const ENEMY_KILL_SCORE = 100;

var score = 0

var wave_index = 0;
@onready var wave_order = [
	$Wave1,
	$Wave_inf
]

func start_game():
	$Timers/ScoreTimer.start()
	$Timers/WaveStartTimer.start()

func stop_game():
	# Stop the game
	$Timers/ScoreTimer.stop()
	$Timers/WaveStartTimer.stop()
	
	# Stop the current wave:
	wave_order[wave_index].stop()

func _on_player_player_death():
	print("Player died!")
	
	
	
	# prepare the restart
	$Timers/ScreenClearTimer.start()
	$Timers/RespawnTimer.start()

func _on_respawn_timer_timeout():
	get_tree().reload_current_scene()
	pass # Replace with function body.

# TODO: this currently isn't called in the "Wave spawning" methodology. Figure it out
func _on_enemy_killed():
	update_score(score + 100)

func _on_score_timer_timeout():
	update_score(score + 1)

func update_score(new_score):
	score = new_score
	$UiBar.update_score(score)


func _on_screen_clear_timer_timeout():
	# clear screen of enemies
	print("Clearing screen")
	get_tree().call_group("enemy", "queue_free")
	get_tree().call_group("bullet", "queue_free")


func _on_wave_start_timer_timeout():
	wave_order[wave_index].start()
	wave_index += 1


func _on_wave_1_finished():
	$Timers/WaveStartTimer.wait_time = 2.0
	$Timers/WaveStartTimer.start()



func _on_main_menu_start_button_pressed():
	$MainMenu.hide()
	start_game()
	pass # Replace with function body.


func _on_game_restart_menu_timeout():
	$MainMenu.show()
	pass # Replace with function body.
