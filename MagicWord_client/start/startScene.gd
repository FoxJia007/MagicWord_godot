extends Node2D

#默认音乐是开启的
var isMusicOpen:bool = true
signal mutiplay

# Called when the node enters the scene tree for the first time.
func _ready():
	$Music.play()


func _on_settings_pressed():
	#跳转到设置页面
	$settings.visible = true

func _on_logout_pressed():
	#退出游戏
	get_tree().quit() # default behavior

	
func _on_open_game(idx):
	$ChooseLayer.visible = false
	match idx:
		1:
			$WordInWord.visible = true
		2:
			$LinkWord.visible = true
		3:
			$GuessWord.visible = true
		4:
			get_tree().change_scene_to_file("res://mutiPlay/mutiplay.tscn")

func _on_out():
	#切换回主页面
	$ChooseLayer.visible = true
	$settings.visible = false
	$WordInWord.visible = false
	$LinkWord.visible = false
	$GuessWord.visible = false
	
func _music_change():
	if(isMusicOpen):
		$Music.stop()
	else:
		$Music.play()
	isMusicOpen = !isMusicOpen
