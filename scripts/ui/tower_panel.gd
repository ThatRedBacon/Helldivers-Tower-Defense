extends Panel

@onready var towerNameLabel = $StatsContainer1/TowerNameLabel
@onready var damageLabel = $StatsContainer1/DamageLabel
@onready var rangeLabel = $StatsContainer1/RangeLabel
@onready var fireRateLabel = $StatsContainer1/FireRateLabel
@onready var sellValueLabel = $StatsContainer2/SellValueLabel

@onready var selectionManager = get_tree().get_first_node_in_group("selectionManager")
@onready var gameManager = get_tree().get_first_node_in_group("gameManager")

@onready var upgradeDamageButton = $ButtonsContainer/UpgradeDamageButton
@onready var upgradeRangeButton = $ButtonsContainer/UpgradeRangeButton
@onready var sellButton = $ButtonsContainer/SellButton

@onready var upgradeDamageText = ""
@onready var upgradeDamageText1 = "Upgrade Damage (+"
@onready var upgradeDamageText2 = ""
@onready var upgradeDamageText3 = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var tower = selectionManager.selectedTower
	
	if tower == null:
		visible = false
		return
	
	visible = true
	
	towerNameLabel.text = "Standard Trooper"
	damageLabel.text = "Damage: " + str(tower.damage)
	rangeLabel.text = "Range: " + str(tower.range)
	fireRateLabel.text = "Fire Rate: " + str(tower.fireRate)
	sellValueLabel.text = "Sell Value: " + str(tower.sellValue)
	
	upgradeDamageText2 = (str(tower.damageUpgradeIncrease * 100) + "%)")
	upgradeDamageText3 = " (-" + str(tower.damageUpgradeCost) + " credits)"
	upgradeDamageText = upgradeDamageText1 + upgradeDamageText2 + upgradeDamageText3
	
	upgradeDamageButton.text = (upgradeDamageText)
	
	var rangePercent = tower.rangeUpgradeIncrease/tower.range
	upgradeRangeButton.text = (
		"Upgrade Range: (+" + (str(int((rangePercent) * 100)) + "%)")
		+ " (-" + (str(tower.rangeUpgradeCost)) + " credits)"
	)
	
	sellButton.text = (
		"Sell Tower: (+" + str(tower.sellValue) + " credits)"
	)
	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_upgrade_damage_button_pressed():
	var tower = selectionManager.selectedTower
	
	if tower == null:
		return
	
	if gameManager.spendCredits(tower.damageUpgradeCost):
		tower.upgradeDamage()
		print("New damage: ", str(tower.damage))


func _on_upgrade_range_button_pressed():
	var tower = selectionManager.selectedTower
	
	if tower == null:
		return
	
	if gameManager.spendCredits(tower.rangeUpgradeCost):
		tower.upgradeRange()


func _on_sell_button_pressed():
	var tower = selectionManager.selectedTower
	
	if tower == null:
		return
	
	tower.sellTower()
	
	selectionManager.clearSelection()
