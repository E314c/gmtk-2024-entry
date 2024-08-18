extends Area2D

signal player_death

const MAX_SCALE = 5.0
const MIN_SCALE = 1.0
const SCALE_DIFF = MAX_SCALE - MIN_SCALE
const MAX_SPEED = 1000.0
const SCALE_CHANGE_SPEED = 10.0
const BULLET_SPEED = 500.0

@export var SHEILD_ENABLED = true

var bullet_scene = preload("res://bullet/bullet.tscn")

var current_scale = MAX_SCALE # We start at max scale, because it's easier to size the scene that way
var screen_size # Size of the game window

@onready var sprite_2d = $PlayerSprite
var sprite_default_scale: Vector2
@onready var collision_shape_2d = $PlayerHurtbox
var collision_shape_default_scale: Vector2

@onready var shield_hitbox = $Shield/ShieldHitbox


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size # We need to know the screen size for clamping later
	sprite_default_scale = sprite_2d.scale / current_scale # We need the original scaling of the sprite to vary from
	collision_shape_default_scale = collision_shape_2d.scale / current_scale
	
	# TEST: Disable shield if selected
	if(!SHEILD_ENABLED):
		$Shield.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Check for scaling
	var scale_change = Input.get_axis("decrease_size","increase_size")
	current_scale += scale_change * SCALE_CHANGE_SPEED * delta
	current_scale = clamp(current_scale, MIN_SCALE, MAX_SCALE)
	
	# Update the sprite and it's collision shape
	sprite_2d.scale = Vector2(current_scale, current_scale) * sprite_default_scale
	collision_shape_2d.scale = Vector2(current_scale, current_scale) * collision_shape_default_scale

	# Our possible velocity is based on our current scale
	var current_speed = lerp(0.0,MAX_SPEED, (current_scale - MIN_SCALE)/SCALE_DIFF)
	var velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	
	position += velocity * delta * current_speed
	position = position.clamp(Vector2.ZERO, screen_size)
	
	
	# If button
	if(Input.is_action_pressed("shoot")):
		attempt_to_shoot_bullet()

func _on_area_entered(area):
	# TODO: check this didn't happen at the same frame as a sheild collision
	# Could be done be checking if the sheild is rendering larger than the player at this time?
	if(area.is_in_group("player_hurter")):
		print("Player touched by a hurter")
		kill_player()
	pass # Replace with function body.
	
func kill_player():
	player_death.emit() # Notify of player death
	# TODO: better death handling
	sprite_2d.hide()

	
func attempt_to_shoot_bullet():
	# Can't shoot whilst the timer is running
	if($ShootTimer.is_stopped()):
		# Spawn a bullet upwards
		var bullet = bullet_scene.instantiate()
		bullet.set_is_player_bullet(true)
		bullet.position = global_position
		bullet.velocity = Vector2(0, -BULLET_SPEED)
		get_tree().root.add_child(bullet)
		# Prevent shooting for a little while
		$ShootTimer.start()
