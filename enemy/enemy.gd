extends Area2D

signal enemy_killed

var bullet_scene = preload("res://bullet/bullet.tscn")
@export var target: Node2D
@onready var bullet_timer = $BulletTimer

@export var speed : float = 100.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	# Move toward the target
	var direction_to_target = target.global_position - global_position	
	position += direction_to_target.limit_length(speed * delta) # limited by max speed times by current delta
	pass


func _on_bullet_timer_timeout():
	# Spawn a bullet toward the player
	var bullet = bullet_scene.instantiate()
	bullet.position = global_position
	var direction_to_target = target.global_position - global_position
	bullet.velocity = direction_to_target.limit_length(speed * 1.5) # TODO: randomness in speed?
	get_tree().root.add_child(bullet)

func _on_area_entered(area):
	if(area.is_in_group("enemy_hurter")):
		print("enemy hit by player")
		enemy_killed.emit()
		queue_free()
	pass # Replace with function body.
