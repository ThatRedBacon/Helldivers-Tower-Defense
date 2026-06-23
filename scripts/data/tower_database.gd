class_name TowerDatabase

const TowerBaseTypes = preload("res://scripts/constants/tower_base_types.gd")

static func getTowerBaseData(
	baseType : TowerBaseTypes.TowerBaseType
) -> TowerBaseData:
	var towerBase = TowerBaseData.new()
	match TowerBaseType:
		
