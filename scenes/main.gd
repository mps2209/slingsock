extends Node2D
@onready var camera_2d: Camera2D = $Camera2D

@onready var player: Node2D = $Player
@onready var center: Node2D = $Center
@onready var menu: Menu = $Menu
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var spawn= Vector2(-1359.0,-1181.0)
@onready var remote_transform_2d: RemoteTransform2D = $RemoteTransform2D

var is_on_center := false
var camera_tween: Tween
var is_on_player=true;

func _ready() -> void:
	animation_player.play("intro")

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


func _on_sockcess_animation_done() -> void:
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
func spawn_player():
	var scene = preload("res://scenes/player.tscn")
	var instance = scene.instantiate()
	add_child(instance)
	instance.position=spawn;
	remote_transform_2d.get_parent().remove_child(remote_transform_2d)
	instance.add_child(remote_transform_2d)
	remote_transform_2d.remote_path=NodePath("../../Camera2D")
	remote_transform_2d.position=Vector2.ZERO
	remote_transform_2d.update_position=true
	
