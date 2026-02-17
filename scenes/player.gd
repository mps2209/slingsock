extends RigidBody2D
class_name Player

var dragging := false
var drag_start: Vector2
var pending_impulse: Vector2 = Vector2.ZERO

@export var base_power: float = 1.0
@export var max_power: float = 500.0
@export var max_stretch_scale: float = 1.6
@export var min_stretch_scale: float = 0.382
@export var flying_velocity_threshold: float = 50.0
@export var stopped_velocity_threshold: float = 5.0  # When player is considered "stopped"

@onready var stretched_sock: Sprite2D = $"Stretched Sock"
@onready var normal_sock: Sprite2D = $"Normal Sock"

var flyingSockArea = Rect2(107, 0, 9, 25)
var normalSockArea = Rect2(9, 3, 19, 28)
var is_flying := false
var is_moving := false
var is_dead := false
signal died
var spawn: Vector2 = Vector2.ZERO

func _ready() -> void:
	spawn = global_position
	input_pickable = true

func _physics_process(delta: float) -> void:
	update_movement_state()
	
	if not is_moving:
		update_sock_sprite()

	# Apply impulse collected from input, then clear
	if pending_impulse != Vector2.ZERO:
		apply_impulse(pending_impulse)
		pending_impulse = Vector2.ZERO
		is_moving = true

func update_movement_state() -> void:
	var speed = linear_velocity.length()
	is_moving = speed > stopped_velocity_threshold

func update_sock_sprite() -> void:
	var speed = linear_velocity.length()
	if speed > flying_velocity_threshold and not is_flying:
		is_flying = true
		normal_sock.region_rect = flyingSockArea
	elif speed <= flying_velocity_threshold and is_flying:
		is_flying = false
		normal_sock.region_rect = normalSockArea

func _input_event(viewport, event, shape_idx) -> void:
	# Only allow input when player is stopped
	if is_moving:
		return
		
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		dragging = true
		drag_start = get_global_mouse_position()

func _unhandled_input(event: InputEvent) -> void:
	if is_dead:
		return
	if not dragging:
		return

	normal_sock.visible = false
	stretched_sock.visible = true

	var mouse_pos: Vector2 = get_global_mouse_position()
	var dir: Vector2 = mouse_pos - global_position
	var target_global_angle: float = dir.angle()
	var BOTTOM_OFFSET := -PI/2
	stretched_sock.rotation = (target_global_angle + BOTTOM_OFFSET) - global_rotation

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
			reset_stretched_sock()
			return

		var dragdir: Vector2 = drag_vector / dist
		var scaled_len := base_power * dist
		scaled_len = clamp(scaled_len, 0.0, max_power)
		pending_impulse = dragdir * scaled_len

		reset_stretched_sock()

func reset_stretched_sock() -> void:
	stretched_sock.scale.y = min_stretch_scale
	stretched_sock.visible = false
	normal_sock.visible = true

func die() -> void:
	print("you died")
	if !is_dead:
		died.emit()
	is_dead=true
	




func _on_you_died_you_died_played() -> void:
	is_dead = false
	is_moving = false  # Also reset movement state	position=spawn
	linear_velocity = Vector2.ZERO  # Explicitly reset velocities during respawn
	angular_velocity = 0.0
	position=spawn
