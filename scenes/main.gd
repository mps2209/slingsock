extends Node2D

var player: Player
@onready var center: Node2D = $Center
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var remote_transform_2d: RemoteTransform2D = $RemoteTransform2D
@onready var you_died: YouDiedAnim = $Camera2D/YouDied
@onready var camera_2d: Camera2D = $Camera2D

func _ready() -> void:
	animation_player.play("intro")

func _on_sockcess_animation_done() -> void:
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
func spawn_player():
	var scene = preload("res://scenes/player.tscn")
	var instance = scene.instantiate()
	add_child(instance)
	player=instance
	instance.position=remote_transform_2d.position
	player.spawn=remote_transform_2d.position
	player.died.connect(you_died.on_player_died)
	you_died.you_died_played.connect(player.on_you_died_you_died_played)
	remote_transform_2d.get_parent().remove_child(remote_transform_2d)
	instance.add_child(remote_transform_2d)
	remote_transform_2d.remote_path=NodePath("../../Camera2D")
	remote_transform_2d.position=Vector2.ZERO
	remote_transform_2d.update_position=true
