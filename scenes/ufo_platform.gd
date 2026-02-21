extends AnimatableBody2D
class_name Ufo
@export var sprite:Rect2=Rect2(66,0,34,34)
@onready var sprite_2d: Sprite2D = $Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_2d.region_rect=sprite
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
