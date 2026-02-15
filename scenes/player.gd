extends RigidBody2D
class_name Player
var dragging := false
var drag_start: Vector2

@export var base_power: float = 1.0        # overall strength multiplier
@export var max_power: float = 500.0      # hard cap so it doesn't go insane
@onready var sprite_2d = $Sprite2D
@export var max_stretch_scale: float = 1.6  # how long the sock can get visually
@export var min_stretch_scale: float = 0.382  # normal length
var normal_sock= Rect2(9, 3, 19, 28)
var stretched_sock= Rect2(75, 0, 9, 32)
func _ready() -> void:
	input_pickable = true  # detect the initial click on this body

func _input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		dragging = true
		drag_start = event.position

func _unhandled_input(event: InputEvent) -> void:
	if not dragging:
		return
	sprite_2d.region_rect=stretched_sock
	
	# Rotate to face the mouse
	var mouse_pos := get_global_mouse_position()
	var to_mouse: Vector2 = global_position - mouse_pos
	sprite_2d.rotation = to_mouse.angle()   # or sprite_2d.rotation = to_mouse.angle()
		# Compute drag distance for stretch
	var current_pos: Vector2
	if event is InputEventMouseMotion:
		current_pos = event.position
	else:
		current_pos = get_viewport().get_mouse_position()

	var drag_vector: Vector2 = drag_start - current_pos
	var drag_dist: float = drag_vector.length()

	# Map drag distance to stretch scale
	# Adjust divisor (e.g. 200.0) tWo tune how fast it stretches
	var t = clamp(drag_dist / 200.0, 0.0, 1.0)
	var stretch = lerp(min_stretch_scale, max_stretch_scale, t)
	sprite_2d.scale.y = stretch
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and not event.pressed:
		dragging = false
		var drag_end: Vector2 = event.position
		# Length and direction
		var dist: float = drag_vector.length()
		if dist == 0.0:
			return

		var dir: Vector2 = drag_vector / dist

		# ----- CHOOSE ONE CURVE BELOW -----

		# 1) Quadratic growth (good default: mild but noticeably stronger)
		var scaled_len := base_power * dist * dist

		# 2) Exponential (strong very quickly – clamp is important)
		# var scaled_len := base_power * (pow(1.02, dist) - 1.0)

		# 3) Logarithmic (strong early, then flattens for huge drags)
		# var scaled_len := base_power * log(1.0 + dist)

		# Clamp the power
		scaled_len = clamp(scaled_len, 0.0, max_power)

		# Rebuild scaled impulse vector
		var impulse: Vector2 = dir * scaled_len

		# Apply as impulse (mass already affects result in physics)
		sprite_2d.region_rect=normal_sock
		sprite_2d.scale.y = min_stretch_scale
		apply_impulse(impulse)
