extends PathFollow2D

@export var damage: int = 1

signal reachedEnd

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if progress_ratio >= 1.0:
		reachedEnd.emit()
		queue_free()
