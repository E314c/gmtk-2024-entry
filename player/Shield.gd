extends Area2D

@onready var sprite = $ShieldSprite
var initial_spirte_scale: Vector2
@onready var hitbox = $ShieldHitbox
var initial_hitbox_scale: Vector2

const MAX_SHIELD_HEALTH = 5.0
var sheild_health = MAX_SHIELD_HEALTH


# Called when the node enters the scene tree for the first time.
func _ready():
	# Get initial scales of hitbox and sprite
	initial_spirte_scale = sprite.scale
	initial_hitbox_scale = hitbox.scale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	print("An Area entered the shield!")
	# Check if it's a bullet:
	if(area.is_in_group("player_hurter")):
		# Take the bullet damage
		if "damage" in area:
			take_damage(area.damage)
		else:
			print("Area didn't specify it's damage, so defaulting to 1")
			take_damage(1)

	pass # Replace with function body.


func take_damage(damage: float):
	# decrement shield health
	sheild_health -= damage;
	sheild_health = clamp(sheild_health, 0, MAX_SHIELD_HEALTH, )
	
	print("Shield health is ", sheild_health)
	
	# Scale the sheild appropriately
	var sheild_scale = sheild_health / MAX_SHIELD_HEALTH
	sprite.scale = sheild_scale * initial_spirte_scale
	hitbox.scale = sheild_scale * initial_hitbox_scale
