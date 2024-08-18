extends Area2D

signal enemy_killed

var bullet_scene = preload("res://bullet/bullet.tscn")
@export var shoot_direction= Vector2(0,1) # Default to shoot downwards
@export var movement_direction = Vector2(0,1) # Default to move downwards
@export var health = 1
@export var speed : float = 100.0
@export var time_between_bullets = 0.4

@onready var bullet_timer = $BulletTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	$BulletTimer.wait_time = time_between_bullets
	pass # Replace with function body.


func _process(delta):
	# Move
	position += movement_direction.limit_length(speed * delta) # limited by max speed times by current delta
	pass


func _on_bullet_timer_timeout():
	# Spawn a bullet
	var bullet = bullet_scene.instantiate()
	bullet.position = global_position
	bullet.velocity = shoot_direction * speed * 1.5
	get_tree().root.add_child(bullet)

func _on_area_entered(area):
	if(health <= 0):
		return # Nothing to process if this enemy is not alive
	if(area.is_in_group("enemy_hurter")):
		print("simple_shooter hit by damager")
		if "damage" in area:
			take_damage(area.damage)
		else:
			print("Area didn't specify it's damage, so defaulting to 1")
			take_damage(1)

func take_damage(damage):
	health -= damage;
	if(health <= 0 ):
		die()
	else:
		$HitSound.play()

func die():
	print("simple_shooter_died")
	remove_from_group("player_hurter") # So it no longer hurts anything
	enemy_killed.emit()
	$BulletTimer.stop()
	$CollisionShape2D.set_deferred("disable", true)
	$Sprite2D.hide()
	
	$DeathSound.play()
	# We "queue free" after the death sound is finished


func _on_death_sound_finished():
	queue_free()
