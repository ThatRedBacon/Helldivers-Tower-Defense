class_name TowerDatabase

const TowerBaseTypes = preload("res://scripts/constants/tower_base_types.gd")

static func getTowerBaseData(
	baseType : TowerBaseTypes.TowerBaseType
) -> TowerBaseData:
	var towerBase = TowerBaseData.new()
	match baseType:
		TowerBaseTypes.TowerBaseType.SEAF_TROOPER:
			towerBase.baseName = "SEAF Trooper"
			towerBase.baseCost = 75
			towerBase.fireRateMultiplier = 1.0
		TowerBaseTypes.TowerBaseType.HELLDIVER:
			towerBase.baseName = "Helldiver"
			towerBase.baseCost = 125
			towerBase.fireRateMultiplier = 1.25
		TowerBaseTypes.TowerBaseType.SENTRY:
			towerBase.baseName = "Sentry"
			towerBase.baseCost = 200
			towerBase.fireRateMultiplier = 1.25
		TowerBaseTypes.TowerBaseType.EMPLACEMENT:
			towerBase.baseName = "Emplacement"
			towerBase.baseCost = 225
			towerBase.fireRateMultiplier = 1.0
			
		
	return towerBase
