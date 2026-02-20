extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Default zoom	
	# Platform detection
	print(OS.get_name())
	match OS.get_name():
		"Android", "iOS":
			zoom = Vector2(1, 1) # Zoomed out for smaller screens


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
