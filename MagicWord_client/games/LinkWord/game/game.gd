extends Node2D
#—————————————————————————————以下是静态参数不用设置，也不用初始化————————————————
var old_color = "blue"
var new_color = "orange"	
var max_time = 60	#限制时间
signal out	#退出信号
signal win	#胜利信号
signal next	#下一关的信号
var gameName = "LinkWord"
#—————————————————————————————第一次要初始化的列表——————————————————————————————
var pressed = []
var sure = []
#文件传入数据
var data_string = ""
var matches_data = []
var poems_name = []
#————————控制进度文件和数据文件
#是游戏的第几关
var gameOfPosition = -1
#游戏一共有多少关
var countOfGame = -1
#—————————————————————————————以下是每一次重新进入游戏都要初始化的参数—————————————
#现在时间为
var now_time = max_time
#用户是否开始游戏，是否开始计时
var isStarted = false
#代表现在已经选择的按钮索引
var now_idx = []
#代表现在已经选择的按钮文本整合
var now_text = []
#表示是否按下
var isPressed = false
#现在已经答对了几句诗句
var now_n = 0


func _ready():
	#————————————————————初始化参数
	now_n = 0
	pressed.clear()
	sure.clear()
	for i in range(64):
		if(data_string.length() > 0):
			#即初始化之后再设置
			get_node("Words/"+str(i)).text = data_string[i]
		#初始化，设置所有的pressed都是按下的状态
		pressed.append(false)
		#设置所有已经确认的按钮，不能被改变状态，即已经成功匹配的
		sure.append(false)
		#设置所有按钮的颜色为没有按下的颜色
		_load_color(i,old_color)
	$tip_lose.visible = false
	$tip_win.visible = false
	$tip_poems.visible = false
	#初始化时间
	_init_time()
func _on_tips_pressed():
	$tip_prompt.visible = true
	$tip_prompt/back.text = matches_data[0]

func _on_back_pressed():
	out.emit()


func _on_cancel_pressed():
	$tip_prompt.visible = false

func _pressed(idx,text):
	#确认是否按下
	if(!isPressed):
		return
	#判断是否是已经确定的按钮
	if(sure[idx]):
		return
	#判断是否是之前按的按照上下左右扩展得到的
	var pre
	if(now_idx.size() > 0):
		pre = now_idx.back()
		if(idx not in [pre-8,pre+8,pre-1,pre+1]):
			return
	#判断是否被按下
	if(pressed[idx]):
		#取消点击的最后一个字符
		if(now_idx.size()>1 && now_idx[now_idx.size()-2] == idx):
			#取消点击
			pressed[idx] = false
			now_idx.pop_back()
			now_text.pop_back()
			_load_color(pre,old_color)
	else:
		#确认未被点击则加入
		now_idx.push_back(idx)
		now_text.push_back(text)
		_load_color(idx,new_color)
		pressed[idx] = !pressed[idx]

func _on_pressed_start(event):
	if(event is InputEventScreenTouch && event.pressed):
		if(!isStarted):
			#说明开始点击
			isStarted = true
			$Timer.start()	
		isPressed = true
		$tip_poems.visible = false
	if(event is InputEventScreenTouch && !event.pressed):
		isPressed = false
		#离开屏幕的时候,将now_text中的文字匹配，查看是否能成功
		var poems = ""
		for s in now_text:
			poems += str(s)
		if(poems in matches_data):
			#正确输入，则将所有的已经按下的按钮做确认处理
			for i in now_idx:
				sure[i] = true
			#调用显示框
			$tip_poems.visible = true
			$tip_poems/l1.text = poems
			$tip_poems/l2.text = "————" + poems_name[matches_data.find(poems)]
			#并将打对的次数加1
			now_n += 1
			if(now_n>=matches_data.size()):
				$Timer.stop()
				$tip_win.visible = true
				win.emit(gameOfPosition)
		#清理
		_reset()
	
func _reset():
	for i in range(64):
		pressed[i] = false
		if(!sure[i]):
			_load_color(i,old_color)
	now_idx.clear()
	now_text.clear()

func _load_color(i,color):
	get_node("Words/"+str(i)).add_theme_stylebox_override("normal", load("res://asset/styles/"+color+".tres"))


func _on_try_again_pressed():
	#重新加载当前场景，但是清除所有数据，而不是重新加载
	_ready()


func _on_next_pressed():
	$tip_win.visible = false
	#先判断是不是最后一关了
	if(gameOfPosition >= countOfGame):
		$tip_prompt/back.text = "已经是最后一关了"
		$tip_prompt.visible = true
		return
	next.emit(gameOfPosition+1)
func _on_timer_timeout():
	now_time -= 1
	$time.text = str(now_time)
	if(now_time <= 0):
		$Timer.stop()
		$tip_lose.visible = true

func _init_time():
	isStarted = false
	now_time = max_time
	$time.text = str(now_time)
	$Timer.stop()
#处理传进来的信号对应的方法
func _init_info(idx,game_info,count):
	gameOfPosition = idx
	data_string = game_info["data_string"]
	matches_data = game_info["matches_data"]
	poems_name = game_info["poems_name"]
	countOfGame = count
	_ready()
	
