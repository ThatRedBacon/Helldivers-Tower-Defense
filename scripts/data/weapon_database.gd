class_name WeaponDatabase

const WeaponTypes = preload("res://scripts/constants/weapon_types.gd")

static func getWeaponData(
	weaponType : WeaponTypes.WeaponType
	) -> WeaponData:
		var weapon = WeaponData.new()
		
		match weaponType:
			WeaponTypes.WeaponType.PEACEMAKER:
				weapon.weaponName = "Peacemaker"
				weapon.weaponCost = 25
				
				weapon.damage = 5
				weapon.range = 150
				
				weapon.fireRate = 11.25
			
			WeaponTypes.WeaponType.LIBERATOR:
				weapon.weaponName = "Liberator"
				weapon.weaponCost = 300
				
				weapon.damage = 15
				weapon.range = 400
				
				weapon.fireRate = 8.0
				
			WeaponTypes.WeaponType.DEFENDER:
				weapon.weaponName = "Defender"
				weapon.weaponCost = 360
				weapon.damage = 20
				weapon.range = 280
				weapon.fireRate = 6.5
			
			WeaponTypes.WeaponType.PUNISHER:
				weapon.weaponName = "Punisher"
				weapon.weaponCost = 400
				weapon.damage = 600
				weapon.range = 70
				weapon.fireRate = 1
			
			WeaponTypes.WeaponType.BREAKER:
				weapon.weaponName = "Breaker"
				weapon.weaponCost = 780
				weapon.damage = 500
				weapon.range = 45
				weapon.fireRate = 3.75
			
			

		return weapon
