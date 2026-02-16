extends RigidBody2D
class_name Player
var dragging := false
var drag_start: Vector2

@export var base_power: float = 1.0        # overall strength multiplier
@export var max_power: float = 500.0      # hard cap so it doesn't go insane
@export var max_stretch_scale: float = 1.6  # how long the sock can get visually
@export var min_stretch_scale: float = 0.382  # normal length
@onready var stretched_sock: Sprite2D = $"Stretched Sock"
@onready var normal_sock: Sprite2D = $"Normal Sock"
@export var flying_velocity_threshold: float = 50.0  # velocity threshold to switch to flying sprite
var flyingSockArea=Rect2(107,0,9,25)
var normalSockArea=Rect2(9,3,19,28)
var is_flying := false
func _ready() -> void:
	input_pickable = true  # detect the initial click on this body
func _physics_process(delta: float) -> void:
	if not dragging:
		update_sock_sprite()
func update_sock_sprite() -> void:
	var speed = linear_velocity.length()
	
	if speed > flying_velocity_threshold and not is_flying:
		# Switch to flying sock
		is_flying = true
		normal_sock.region_rect = flyingSockArea
	elif speed <= flying_velocity_threshold and is_flying:
		# Switch back to normal sock
		is_flying = false
		normal_sock.region_rect = normalSockArea
func _input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		dragging = true
		drag_start = get_global_mouse_position()
		
func _unhandled_input(event: InputEvent) -> void:
	if not dragging:
		return

	normal_sock.visible = false
	stretched_sock.visible = true

	var mouse_pos: Vector2 = get_global_mouse_position()
	var dir: Vector2 = mouse_pos - global_position
	var target_global_angle: float = dir.angle()
	var BOTTOM_OFFSET := -PI/2
	stretched_sock.rotation = (target_global_angle + BOTTOM_OFFSET) - global_rotation
	# Drag vector in global space
	var drag_vector: Vector2 = drag_start - mouse_pos
	var drag_dist: float = drag_vector.length()

	var t = clamp(drag_dist / 200.0, 0.0, 1.0)
	var stretch = lerp(min_stretch_scale, max_stretch_scale, t)
	stretched_sock.scale.y = stretch

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and not event.pressed:
		dragging = false

		var dist: float = drag_vector.length()
		if dist == 0.0:
			stretched_sock.scale.y = min_stretch_scale
			stretched_sock.visible = false
			normal_sock.visible = true
			return

		var dragdir: Vector2 = drag_vector / dist
		var scaled_len := base_power * dist
		scaled_len = clamp(scaled_len, 0.0, max_power)
		var impulse: Vector2 = dragdir * scaled_len

		stretched_sock.scale.y = min_stretch_scale
		stretched_sock.visible = false
		normal_sock.visible = true
		apply_impulse(impulse)
