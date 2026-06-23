extends Node

@export var startingCredits = 100

var credits = 0

# adds credits gained from gameplay
func addCredits(amount):
	credits += amount
	print("Credits: ", credits)
	
# removes credits when players spends it
func spendCredits(amount):
	
	# if player has not enough credits for purchase
	if credits < amount:
		print("NOT ENOUGH CREDITS!")
		return false
	
	# else, player does have enough credits, and conducts purchase
	credits -= amount
	print("Credits: ", credits)
	return true

# Called when the node enters the scene tree for the first time.
func _ready():
	credits = startingCredits


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
