extends RigidBody2D

var dragging := false
var drag_start: Vector2

@export var base_power: float = 1        # overall strength multiplier
@export var max_power: float = 500.0      # hard cap so it doesn't go insane

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

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and not event.pressed:
		dragging = false
		var drag_end: Vector2 = event.position

		# Slingshot vector (pull back -> shoot forward)
		var drag_vector: Vector2 = drag_start - drag_end

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
		apply_impulse(impulse)
