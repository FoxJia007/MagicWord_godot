extends Node2D
var process_path = "user://process_data.save"
var gameName = "WordInWord"
#表示玩到第几关
var processTo = -1
#表示一共有多少关
var countOfGame = -1
#退出传递的信号
signal out
#传递进入信息
signal info
func _ready():
	#调用load方法，获取关卡通关信息
	processTo = int(_load()[gameName])
	countOfGame = $ChooseLayer/scroll/hbox.get_child_count()
	for i in range(1,countOfGame+1):
		if(i<=processTo):
			get_node("ChooseLayer/scroll/hbox/v"+str(i)+"/isWin").visible = true
		else:
			get_node("ChooseLayer/scroll/hbox/v"+str(i)+"/isWin").visible = false
func _on_back_pressed():
	out.emit()



func _openGame(idx):
	#调整可见
	if(idx > processTo+1):
		$tip_prompt/back.text = "请先完成前一关卡"
		$tip_prompt.visible = true
		return
	$ChooseLayer.visible = false
	get_node("game"+str(idx)).visible = true
	get_node("game"+str(idx))._ready()
func _on_cancel_pressed():
	$tip_prompt.visible = false

#处理游戏传回信号的方法
func _update_win(gameOfPosition):
	#获取数据
	var data = _load()
	#更改游戏进度
	if(gameOfPosition > data[gameName]):
		data[gameName] = gameOfPosition
	#存储数据
	_save(JSON.stringify(data))
	#更新页面
	_ready()
#处理文件信息
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
func _on_game_out(idx):
	$ChooseLayer.visible = true
	for i in range(1,countOfGame+1):
		get_node("game"+str(i)).visible = false
func _on_test_pressed():
	#获取数据
	var data = _load()
	#更改游戏进度
	data[gameName] = 5
	#存储数据
	_save(JSON.stringify(data))
	#更新页面
	_ready()
