extends Node2D

@export var maxHealth: float = 10.0
@export var creditReward = 10
var currentHealth: float

func getProgress():
	return get_parent().progress_ratio

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
