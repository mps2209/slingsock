extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Cutscenes/intro.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_check_button_toggled(toggled_on: bool) -> void:
	GameManager.enableCheckpoints=toggled_on


func _on_lvl_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Cutscenes/intro.tscn")


func _on_lvl_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Cutscenes/intro2.tscn")


func _on_lvl_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Cutscenes/intro_3.tscn")
