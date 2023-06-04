extends Node2D
signal out
signal music_change
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_go_back_pressed():
	out.emit()


func _on_music_pressed():
	music_change.emit()

