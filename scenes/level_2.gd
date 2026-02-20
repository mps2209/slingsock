extends Node2D

var player: Player
@onready var center: Node2D = $Center
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var spawn: Node2D = $Spawn
@onready var you_died: YouDiedAnim = $Camera2D/YouDied
@onready var camera_2d: CustomCamera = $Camera2D
@onready var sockcess: Node2D = $Camera2D/Sockcess

func _ready() -> void:
	animation_player.play("intro")

func _on_sockcess_animation_done() -> void:
	get_tree().change_scene_to_file("res://scenes/Cutscenes/intro_3.tscn")
	
func spawn_player():
	var scene = preload("res://scenes/player.tscn")
	var player = scene.instantiate()
	player.level="level2"
	add_child(player)
	player.position=spawn.position
	player.spawn=spawn.position
	camera_2d.follow_target=player
	camera_2d.enable_follow=true
	player.died.connect(you_died.on_player_died)
	you_died.you_died_played.connect(player.on_you_died_you_died_played)
	
