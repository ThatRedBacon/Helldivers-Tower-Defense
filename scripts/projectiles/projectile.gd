extends Area2D

@export var speed: float = 850.0
@export var damage: float = 1.0
@export var maxLifeTime: float = 5.0
@export var penetration: int = 2

# only projectiles with explosionRadius > 0.0 actually explode
@export var explosionRadius: float = 0.0
@export var explosionDamageMultiplier: float = 1.0

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
	
	# deals damage to the enemy it hits
	if body.has_method("takeDamage"):
		body.takeDamage(damage)
		hitEnemies.append(body)
		
		# if projectile is explosive, then explode
		if explosionRadius > 0:
			explode()
			
		enemiesHit += 1
	
	if enemiesHit >= penetration:
			queue_free()
