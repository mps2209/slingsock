extends Node2D
class_name YouDiedAnim

@onready var animation_player: AnimationPlayer = $AnimationPlayer
signal you_died_played
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func playYouDied():
	print("play you died anim")
	visible=true
	animation_player.play("you_died")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name=="you_died":
		visible=false
		you_died_played.emit()


func on_player_died() -> void:
	print("on player died triggers")
	playYouDied()
