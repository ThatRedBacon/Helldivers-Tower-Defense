extends Area2D

@export var speed: float = 850.0
@export var damage: float = 1.0
@export var maxLifeTime: float = 5.0
@export var penetration: int = 1

var enemiesHit: int = 0
var direction: Vector2 = Vector2.ZERO
var target = null

var lifetime: float = 0.0

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
	if body.has_method("takeDamage"):
		body.takeDamage(damage)
	
	queue_free()
