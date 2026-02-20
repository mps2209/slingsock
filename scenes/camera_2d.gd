extends Camera2D

# Adjust these to taste
const ZOOM_SMALL_SCREEN := Vector2(1.0, 1.0)  # "Closer" (more zoomed in)
const ZOOM_LARGE_SCREEN := Vector2(.5, .5)  # Default / zoomed out

const MIN_HEIGHT := 800   # below this, treat as small screen
const MIN_WIDTH  := 1280  # below this, treat as small screen
const MIN_ASPECT := 1.6   # below this, treat as "tall" (phone-ish)

func _ready() -> void:
	_adjust_zoom()
	get_viewport().size_changed.connect(_on_viewport_size_changed)

func _adjust_zoom() -> void:
	var size: Vector2i = DisplayServer.window_get_size()
	var width: float = float(size.x)
	var height: float = float(size.y)
	var aspect: float = width / height

	var is_small_screen := (
		height < MIN_HEIGHT
		or width < MIN_WIDTH
		or aspect < MIN_ASPECT
	)

	if is_small_screen:
		zoom = ZOOM_SMALL_SCREEN
	else:
		zoom = ZOOM_LARGE_SCREEN

func _on_viewport_size_changed() -> void:
	_adjust_zoom()
