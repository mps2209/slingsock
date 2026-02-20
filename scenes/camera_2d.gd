extends Camera2D
class_name CustomCamera
# Adjust these to taste
const ZOOM_SMALL_SCREEN := Vector2(1.0, 1.0)  # "Closer" (more zoomed in)
const ZOOM_LARGE_SCREEN := Vector2(.5, .5)  # Default / zoomed out

const MIN_HEIGHT := 800   # below this, treat as small screen
const MIN_WIDTH  := 1280  # below this, treat as small screen
const MIN_ASPECT := 1.6   # below this, treat as "tall" (phone-ish)
## The node the camera follows (assign your player node)
@export var follow_target: Node2D
@export var enable_follow=true
## Maximum pixels the camera can look ahead
@export var max_lookahead_x: float = 120.0
@export var max_lookahead_y: float = 30.0

## How quickly the camera shifts toward the lookahead target
@export var lookahead_speed: float = 4.0

## How quickly the camera returns to center when not dragging
@export var return_speed: float = 3.0

## Scales the drag input so small drags still produce visible lookahead.
## Tune this relative to your typical drag distances.
@export_range(0.1, 3.0) var sensitivity: float = 1.0

# -- internal state --
var _drag_start: Vector2 = Vector2.ZERO
var _is_dragging: bool = false
var _target_offset: Vector2 = Vector2.ZERO
var _current_offset: Vector2 = Vector2.ZERO
var _aspect_scale: Vector2 = Vector2.ONE
# Emitted so your slingshot / aiming system can read the raw drag
# without being coupled to the camera at all.
signal drag_started(screen_pos: Vector2)
signal drag_updated(drag_vector: Vector2)
signal drag_ended(drag_vector: Vector2)

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

func _update_aspect_scale() -> void:
	var vp_size: Vector2 = get_viewport_rect().size
	# Normalize so the LARGER axis = 1.0, smaller axis < 1.0
	if vp_size.x >= vp_size.y:
		# Landscape (your case: 1152x648 → x=1.0, y≈0.5625)
		_aspect_scale = Vector2(1.0, vp_size.y / vp_size.x)
	else:
		# Portrait
		_aspect_scale = Vector2(vp_size.x / vp_size.y, 1.0)	
func _unhandled_input(event: InputEvent) -> void:
	# --- press / release ---
	if Input.is_action_just_pressed("drag"):
			_drag_start = event.position
			_is_dragging = true
			drag_started.emit(event.position)
	# --- motion while held ---
	if Input.is_action_pressed("drag"):
		var drag_vector: Vector2 = event.position - _drag_start
		drag_updated.emit(drag_vector)

		# Look OPPOSITE to the drag (drag back → look forward)
		var look_dir: Vector2 = -drag_vector * sensitivity
		# Account for camera zoom so the world-space offset feels consistent
		look_dir *= zoom
		look_dir.x = clampf(look_dir.x, -max_lookahead_x, max_lookahead_x)
		look_dir.y = clampf(look_dir.y, -max_lookahead_y, max_lookahead_y)
		# Clamp to max distance
		_target_offset = look_dir
	elif Input.is_action_just_released("drag"):
		var final_drag = event.position - _drag_start
		_is_dragging = false
		_target_offset = Vector2.ZERO
		drag_ended.emit(final_drag)

func _process(delta: float) -> void:
	# --- follow the target ---
	if follow_target and enable_follow:
		global_position = follow_target.global_position

	# --- smoothly interpolate the lookahead offset ---
	var speed: float = lookahead_speed if _is_dragging else return_speed
	_current_offset = _current_offset.lerp(_target_offset, 1.0 - exp(-speed * delta))

	# Apply as the built-in Camera2D offset (doesn't touch global_position)
	offset = _current_offset
