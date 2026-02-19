extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("text1")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	loadLevel()
func loadLevel():
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name=="text1":
		animation_player.play("text2")
	elif anim_name=="text2":
		animation_player.play("text3")
	elif anim_name=="text3":
		animation_player.play("text4")
	elif anim_name=="text4":
		loadLevel()
