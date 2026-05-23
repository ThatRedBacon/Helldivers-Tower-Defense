extends Area2D

# general projectile stats
@export var speed: float = 850.0
@export var damage: float = 1.0
@export var maxLifeTime: float = 5.0
@export var penetration: int = 2

# projectile armor penetration
const ArmorTypes = preload("res://scripts/constants/armor_types.gd")
@export var armorPenetration = ArmorTypes.ArmorType.MEDIUM

# only projectiles with explosionRadius > 0.0 actually explode
@export var explosionRadius: float = 0.0
@export var explosionDamageMultiplier: float = 1.0

# fire/burning stats
@export var burnDamage: float = 1.0
@export var burnDuration: float = 0.0
@export var burnTickRate: float = 0.5

# slowMultiplier multiplies enemy speed by this value
var slowMultiplier: float = 0.5

# slowDuration is the duration of enemy slow effect
# set slowDuration = 0.0 to disable slowing
var slowDuration: float = 0.0

var enemiesHit: int = 0
var direction: Vector2 = Vector2.ZERO
var target = null

var lifetime: float = 0.0

var hitEnemies = []

# handles explosives
func explode():
	var spaceState = get_world_2d().direct_space_state
	
	var circle = CircleShape2D.new()
	circle.radius = explosionRadius
	
	var query = PhysicsShapeQueryParameters2D.new()
	
	query.shape = circle
	query.transform = Transform2D(0, global_position)
	
	var results = spaceState.intersect_shape(query)
	
	for result in results:
		var collider = result.collider
		if collider == self:
			continue
		
		if collider.has_method("takeDamage"):
			collider.takeDamage(
				damage * explosionDamageMultiplier
			)
			print("DEBUG: EXPLOSION")
			

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position += direction * speed * delta
	lifetime += delta
	if lifetime >= maxLifeTime:
		queue_free()


func _on_body_entered(body):
	
	# if enemy already hit by projectile
	if body in hitEnemies:
		return
	
	# only damages enemy if bullet has appropriate armor penetration
	if armorPenetration < body.armorType:
		print("DEBUG: enemy has higher armor level")
		return
	
	# deals damage to the enemy it hits
	if body.has_method("takeDamage"):
		body.takeDamage(damage)
		
		# if projectile applies slow, then apply it here
		if slowDuration > 0:
			body.applySlow(
				slowMultiplier,
				slowDuration
			)
		
		# if projectile is incendiary, applies it here
		if burnDuration > 0:
			body.applyBurn(
				burnDamage,
				burnDuration,
				burnTickRate
			)
		
		hitEnemies.append(body)
		
		# if projectile is explosive, then explode
		if explosionRadius > 0:
			explode()
			
		enemiesHit += 1
	
	if enemiesHit >= penetration:
			queue_free()
