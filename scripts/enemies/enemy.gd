extends Node2D

@export var maxHealth: float = 10.0
@export var creditReward = 10
var currentHealth: float

var burnDamage: float = 0.0
var burnDuration: float = 0.0
var burnTickRate: float = 0.5
var burnTickTimer: float = 0.0

func getProgress():
	return get_parent().progress_ratio

# handles burning
func applyBurn(damage, duration, tickRate):
	burnDamage = damage
	burnDuration = duration
	burnTickRate = tickRate
	burnTickTimer = tickRate

func _ready():
	currentHealth = maxHealth

func takeDamage(amount: float):
	currentHealth -= amount
	print("Enemy HP:", currentHealth)
	
	if currentHealth <= 0:
		die()

func die():
	var gameManager = get_tree().get_first_node_in_group("gameManager")
	gameManager.addCredits(creditReward)
	queue_free()

func applySlow(multiplier, duration):
	get_parent().applySlow(multiplier, duration)

func _process(delta):
	
	# if enemy still has time to burn
	if burnDuration > 0:
		
		# decrements burn timing
		burnDuration -= delta
		burnTickTimer -= delta
		
		# if time for next tick of enemy burn damage
		if burnTickTimer <= 0:
			takeDamage(burnDamage)
			burnTickTimer = burnTickRate
			print("DEBUG: enemy is burning")
			print("Enemy health at: ", currentHealth)
