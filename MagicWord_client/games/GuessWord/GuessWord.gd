extends Node2D
var path_pre = "res://games/WordInWord/"
var path_suf = "/game.tscn"
var process_path = "user://process_data.save"
var gameName = "GuessWord"
var guessWord_data_path = "user://guessWord_data.save"
var countOfGame = -1
var processTo = -1
#游戏数目过多，所有设计数据结构为，GuessName记录的是打到第几关的信息
var nameOfLevel = ["第一关", '第二关', '第三关', '第四关', '第五关', '第六关', '第七关', '第八关', '第九关', '第十关', '第十一关', '第十二关', '第十三关', '第十四关', '第十五关', '第十六关', '第十七关', '第十八关', '第十九关', '第二十关']

#传送game的信息
signal game_info
signal out
func _ready():
	countOfGame = $ChooseLayer/scroll/hbox.get_child_count()
	_init_show()
	#将进度显示

func _on_back_pressed():
	out.emit()


func _open_game(idx):
	if(idx > processTo+1):
		$tip_prompt/back.text = "请先通过前一关卡"
		$tip_prompt.visible = true
		return
	#将选择层隐藏
	$ChooseLayer.visible = false
	$game.visible = true
	var info = _getGuessWordData()
	var ques = JSON.parse_string(info[0])
	var ans = JSON.parse_string(info[1])
	game_info.emit(idx,ques[idx-1],ans[idx-1],countOfGame)
func _out_game():
	#切换
	$ChooseLayer.visible = !$ChooseLayer.visible
	$game.visible = !$game.visible
	
func _init_show():
	processTo = int(_load()[gameName])
	for i in range(1,countOfGame+1):
		get_node("ChooseLayer/scroll/hbox/"+str(i)+"/game").text = str(i)
		if(i<=processTo):
			get_node("ChooseLayer/scroll/hbox/"+str(i)+"/isWin").visible = true
		else:
			get_node("ChooseLayer/scroll/hbox/"+str(i)+"/isWin").visible = false


func _on_test_pressed():
	#获取数据
	var data = _load()
	#更改数据
	data[gameName] = 0
	#存储数据
	_save(JSON.stringify(data))
	#同时更新页面
	_init_show()
func _load():
	#文件存在，这时候传入数据，表示那一关通过了
	var file = FileAccess.open(process_path, FileAccess.READ)
	var data = file.get_as_text()
	file.close
	var process_data = JSON.parse_string(data)
	return process_data

#获取某一游戏所有关卡的通关信息
func _save(data):
	var file = FileAccess.open(process_path, FileAccess.WRITE)
	file.seek(0)
	file.store_line(data)
	file.close
	
func _update_win(gameOfPosition):
	#获取数据
	var data = _load()
	#更改数据
	data[gameName] = gameOfPosition
	#存储数据
	_save(JSON.stringify(data))
	#同时更新页面
	_init_show()

#获取猜词游戏的相关数据
func _getGuessWordData():
	var file = FileAccess.open(guessWord_data_path, FileAccess.READ)
	file.seek(0)
	var d1 = file.get_line()
	var d2 = file.get_line()
	file.close()
	return [d1,d2]

func _on_cancel_pressed():
	$tip_prompt.visible = false
