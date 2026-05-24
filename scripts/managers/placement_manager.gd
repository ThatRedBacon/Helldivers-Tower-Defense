# handles placing towers

extends Node2D

var selectedTowerScene = null
var isPlacingTower = false

@onready var towersNode = $"../Towers"

func beginTowerPlacement(towerScene):
	selectedTowerScene = towerScene
	isPlacingTower = true

func placeTower(position):
	var tower = selectedTowerScene.instantiate()
	tower.global_position = position
	towersNode.add_child(tower)
	isPlacingTower = false

func _input(event):
	if not isPlacingTower:
		return
	
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				placeTower(
					get_global_mouse_position()
				)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
