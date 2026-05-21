extends Node

var selectedTower = null

# sets towers to be active or inactive, as needed
func selectTower(tower):
	if selectedTower == tower:
		return
	
	if selectedTower:
		selectedTower.deselect()
	
	selectedTower = tower
	
	if selectedTower:
		selectedTower.select()
	
# deselects the current tower
func clearSelection():
	if selectedTower:
		selectedTower.deselect()

	selectedTower = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
