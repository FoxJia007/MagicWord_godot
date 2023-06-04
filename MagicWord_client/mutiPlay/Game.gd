extends Node2D
signal out
var selfPlayer = {
	"userId":0,
	"userName":"",
	"userAccount":"",
	"score":0}
var enemyPlayer = {
	"userName":"",
	"userAccount":"",
	"score":0}
var this_gameUID = ""
var this_gameQues = ""
var this_gameAnswer = ""
var round_game_maxTime = 10
#var ip = "192.168.124.1"
#var ip = "121.36.29.151"
var ip = "169.254.254.233"
var port = 8080
#这个信号用来回到
signal Restart
#表示游戏有十秒间隔
var guessWordGame_interval = 10
# Called when the node enters the scene tree for the first time.
func _ready():
	#初始化客户端
	_init_client()
	
func _on_start_match():
	#将开始匹配隐藏
	$startMatch.visible = false
	#停止匹配页面隐藏
	$stopMatch.visible = true
	self.rpc("_match",selfPlayer)
	#开始计时
	$matchTimer.start()
	$matchTime.text = "0"
	$matchTime.visible = true
func _on_stop_match():
	#将开始匹配展示
	$startMatch.visible = true
	#停止匹配页面隐藏
	$stopMatch.visible = false
	#将timer重置
	$matchTimer.stop()
	$matchTime.visible = false
	self.rpc("_stop_match",selfPlayer)
	
#表示游戏时间截至
func _on_time_control_timeout():
	var t = $GamePanel/timePanel.text
	var update_t = int($GamePanel/timePanel.text) - 1
	$GamePanel/timePanel.text = str(update_t)
	if(update_t <= 0):
		$GamePanel/timeControl.stop()
#表示匹配成功，将数据传回
@rpc
func _match_victory(gameUID,player1,player2):
	if(selfPlayer["userAccount"] in [player1.get("userAccount"),player2.get("userAccount")]):
		#确认是自己匹配成功，初始化本局游戏uid
		this_gameUID = gameUID
		#初始化敌人信息
		enemyPlayer = player2 if(player1.get("userAccount")==selfPlayer["userAccount"]) else player1
		#匹配成功将开始匹配的标识隐藏，将游戏界面打开
		_init_screen()
		$startMatch.visible = false
		$GamePanel.visible = true
		#将两个人的血条初始化
		$GamePanel/Life1.value = 100
		$GamePanel/Life2.value = 100
@rpc
func _loadGuessWordData(gameUID,ques,ans):
	if(this_gameUID == gameUID):
		#获取到问题和答案信息
		this_gameQues = ques
		this_gameAnswer = ans
	_show_guess_screen()
	#开始计时页面
	$GamePanel/timePanel.text = str(round_game_maxTime)
	$GamePanel/timeControl.start()
	$GamePanel/timePanel.visible = true
func _init_info(user,enemyName,enemyScore):
	selfPlayer = user
	enemyPlayer["userName"] = enemyName
	enemyPlayer["score"] = enemyScore
	_init_screen()

func _init_screen():
	#向自己和对手的信息重置
	$selfName.text = selfPlayer["userName"]
	$selfScore.text = str(selfPlayer["score"])
	$enemyName.text = enemyPlayer["userName"]
	$enemyScore.text = str(enemyPlayer["score"])
	
	#将匹配页面打开，将游戏页面隐藏
	$startMatch.visible = true
	$GamePanel.visible = false
	#停止匹配页面隐藏
	$stopMatch.visible = false
	#将计时关闭
	$matchTimer.stop()
	$matchTime.visible = false
func _show_guess_screen():
	$"GamePanel/Q&A/question".text = this_gameQues
	$"GamePanel/Q&A/tips_isRight".visible = false
#验证是否答对
func _on_commit_pressed():
	if(this_gameAnswer.find($"GamePanel/Q&A/answer".text)>0):
		#说明回答成功
		#1.在本地设置UI界面
		print("向右打出攻击，右边血条下降")
		#2.问题计时停止
		$GamePanel/timeControl.stop()
		#3.向服务端发送自己已经获取胜利，再由服务端进行广播通知对手
		self.rpc("_win",this_gameUID,selfPlayer)
	else:
		$"GamePanel/Q&A/tips_isRight".visible = true

func _on_logout_pressed():
	#退出登录
	#1.给userInfo发信号，告知退出用户登录态
	out.emit(selfPlayer)
	
func _on_match_timer_timeout():
	$matchTime.text = str(int($matchTime.text) + 1)
@rpc
func _end_thisGame(gameUID,result):
	print("游戏彻底结束")
	#和服务器断开链接
	#回到匹配界面
	Restart.emit(selfPlayer)
#这里的isLastGame表示是否是
@rpc
func _temp_lose(gameUID,player,isLastGame,isDraw):
	if(gameUID!=this_gameUID):
		return
	#是本局游戏停止计时
	$GamePanel/timeControl.stop()
	if(selfPlayer["userAccount"] == player["userAccount"]):
		_round_tip(isDraw,false)
	else:
		_round_tip(isDraw,true)
	await get_tree().create_timer(1.0).timeout
	if(isLastGame):	#如果是最后一句游戏，那么显示完动画后
		$"GamePanel/Q&A".visible = false
		#根据血量判断是谁赢了还是平手
		if($GamePanel/Life1.value > $GamePanel/Life2.value):
			get_node("tip_ending/Label").text = "恭喜您获得最终胜利，得到积分20"
			selfPlayer.score += 20
		elif($GamePanel/Life1.value < $GamePanel/Life2.value):
			get_node("tip_ending/Label").text = "很稀罕未能战胜对方，失去积分20"
			selfPlayer.score -= 20
		else:
			get_node("tip_ending/Label").text = "平手,积分不变"
		get_node("tip_ending").visible = true
		await get_tree().create_timer(4.0).timeout
		get_node("tip_ending").visible = false
		#向主场景发送信号，初始化
		Restart.emit(selfPlayer)

@rpc
func _isConnecting(account):
	print("被调用到了_isConnecting")
	if(selfPlayer["userAccount"] == account):
		self.rpc("_isConnectingSure",account)


func _round_tip(isDraw,winOrLose):
	$"GamePanel/Q&A".visible = false
	var text = ""
	if(isDraw):
		text = "平手"
	elif(winOrLose):
		$GamePanel/Life2.value -= 20
		text = "回答正确攻击敌方20血"
	else:
		$GamePanel/Life1.value -= 20
		text = "对方答对扣20血"
	$tip_round/info.text = text
	$tip_round.visible = true
	await get_tree().create_timer(1.0).timeout
	$tip_round.visible = false
	$"GamePanel/Q&A".visible = true
	
func _init_client():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip,port)
	self.multiplayer.multiplayer_peer = peer
	selfPlayer.userId = self.multiplayer.get_unique_id()
	print("game","我uid是",selfPlayer.userId)

#开始匹配
@rpc
func _match(selfPlayer):
	pass
#停止匹配
@rpc
func _stop_match(selfPlayer):
	pass


@rpc
func _win(gameUID,player):
	pass

@rpc
func _isConnectingSure(account):
	pass





