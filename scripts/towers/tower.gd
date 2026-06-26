extends Node2D

# "damage" is damage dealt per shot
@export var damage: float
# "fireRate" is rounds fired per second of tower
@export var fireRate: float
# "range" is effective engagement radius around the tower
@export var range: float

# tower base and weapon info
const TowerTypes = preload("res://scripts/constants/tower_base_types.gd")
@export var towerBaseType : TowerTypes.TowerBaseType
var towerBaseData = null

const WeaponTypes = preload("res://scripts/constants/weapon_types.gd")
@export var weaponType : WeaponTypes.WeaponType
var weaponData = null

# commerce/upgrade variables
@export var damageUpgradeIncrease: float = 0.5
@export var damageUpgradeCost: int = 25
@export var rangeUpgradeIncrease: int = 100
@export var rangeUpgradeCost: float = 20

@export var price = 100
@export var sellValue = (price/2)

# Color(r, g, b, a) with parameters between 0-1
@export var radiusColor: Color = Color(0.1, 0.69, 0.69, 0.2)
@export var radiusBorderColor: Color = Color(0.3, 0.3, 1, 0.8)
@export var radiusBorderWidth: float = 3.0

var cooldown: float = 0.0
var target = null
var isSelected = false

@onready var attackArea = $AttackArea
@onready var attackShape = $AttackArea/CollisionShape2D
@onready var clickArea = $ClickArea
@onready var rangeIndicator = $RangeIndicator
@onready var selectionManager = get_tree().get_first_node_in_group("selectionManager")
@onready var gameManager = get_tree().get_first_node_in_group("gameManager")

var projectileScene = preload("res://scenes/projectiles/projectile.tscn")

const TargetingModes = preload("res://scripts/constants/targeting_modes.gd")

@export var targetingMode = TargetingModes.TargetingMode.FIRST

# validates tower placement
@onready var placementArea = $"PlacementArea"
func canPlace():
	
	# prohibits tower placement if player has not enough money
	if gameManager.credits < price:
		return false
	
	# returns value depending on if tower overlaps with others
	return placementArea.get_overlapping_areas().is_empty()
	

# determines the right enemy for the tower to target
func acquireTarget():
	var enemies = attackArea.get_overlapping_bodies()
	
	if enemies.is_empty():
		target = null
		return
	
	# defines the appropriate enemy for each mode
	var firstTarget = enemies[0]
	var lastTarget = enemies[0]
	var strongestTarget = enemies[0]
	
	for enemy in enemies:
		if enemy.getProgress() > firstTarget.getProgress():
			firstTarget = enemy
		
		if enemy.getProgress() < lastTarget.getProgress():
			lastTarget = enemy
		
		if enemy.currentHealth > strongestTarget.currentHealth:
			strongestTarget = enemy
	
	match targetingMode:
		TargetingModes.TargetingMode.FIRST:
			return firstTarget
		
		TargetingModes.TargetingMode.LAST:
			return lastTarget
		
		TargetingModes.TargetingMode.STRONG:
			return strongestTarget
	
# returns the first/furthest enemy along path in tower radius
func getFirstEnemy(enemies):
	var bestEnemy = null
	var bestProgress = -1.0
	
	for enemy in enemies:
		if enemy.currentHealth <= 0:
			continue
		
		var progress = enemy.getProgress()
		
		if progress > bestProgress:
			bestProgress = progress
			bestEnemy = enemy
		
	return bestEnemy

# returns last enemy in tower radius
func getLastEnemy(enemies):
	var bestEnemy = null
	var bestProgress = 999999.0
	
	for enemy in enemies:
		if enemy.currentHealth <= 0:
			continue
		
		var progress = enemy.getProgress()
		if progress < bestProgress:
			bestProgress = progress
			bestEnemy = enemy
		
	return bestEnemy

# returns the closest enemy in tower radius
func getClosestEnemy(enemies):
	var bestEnemy = null
	var bestDistance = INF
	
	for enemy in enemies:
		if enemy.currentHealth <= 0:
			continue
		
		var distance = global_position.distance_to(enemy.global_position)
		
		if distance < bestDistance:
			bestDistance = distance
			bestEnemy = enemy
	
	return bestEnemy

# handles projectile physics
func fireProjectile(targetEnemy):
	var projectile = projectileScene.instantiate()
	
	# spawns projectile into current scene (moves independently)
	get_tree().current_scene.add_child(projectile)
	
	projectile.global_position = global_position
	
	projectile.damage = damage
	
	projectile.direction = (
		targetEnemy.global_position - global_position
	).normalized()

# tower fires projectile shot on its designated target
func shoot():
	if target == null:
		return
	
	print("Firing...")
	fireProjectile(target)

# radius draw function
func _draw():
	if not isSelected:
		return
		
	draw_circle(Vector2.ZERO, range, radiusColor)
	
	draw_arc(
		Vector2.ZERO,
		range,
		0,
		TAU,
		64,
		radiusBorderColor,
		radiusBorderWidth
	)

# syncs displayed and actual attack range
func updateRange():
	var shape = attackShape.shape
	
	if shape is CircleShape2D:
		shape.radius = range
	
	queue_redraw()

# called when user clicks tower. changes tower radius visibility
func selectTower():
	selectionManager.selectTower(self)

# sets self.isSelected to true
func select():
	isSelected	= true
	queue_redraw()

# sets self.isSelected to false
func deselect():
	isSelected = false
	queue_redraw()

# for upgrading tower damage
func upgradeDamage():
	damage += damageUpgradeIncrease
	sellValue += (damageUpgradeCost/2)

# for upgrade tower range
func upgradeRange():
	range += rangeUpgradeIncrease
	sellValue += (rangeUpgradeCost/2)
	
	# adjusts new tower range so that it's displayed correctly
	updateRange()

# for selling tower
func sellTower():
	var gameManager = get_tree().get_first_node_in_group("gameManager")
	
	# adds credits to inventory then deletes tower
	gameManager.addCredits(sellValue)
	queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateRange()
	
	towerBaseData = TowerDatabase.getTowerBaseData(towerBaseType)
	weaponData = WeaponDatabase.getWeaponData(weaponType)
	
	damage = weaponData.damage
	range = weaponData.range 
	fireRate = weaponData.fireRate
	
	print("Tower ready.")
	print("DEBUG: Base: ", towerBaseType)
	print("DEBUG: Weapon: ", weaponType)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cooldown -= delta
	
	target = acquireTarget()
	
	if target and cooldown <= 0:
		shoot()
		cooldown = 1.0 / fireRate

# called when the player clicks on the tower, selecting it
func _on_click_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			selectTower()
			get_viewport().set_input_as_handled()
