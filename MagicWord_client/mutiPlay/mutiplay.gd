extends Node2D
signal start_info
signal logOut
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _init_start_game(user):
	$Game.visible = true
	$UserInfo.visible = false
	start_info.emit(user,"",0)


func _on_game_out(user):
	#退出登录
	#1，去userInfo给服务器发信号
	logOut.emit(user)
	#2，game页面隐藏，显示登录页面
	$Game.visible = false
	$UserInfo.visible = true

