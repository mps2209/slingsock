extends Area2D
@export var activeColor:Color
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var active=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !GameManager.enableCheckpoints:
		visible=false
	animation_player.play("idle") # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Player and GameManager.enableCheckpoints:
		GameManager.spawn=position
		modulate=activeColor
		active=true
		animation_player.stop()
		pass # Replace with function body.
