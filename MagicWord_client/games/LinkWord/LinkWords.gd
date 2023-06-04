extends Node2D
var linkWord_data_path = "user://linkWord_data.save"
var process_path = "user://process_data.save"
var gameName = "LinkWord"
var guessWord_data_path = "user://guessWord_data.save"
var countOfGame = -1
var processTo = -1

signal game_info
signal out
# Called when the node enters the scene tree for the first time.
func _ready():
	countOfGame = $ChooseLayer/scroll/hbox.get_child_count()
	_init_show()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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
	var info = JSON.parse_string(_getLinkWordData(idx))
	game_info.emit(idx,info,countOfGame)
#代表加载页面
func _init_show():
	processTo = int(_load()[gameName])
	for i in range(1,countOfGame+1):
		get_node("ChooseLayer/scroll/hbox/"+str(i)+"/game").text = str(i)
		if(i<=processTo):
			get_node("ChooseLayer/scroll/hbox/"+str(i)+"/isWin").visible = true
		else:
			get_node("ChooseLayer/scroll/hbox/"+str(i)+"/isWin").visible = false


#获取连词游戏的相关数据
#获取第几个游戏的数据
func _getLinkWordData(idx):
	var file = FileAccess.open(linkWord_data_path, FileAccess.READ)
	file.seek(0)
	var d1 = file.get_line()
	while(idx>1):
		d1 = file.get_line()
		idx-=1
	file.close()
	return d1
func _on_cancel_pressed():
	$tip_prompt.visible = false

func _on_test_pressed():
	#获取数据
	var data = _load()
	#更改数据
	data[gameName] = 4
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

#处理游戏传回信号的方法
#通关信号
func _update_win(gameOfPosition):
	#获取数据
	var data = _load()
	#更改游戏进度
	if(gameOfPosition > data[gameName]):
		data[gameName] = gameOfPosition
	#存储数据
	_save(JSON.stringify(data))
	#更新页面
	_init_show()
#退出信号
func _on_game_out():
	$ChooseLayer.visible = true
	$game.visible = false
	
