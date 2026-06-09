# handles placing towers

extends Node2D

var selectedTowerScene = null
var isPlacingTower = false
var previewTower = null

@onready var towersNode = $"../Towers"

func beginTowerPlacement(towerScene):
	selectedTowerScene = towerScene
	isPlacingTower = true
	
	previewTower = selectedTowerScene.instantiate()
	add_child(previewTower)

func placeTower(position):
	if not previewTower.canPlace():
		previewTower.queue_free()
		return
	
	# instantiates and places a tower at desired location
	var tower = selectedTowerScene.instantiate()
	tower.global_position = position
	towersNode.add_child(tower)
	
	# removes the preview tower
	previewTower.queue_free()
	previewTower = null
	
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
func _process(delta):
	if previewTower != null:
		previewTower.global_position = get_global_mouse_position()
		
		if previewTower.canPlace():
			previewTower.modulate = Color(0, 0.6, 1, 0.5)
		
		else:
			previewTower.modulate = Color(1, 1, 0, 0.5)
			
