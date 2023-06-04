extends ScrollContainer
var isDrag = false
var startPos = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		isDrag = true
		startPos = event.position.x
	if event is InputEventMouseButton and !event.is_pressed():
		isDrag = false
		startPos = 0
	if isDrag:
		var offset = event.position.x - startPos
		var hScroll =self.get_h_scroll_bar();
		hScroll.set_offsets_preset(-offset);
		startPos = event.position.y


func _on_game_1_pressed():
	pass # Replace with function body.
