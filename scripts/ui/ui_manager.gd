extends CanvasLayer

@onready var creditsLabel = $CreditsColorRect/CreditsContainer/CreditsLabel
@onready var gameManager = get_tree().get_first_node_in_group("gameManager")
@onready var waveManager = get_tree().get_first_node_in_group("waveManager")
@onready var placementManager = $"../PlacementManager"
@onready var startWaveButton = $StartWaveButton
const BasicTowerScene = preload("res://scenes/towers/tower.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	creditsLabel.text = "Credits: " + str(gameManager.credits)
	
	# only shows the "startWaveButton" when there is no active wave
	startWaveButton.visible = not waveManager.waveInProgress

# called when "startWaveButton" is clicked
func _on_start_wave_button_pressed():
	
	# if there is not currently an active wave:
	if not waveManager.waveInProgress:
		waveManager.startWave()


func _on_add_tower_button_pressed():
	placementManager.beginTowerPlacement(BasicTowerScene)
