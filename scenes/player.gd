extends RigidBody2D
class_name Player

var dragging := false
var drag_start: Vector2
var pending_impulse: Vector2 = Vector2.ZERO
var pause_sling_audio := 1.7
@export var base_power: float = 1.0
@export var max_power: float = 500.0
@export var max_stretch_scale: float = 1.6
@export var min_stretch_scale: float = 0.382
@export var flying_velocity_threshold: float = 50.0
@export var stopped_velocity_threshold: float = 5.0
@export var max_drag_distance: float = 200.0
@export var mind_drag_distance:float= 100.0
@export var min_velocity_for_flap:float= 100.0

@onready var stretched_sock: Sprite2D = $"Stretched Sock"
@onready var normal_sock: Sprite2D = $"Normal Sock"
@onready var slingshot: AudioStreamPlayer2D = $Slingshot
@onready var impact: AudioStreamPlayer2D = $Impact
@onready var soft_impact: AudioStreamPlayer2D = $SoftImpact
var is_playing_impact_sound=false

var flyingSockArea = Rect2(107, 0, 9, 25)
var normalSockArea = Rect2(9, 3, 19, 28)

var is_flying := false
var is_moving := false
var is_dead := false
var released := false      # tracks whether user has released during this drag

signal died
var spawn: Vector2 = Vector2.ZERO

func _ready() -> void:
	spawn = global_position
	input_pickable = true

func _physics_process(delta: float) -> void:
	update_movement_state()

	if not is_moving:
		update_sock_sprite()

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
	if is_moving:
		return

	if Input.is_action_just_pressed("drag"):
		dragging = true
		released = false              # new drag: not released yet
		drag_start = get_global_mouse_position()
		start_sling_sound()           # play from 0

func start_sling_sound() -> void:
	# Start the full 2‑part sound from the beginning
	slingshot.stop()
	slingshot.play(0)

	# Wait pause_sling_audio seconds. If the user is STILL holding,
	# it means we don't want the release part to play automatically.
	await get_tree().create_timer(pause_sling_audio).timeout

	if not released:
		# User has not released by 1.7s → stop so we don't hit part 2.
		slingshot.stop()

func _unhandled_input(event: InputEvent) -> void:
	if is_dead or not dragging:
		return

	normal_sock.visible = false
	stretched_sock.visible = true

	var mouse_pos: Vector2 = get_global_mouse_position()
	var dir: Vector2 = mouse_pos - global_position
	var target_global_angle: float = dir.angle()
	var BOTTOM_OFFSET := -PI / 2
	stretched_sock.rotation = (target_global_angle + BOTTOM_OFFSET) - global_rotation

	var drag_vector: Vector2 = drag_start - mouse_pos
	var drag_dist: float = drag_vector.length()
	var t = clamp(drag_dist / max_drag_distance, 0.0, 1.0)
	var stretch = lerp(min_stretch_scale, max_stretch_scale, t)
	stretched_sock.scale.y = stretch

	if Input.is_action_just_released("drag"):
		dragging = false
		released = true          # mark that we DID release during this drag

		var dist: float = drag_vector.length()
		if dist <= mind_drag_distance:
			reset_stretched_sock()
			return

		playSlingSound()         # play only the release part

		var dragdir: Vector2 = drag_vector / dist
		var t_power = clamp(dist / max_drag_distance, 0.0, 1.0)
		var scaled_len = lerp(0.0, max_power, t_power) * base_power
		pending_impulse = dragdir * scaled_len

		reset_stretched_sock()

func playSlingSound() -> void:
	# Jump to the release portion and play it
	slingshot.stop()
	slingshot.seek(0)
	slingshot.play(pause_sling_audio)

func reset_stretched_sock() -> void:
	stretched_sock.scale.y = min_stretch_scale
	stretched_sock.visible = false
	normal_sock.visible = true

func die() -> void:
	print("you died")
	if not is_dead:
		died.emit()
	is_dead = true

func _on_you_died_you_died_played() -> void:
	is_dead = false
	is_moving = false
	position = spawn
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0


func _on_body_entered(body: Node) -> void:
	if !is_playing_impact_sound:
		if linear_velocity.length()>min_velocity_for_flap:
			impact.play(0)
			is_playing_impact_sound=true
		else:
			pass
			#soft_impact.play(0)
			#is_playing_impact_sound=true


func _on_impact_finished() -> void:
	await get_tree().create_timer(.5).timeout
	is_playing_impact_sound=false


func _on_soft_impact_finished() -> void:
	await get_tree().create_timer(1).timeout
	is_playing_impact_sound=false
 # Replace with function body.
