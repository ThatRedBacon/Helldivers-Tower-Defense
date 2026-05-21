extends Node

# handles the variables relevant to each wave
@export var autoStartWaves = false
@export var timeBetweenWaves = 10.0
@export var baseEnemiesPerWave = 5
@export var enemyIncreasePerWave = 2
@export var baseWaveReward = 25

var currentWave = 0
var waveInProgress = false
var enemiesToSpawn = 0
var enemiesAlive = 0
var spawnTimer = 0.0
var spawnInterval = 1.0
var breakTimer = 0.0

@onready var gameManager = get_tree().get_first_node_in_group("gameManager")
 
var enemyPathScene = preload("res://scenes/enemies/enemy_path.tscn")

# executed at the start of each wave
func startWave():
	
	# increments currentWave, sets flag that wave is in progress
	currentWave += 1
	waveInProgress = true
	
	# number of enemies to spawn in the entire wave
	enemiesToSpawn = (
		baseEnemiesPerWave + (currentWave * enemyIncreasePerWave)
	)
	
	enemiesAlive = enemiesToSpawn
	
	spawnInterval = max(
		0.2,
		1.0 - (currentWave * 0.05)
	)
	
	print("Starting Wave ", currentWave)

# handles enemy spawn count, intervals, density
func handleSpawning(delta):
	if enemiesToSpawn <= 0:
		return
	
	# "spawnTimer" being time until next enemy spawn
	spawnTimer -= delta
	
	# if time for enemy to spawn:
	if spawnTimer <= 0:
		spawnEnemy()
		enemiesToSpawn -= 1
		
		# resets spawnTimer for next enemy spawn
		spawnTimer = spawnInterval

# handles enemy spawns
func spawnEnemy():
	
	# instantiates path so each enemy has unique path progress
	var enemyPath = enemyPathScene.instantiate()
	
	$"../Path2D".add_child(enemyPath)
	
	# instantiates new enemy
	var enemy = enemyPath.get_node("Enemy")
	
	enemy.tree_exited.connect(_on_enemy_killed)

# decrements enemiesAlive upon enemy death
func _on_enemy_killed():
	enemiesAlive -= 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# handles wave completion
func endWave():
	waveInProgress = false
	var reward = baseWaveReward * currentWave
	gameManager.addCredits(reward)
	print("Wave complete! Prepare for the next wave.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	if waveInProgress:
		handleSpawning(delta)
		
		if enemiesAlive <= 0 and enemiesToSpawn <= 0:
			endWave()
		
		else:
			if autoStartWaves:
				breakTimer -= delta
				
				if breakTimer <= 0:
					startWave()
		
		
