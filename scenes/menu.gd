extends Node2D
class_name Menu
@onready var resume: Button = $"Menu Manager/Resume"
@onready var quit: Button = $"Menu Manager/Quit"
var showMenu=true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	toggleMenu()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("menu"):
		toggleMenu()
func _on_resume_pressed() -> void:
	toggleMenu()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
func toggleMenu():
	if showMenu:
		get_tree().paused = false
		resume.hide()
		quit.hide()
	else:
		get_tree().paused = true
		resume.show()
		quit.show()
	showMenu=!showMenu


func _on_texture_button_pressed() -> void:
	toggleMenu()
