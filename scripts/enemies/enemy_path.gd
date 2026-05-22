extends PathFollow2D

@export var baseSpeed = 100.0
var currentSpeed: float
var slowTimer: float = 0.0

# reduces enemy speed when slowed
func applySlow(multiplier, duration):
	currentSpeed = baseSpeed * multiplier
	slowTimer = duration

# Called when the node enters the scene tree for the first time.
func _ready():
	currentSpeed = baseSpeed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress += currentSpeed * delta
	
	# checks if enemy is slowed
	if slowTimer > 0:
		slowTimer -= delta
		
		# after decrementing timer, check if it is expired
		if slowTimer <= 0:
			currentSpeed = baseSpeed
	
	if progress_ratio >= 1.0:
		queue_free()
