extends Area2D

@export var velocity= Vector2(10.0, 10.0)
@export var damage = 1


# Represents the thing that hurts it (either "enemy_hurter" or "player_hurter")
var opposite_hurter = "enemy_hurter"

@export var player_bullet_color: Color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity * delta
	
	# TODO: delete if bullet gets too far out of the screen (allow some slop space)
	pass


func _on_area_entered(area):
	if(area.is_in_group(opposite_hurter)):
		# Delete bullet if something that hurts it touches it
		queue_free()

func set_is_player_bullet(is_player_bullet = true):
	if is_player_bullet:
		add_to_group("enemy_hurter")
		remove_from_group("player_hurter")
		opposite_hurter = "player_hurter"
		$Sprite.modulate = player_bullet_color
	else:
		add_to_group("player_hurter")
		remove_from_group("enemy_hurter")
		opposite_hurter = "enemy_hurter"


func _on_screen_exited():
	$DespawnTimer.start()
	pass # Replace with function body.


func _on_despawn_timer_timeout():
	# If the despawn timer is triggered, despawn
	queue_free()

func _on_screen_entered():
	# If the bullet comes back on screen, stop the despawn
	$DespawnTimer.stop()
