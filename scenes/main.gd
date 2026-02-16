extends Node2D

@onready var camera_2d: Camera2D = $Player/Camera2D
@onready var player: Node2D = $Player
@onready var center: Node2D = $Center

var is_on_center := false
var camera_tween: Tween
var is_on_player=true;
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_SPACE:
		print("space pressed")
		_toggle_camera_target()

func _toggle_camera_target() -> void:
	print("toggle camera")
	if is_on_player:
		player.remove_child(camera_2d)
		center.add_child(camera_2d)
		camera_2d.zoom= Vector2(0.5, 0.5)
		is_on_player=false
	else:
		center.remove_child(camera_2d)
		player.add_child(camera_2d)
		camera_2d.zoom= Vector2(5, 5)
		is_on_player=true
