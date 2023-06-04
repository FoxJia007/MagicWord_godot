extends Node2D
#——————————————————————————————以下是要手动设置的参数————————————————————————————
#表示这个游戏在这类游戏中是第几个
var gameOfPosition = 1
var path = "res://asset/images/wordInword/g1/b/"
var path_pressed = "res://asset/images/wordInword/g1/w/"
#表示这个字的可以被点击的笔画数
var brush_count = 9
#代表一共可以组成多少个字
var max_count = 7
#代表一共有多少关卡
var gameOfCount = 5
#可以组成那些字
var tipsWords = "一二茶小人艹丶"
#—————————————————————————————以下是静态参数不用设置，也不用初始化————————————————
#游戏种类
var gameName = "WordInWord"
#文件要保存的路径
var process_path = "user://process_data.save"
#总共限制时间为
var max_time = 60
#信号列表
signal out	#退出信号
signal win	#胜利信号
signal next	#下一关的信号
#—————————————————————————————以下是第一次初始化即可————————————————————————————
var index = []
var path_normal_png = []
var path_pressed_png = []
var index_pressed = []
#—————————————————————————————以下是每一次重新进入游戏都要初始化的参数—————————————
#哪些按钮被按下
var isPressed = []
#已经找到的字
var already_get = []
#代表现在是第几个字
var now_idx = 1
#代表一共按下了多少个笔画
var downCount = 0
#现在时间为
var now_time = 0
#用户是否开始游戏，是否开始计时
var isStarted = false

#每一次初始化都要做的事情
func _init_ervrytime():
	#初始timer的时间信息
	now_time = max_time
	$time.text = str(now_time)
	$Timer.stop()
	#将所有按钮回复到初始状态
	_init_word_color()
	now_idx = 1
	isStarted = false
	#正确或者错误提示也回到初始状态
	$right.visible = false
	$error.visible = false
	#田字格内的字也回复到初始状态
	for i in range(1,max_count+1):
		get_node("Words/"+str(i)).text = ""
	#已经获得的字也要回复
	already_get.clear()
	#将提示界面都恢复
	$tip_lose.visible = false
	$tip_win.visible = false
	$tip_prompt.visible = false
func _init_once():
	#初始化路径信息和列表按下布尔信息
	if(path_normal_png.size() == 0):
		for i in range(1,brush_count+1):
			path_normal_png.append(path + str(i)+ ".png")
			path_pressed_png.append(path_pressed + str(i)+ ".png")
			isPressed.append(false)
	#将多余的田字格隐藏起来
	for i in range(max_count):
		get_node("Words/"+str(i+1)).visible = true
	#设置页面的提示信息
	$Label.text = "请至少找出"+str(max_count)+"个字"
func _ready():
	_init_once()
	_init_ervrytime()
	
func _on_back_pressed():
	out.emit(gameOfPosition)

func _on_tips_pressed():
	$tip_prompt/back.text = tipsWords
	$tip_prompt.visible = true

func _on_cancel_pressed():
	$tip_prompt.visible = false
#提交去匹配
func _on_commit_pressed():
	var ck = check(isPressed)
	if(ck != null):
		if(ck not in already_get):
			already_get.append(ck)
			#如果匹配成功，则再now_idx上显示
			get_node("Words/"+ str(now_idx)).text = ck
			now_idx+=1
			$right.visible = true
			$error.visible = false
		else:
			$right.visible = false
			$error.text = "该字已经被选择过"
			$error.visible = true
	else:
		$right.visible = false
		$error.text = "选中字不存在"
		$error.visible = true
	if(now_idx>max_count):
		#说明游戏通关了,更新文件状态
		win.emit(gameOfPosition)
		$tip_win.visible = true
		$Timer.stop()
	_init_word_color()
#判断是否可以匹配字
func check(isPressed):
	#首先获取，点击的情况
	var cd = []
	for i in range(brush_count):
		if(isPressed[i]):
			cd.append(i+1)
	match(downCount):
		1:
			if(cd[0] in [1,6]):
				return "一"
			if(cd[0] == 9):
				return "丶"
		2:
			if(cd == [1,6]):
				return "二"
			if(cd == [4,5]):
				return "人"
		3:
			if(cd == [7,8,9]):
				return "小"
			if(cd == [1,2,3]):
				return "艹"
		9:
			if(cd == [1,2,3,4,5,6,7,8,9]):
				return "茶"
	return null
#设置他们的初始颜色
func _init_word_color():
	for i in range(1,brush_count+1):
		get_node("Word/show"+str(i)).texture_normal = load(path_normal_png[i-1])
	for i in range(brush_count):
		isPressed[i] = false
	downCount=0
func _on_btn_pressed(arg):
	print(arg)
	if(!isStarted):
		$Timer.start()
	if(isPressed[arg-1]):
		return
	#改变颜色
	get_node("Word/show" + str(arg)).texture_normal = load(path_pressed_png[arg-1])
	#将变量设置为true
	isPressed[arg-1] = true
	#按下笔画数加1
	downCount+=1
func _on_replace_pressed():
	#重置所有的按钮
	_init_word_color()
	
func _on_next_pressed():
	#判断是否是最后一关
	if(gameOfPosition >= gameOfCount):
		$tip_win.visible = false
		$tip_prompt.visible = true
		$tip_prompt/back.text = "已经是最后一关"
		return
	#使用信号传到列表触发open方法
	next.emit(gameOfPosition+1)
	#不论能否跳转到下一关首先将现在所有元素回复到初始状态
	_init_ervrytime()


func _on_try_again_pressed():
	#不重新加载而是初始化
	$tip_lose.visible = false
	$tip_win.visible = false
	$tip_prompt.visible = false
	_ready()

#时间到之后自动触发事件
func _on_timer_timeout():
	now_time -= 1
	$time.text = str(now_time)
	if(now_time <= 0):
		$Timer.stop()
		$tip_lose.visible = true
#处理文件信息
func _load():
	#文件存在，这时候传入数据，表示那一关通过了
	var file = FileAccess.open(process_path, FileAccess.READ)
	var data = file.get_as_text()
	file.close
	var process_data = JSON.parse_string(data)
	return process_data



