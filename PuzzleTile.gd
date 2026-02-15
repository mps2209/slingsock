extends Node2D
class_name PuzzleSlot

@onready var label = $Label
@export var is_empty=false
@export var puzzle_tile_name="puzzle_tile"
signal clicked(slot: PuzzleSlot)
@export var neighbours:Array[PuzzleSlot]
# Called when the node enters the scene tree for the first time.
func _ready():
	label.text=name
	if(!is_empty):
		var scene = load("res://scenes/" + puzzle_tile_name + ".tscn")
		var instance = scene.instantiate()
		add_child(instance)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print(name + " Clicked!")
		clicked.emit(self)

