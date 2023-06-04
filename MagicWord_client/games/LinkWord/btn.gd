extends Node
signal exp

func _on_mouse_entered():
	exp.emit(name.to_int(),self.text)


func _on_pressed():
	exp.emit(name.to_int(),self.text)
