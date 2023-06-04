extends Node2D
signal updateScore
#网络
var netWork = ENetMultiplayerPeer.new()

var data_guessWord_question = [
	"白龙马走一线天 (打一成语)", 
	"白骨精演讲(打一四字成语) ",
	"白骨精来源(打一成语) ",
	"白费力气(打一成语) ",
	"白衣女子(打一四字成语) ",
	"白葡萄(打一成语)",
	"白描(打一成语)",
	"白居易五十寿辰(打一成语) ",
	"白天受妻管(打一成语) ",
	"登科后(打一成语)",
	"黯（打一成语）",
	"泵（打一成语）",
	"乖（打一成语）",
	"龙（打一成语）",
	"判（打一成语）",
	"扰（打一成语）",
	"十（打一成语）",
	"田（打一成语）",
	"亚（打一成语）",
	"呀（打一成语）",
	"一（打一成语）",
	"者（打一成语）",
	"主（打一成语）",
	"初一（打一成语）",
	"极小（打一成语）",
	"美梦（打一成语）",
	"美梦（打一成语）",
	"鸣镝（打一成语）",
	"齐唱（打一成语）",
	"卧倒（打一成语）",
	"仙乐（打一成语）",
	"兄弟（打一成语）",
	"圆寂（打一成语）",
	"显微镜（打一成语）",
	"八十八（打一成语）",
	"彩调剧（打一成语）",
	"打边鼓（打一成语）",
	"飞行员（打一成语）",
	"感冒通（打一成语）",
	"黑板报（打一成语）",
	"化妆学（打一成语）",
	"婚丧事（打一成语）",
	"垃圾箱（打一成语）",
	"农产品（打一成语）",
	"爬竹竿（打一成语）",
	"翘翘板（打一成语）",
	"太阳灶（打一成语）",
	"脱粒机（打一成语）",
	"望江亭（打一成语）",
	"无底洞（打一成语）",
	"笑死人（打一成语）",
	"娱乐圈（打一成语）",
	"纸老虎（打一成语）",
	"爱好跳伞（打一成语）",
	"冰解冰释（打一成语）",
	"病体自愈（打一成语）",
	"不准后退（打一成语）",
	"传送密件（打一成语）",
	"冬至已过（打一成语）",
	"翻砂造型（打一成语）",
	"翻印底片（打一成语）",
	"古稀者众（打一成语）",
	"果园漫步（打一成语）",
	"尽收眼底（打一成语）",
	"禁止登山（打一成语）",
	"惊险小说（打一成语）",
	"睛天霹雳（打一成语）",
	"举重比赛（打一成语）",
	"零存整取（打一成语）",
	"南郭吹竽（打一成语）",
	"逆水划船（打一成语）",
	"枪弹上膛（打一成语）",
	"全面开荒（打一成语）",
	"鹊巢鸦占（打一成语）",
	"石榴成熟（打一成语）",
	"四面不通（打一成语）",
	"我是仙人（打一成语）",
	"新陈代谢（打一成语）",
	"哑巴说话（打一成语）",
	"游览手册（打一成语）",
	"有空再看（打一成语）",
	"玉器展览（打一成语）",
	"再造乾坤（打一成语）",
	"窃贼找县令（打一成语）",
	"白骨精演讲（打一成语）",
	"李玉刚上台（打一成语）",
	"一人上战场（打一成语）",
	"多看无滋味（打一成语）",
	"《聊斋志异》（打一成语）",
	"脖子前的大刀（打一成语）",
	"冬天里的蚊子（打一成语）",
	"七仙女的琴声（打一成语）",
	"猫狗找同类（打一成语）",
	"三姑六婆的嘴（打一成语）",
	"深山中的瀑布（打一成语）",
	"头顶上泼猪油（打一成语）",
	"吸血鬼晒太阳（打一成语）",
	"电影里的小夫妻（打一成语）",
	"国庆元旦又传捷（打一成语）",
	"看见苍蝇就拔枪（打一成语）",
	"千歌万曲唱不尽（打一成语）",
	"瘸老头与瞎太婆（打一成语）",
	"三姑六婆去买菜（打一成语）",
	"师父给我取学号（打一成语）",
	"诉尽心中无限事（打一成语）",
	"天上掉下个凤姐（打一成语）",
	"天时人事日相催（打一成语）",
	"纨绔子弟抽鸦片（打一成语）",
	"正月十六办婚事（打一成语）"]
var data_guessWord_answer = [
	"谜底: 白驹过隙",
	"谜底: 妖言惑众",
	"谜底: 青出于蓝",
	"谜底: 徒劳无功",
	"谜底: 红装素裹",
	"谜底: 言过其实",
	"谜底: 绘声绘色",
	"谜底: 乐天知命",
	"谜底: 夜郎自大",
	"谜底: 走马观花",
	"谜底：有声有色",
	"谜底：水落石出",
	"谜底：乘人不备",
	"谜底：充耳不闻",
	"谜底：一刀两断",
	"谜底：半推半就",
	"谜底：纵横交错",
	"谜底：挖空心思",
	"谜底：有口难言",
	"谜底：唇齿相依",
	"谜底：接二连三",
	"谜底：有目共睹",
	"谜底：一往无前",
	"谜底：日新月异",
	"谜底：微乎其微",
	"谜底：好景不长",
	"谜底：好景不长",
	"谜底：弦外之音",
	"谜底：异口同声",
	"谜底：五体投地",
	"谜底：不同凡响",
	"谜底：数一数二",
	"谜底：坐以待毙",
	"谜底：一孔之见",
	"谜底：入木三分",
	"谜底：声色俱厉",
	"谜底：旁敲侧击",
	"谜底：有机可乘",
	"谜底：有伤风化",
	"谜底：白字连篇",
	"谜底：谈何容易",
	"谜底：悲喜交加",
	"谜底：藏垢纳污",
	"谜底：土生土长",
	"谜底：节节上升",
	"谜底：此起彼伏",
	"谜底：热火朝天",
	"谜底：吞吞吐吐",
	"谜底：近水楼台",
	"谜底：深不可测",
	"谜底：乐极生悲",
	"谜底：是非之地",
	"谜底：外强中干",
	"谜底：喜从天降",
	"谜底：化为乌有",
	"谜底：患得患失",
	"谜底：令人绝倒",
	"谜底：不可开交",
	"谜底：来日方长",
	"谜底：一模一样",
	"谜底：颠倒黑白",
	"谜底：人寿年丰",
	"谜底：脚踏实地",
	"谜底：一览无遗",
	"谜底：高不可攀",
	"谜底：危言耸听",
	"谜底：一鸣惊人",
	"谜底：斤斤计较",
	"谜底：积少成多",
	"谜底：随声附和",
	"谜底：力争上游",
	"谜底：一触即发",
	"谜底：不留余地",
	"谜底：化为乌有",
	"谜底：皮开肉绽",
	"谜底：走投无路",
	"谜底：自命不凡",
	"谜底：吐故纳新",
	"谜底：翻手为云",
	"谜底：引人入胜",
	"谜底：等闲视之",
	"谜底：琳琅满目",
	"谜底：改天换地",
	"谜底：恶人先告状",
	"谜底：妖言惑众",
	"谜底：男扮女装",
	"谜底：孤军奋战",
	"谜底：屡见不鲜",
	"谜底：鬼话连篇",
	"谜底：危在旦夕",
	"谜底：销声匿迹",
	"谜底：不同凡响",
	"谜底：如狼似虎",
	"谜底：搬弄是非",
	"谜底：放任自流",
	"谜底：油头滑脑",
	"谜底：无影无踪",
	"谜底：有名无实",
	"谜底：节节胜利",
	"谜底：小题大做",
	"谜底：其乐无穷",
	"谜底：相依为命",
	"谜底：讨价还价",
	"谜底：徒有其名",
	"谜底：畅所欲言",
	"谜底：无妄之灾",
	"谜底：迫不及待",
	"谜底：吞云吐雾",
	"谜底：见异思迁"]

#总的有多少个猜词游戏
var sumOfGuessGame = 108
#匹配列表
var isMatchingPalyer = []
var user = {
	"userId":0,
	"userName":"",
	"userAccount":"",
	"score":0
}
#游戏列表
var gameList = []
var game = {
	"gameUID" = "",
	"Player1" = null,
	"Player2" = null,
	"remaining_game" = [],	#这句游戏剩余的游戏编号
	"Lifeplayer1" = 100,	#表示一号玩家剩余的血量
	"Lifeplayer2" = 100,	#表示一号玩家剩余的血量
}
var game_round_data= {}

#定时器按时监视将列表中的信息取出去监测
var isMatchingPalyer_check = []
var isMatchingPalyer_check_bool = {}
var gameList_check = []
var gameList_check_bool = {}

#————————————————————————————初始化Timer的参数
var MatchingVictory_interval = 2	#每0.5秒检测是否有匹配成功
var isConnecting_interval = 5	#每5秒检测是否有人断开链接
var checkTimer_interval = 1		#给客户端相应服务端链接信号的时间间隔
var gameIDX = 0

var guessDataQApath = "user://guessDataQApath.save"

func _ready():
	_init_server()
	$MatchingVictoryTimer.wait_time = MatchingVictory_interval
	$isConnectingTimer.wait_time = isConnecting_interval
	$MatchingVictoryTimer.start()
	$isConnectingTimer.start()
	if(!FileAccess.file_exists(guessDataQApath)):
		_save_data()

#被客户端调用，即开始匹配的时候是客户端像服务端发送自己的数据
@rpc("any_peer")
func _match(player):
	isMatchingPalyer.append(player)
#停止匹配
@rpc("any_peer")
func _stop_match(player):
	isMatchingPalyer.erase(player)

#表示匹配成功，将数据传回


func _on_enemy_info_pressed():
	pass

@rpc("any_peer")
func _win(gameUID,player):
	if(player!=null):
		print("________调用_win方法,是",player["userName"],"获胜了")
		#终止计时即改变状态
		game_round_data.merge({gameUID:"null"},true)
	else:
		print("________调用_win方法,现在是平局了")
	#根据gameUID得到本剧游戏相关信息
	var i = 0
	while(i < gameList.size()):
		if(gameList[i]["gameUID"] == gameUID):
			break
		i+=1
	if(i >= gameList.size()):
		print("没有任何uid匹配成功")
		return
	var isLastGame = !(gameList[i]["remaining_game"].size()>0)
	if(player != null):
		#匹配到uid之后，对这个游戏数据进行更新，即更改输的人的血量
		if(gameList[i]["Player1"]["userAccount"] == player["userAccount"]):
			#是第一个玩家获得胜利，扣除第二个玩家的血量
				gameList[i]["Lifeplayer2"] -= 20
		else:
			gameList[i]["Lifeplayer1"] -= 20
		var enemyPlayer = gameList[i]["Player2"] if gameList[i]["Player1"]["userAccount"]==player["userAccount"] else gameList[i]["Player1"] 
		#在这里进行处理，即广播给对手，让其知道自己这句输了
		#这里查看是否是最后一句
		self.rpc("_temp_lose",gameUID,enemyPlayer,isLastGame,false)
	else:
		#假设时间到了，那么就平手，直接传送数据,最后一个参数是平手
		self.rpc("_temp_lose",gameUID,gameList[i]["Player1"],isLastGame,true)
		self.rpc("_temp_lose",gameUID,gameList[i]["Player2"],isLastGame,true)
	if(!isLastGame):
		#这里等待0.5秒，让用户做出ui反应
		await get_tree().create_timer(1).timeout
		#如果游戏没有结束，则继续发送数据
		var idx = gameList[i]["remaining_game"].pop_front()
		self.rpc("_loadGuessWordData",gameList[i]["gameUID"],
					data_guessWord_question[idx],data_guessWord_answer[idx])
	else:
		print("游戏彻底结束了——————————————")
		#做信号去userInfo中更新分数
		if(gameList[i]["Lifeplayer1"] > gameList[i]["Lifeplayer2"]):
			updateScore.emit(gameList[i]["Player1"],gameList[i]["Player2"],20)
		elif(gameList[i]["Lifeplayer1"] < gameList[i]["Lifeplayer2"]):
			updateScore.emit(gameList[i]["Player2"],gameList[i]["Player1"],20)
		print(gameList[i]["Lifeplayer1"],"***",gameList[i]["Lifeplayer2"])
		#一切结束后，在删除掉服务端这个game
		gameList.remove_at(i)
func _isMatchingVictoryTimer():
	while(isMatchingPalyer.size() > 1):
		#匹配成功
		#1.获取两个用户信息
		var user1 = isMatchingPalyer.pop_front()
		var user2 = isMatchingPalyer.pop_front()
		#2.生成唯一的游戏标识，这里直接用两个人的账号链接，中间用#符号
		var gameTemp = {
			"gameUID" = user1.get("userAccount")+"&*"+user2.get("userAccount"),
			"Player1" = user1,
			"Player2" = user2,
			"remaining_game" = [],
			"Lifeplayer1" = 100,	#表示一号玩家剩余的血量
			"Lifeplayer2" = 100 	#表示二号玩家剩余的血量
		}
		for i in range(5):
			gameTemp["remaining_game"].append(randi()%108)
		gameList.append(gameTemp)
		#3.给两个用户返回对手的信息和游戏的唯一标识，以及第一个问题
		self.rpc("_match_victory",gameTemp.get("gameUID"),
		gameTemp.get("Player1"),gameTemp.get("Player2"))
		#4.发送游戏数据
		var idx = gameTemp["remaining_game"].pop_front()
		self.rpc("_loadGuessWordData",gameTemp["gameUID"],
		data_guessWord_question[idx],data_guessWord_answer[idx])
		
func _isConnectingTimer():
	return
	isMatchingPalyer_check_bool.clear()
	gameList_check_bool.clear()
	print("检测一次")
	#设置5秒检测一次
	#——————————————————————对匹配队列的人进行联机检测
	var size_match = isMatchingPalyer.size()
	for i in range(size_match):
		var user = isMatchingPalyer.pop_front()
		isMatchingPalyer_check.append(user)
		#这里假设所有的人都是未连接的
		isMatchingPalyer_check_bool.merge({user["userAccount"]:false},true)
		#对匹配队列的数据进行检测
		self.rpc("_isConnecting",user["userAccount"])
	
	#——————————————————————对游戏队列的人进行联机检测
	var size_game = gameList.size()
	for i in range(size_game):
		var gameTemp = gameList.pop_front()
		gameList_check.append(gameTemp)
		#将两个玩家的信息都加入检测队列
		gameList_check_bool.merge({gameTemp["Player1"]["userAccount"]:false},true)
		gameList_check_bool.merge({gameTemp["Player2"]["userAccount"]:false},true)
		self.rpc("_isConnecting",gameTemp["Player1"]["userAccount"])
		self.rpc("_isConnecting",gameTemp["Player2"]["userAccount"])
	#这里因为网延迟问题，这里等待2秒钟
	await get_tree().create_timer(2).timeout
	#——————————————————————对匹配队列的人进行联机检测验证状态
	for i in range(size_match):
		var user = isMatchingPalyer_check.pop_front()
		if(isMatchingPalyer_check_bool[user["userAccount"]]):
			print("有一个用户链接正常")
			isMatchingPalyer.append(user)
		else:
			print("一个用户链接异常")
	#——————————————————————对游戏队列的人进行联机检测验证状态
	for i in range(size_game):
		var gameTemp = gameList_check.pop_front()
		var p1 = gameTemp["Player1"]
		var p2 = gameTemp["Player2"]
		var countOfOK = 0
		if(gameList_check_bool[p1["userAccount"]]):
			print("有一个用户链接正常")
			countOfOK+=1
		if(gameList_check_bool[p2["userAccount"]]):
			print("有一个用户链接正常")
			countOfOK+=1
		if(countOfOK == 2):
			#说明两个玩家链接均正常
			pass
		if(countOfOK < 2):
			print("共有"+str((2-countOfOK))+"个用户链接异常")
@rpc("any_peer")
func _isConnectingSure(account):
	print("被调用到了_isConnectingSure")
	#将对应的user状态变为true
	if(isMatchingPalyer_check_bool.has(account)):
		isMatchingPalyer_check_bool.merge({account:true},true)
	if(gameList_check_bool.has(account)):
		gameList_check_bool.merge({account:true},true)

#创建服务器
func _init_server():
	if netWork.create_server(8080) == OK:
		print("创建游戏控制服务器成功")
	self.multiplayer.multiplayer_peer = netWork
	netWork.peer_disconnected.connect(_player_disconnected)
	netWork.peer_connected.connect(_player_connected)
#数据操作
func _save_data():
	#给这个文件初始化
#	var file = FileAccess.open(guessDataQApath, FileAccess.WRITE_READ)
#	file.store_line(JSON.stringify(data_guessWord_question))
#	file.store_line(JSON.stringify(data_guessWord_answer))
#	file.close()
	return
func _get_data():
	var d1 = data_guessWord_question
	var d2 = data_guessWord_answer
	return [d1,d2]

@rpc
func _match_victory(gameIDX,player1,player2):
	pass
	
#服务端向客户端发送游戏数据，结构为gameUID和问题
@rpc("call_local")
func _loadGuessWordData(gameUID,ques,ans):
	#将这个游戏信息记录下来
	game_round_data.merge({gameUID:ques},true)
	print("开始计时")
	await get_tree().create_timer(10).timeout
	#如果还存在这个游戏，且这局游戏内容没变，则说明没有人答出来，算是平局
	if(game_round_data.has(gameUID) and game_round_data.get(gameUID) == ques):
		_win(gameUID,null)
@rpc
func _end_thisGame(gameUID,result):
	pass
@rpc
func _temp_lose(gameUID,player,isLastGame,isDraw):
	pass
@rpc
func _isConnecting(account):
	pass

func _player_connected(PlayerId):
	print(PlayerId,"链接成功")
	
func _player_disconnected(PlayerId):
	#从匹配列表中删除这个PlayerId
	var size = isMatchingPalyer.size()
	for i in range(size):
		if(isMatchingPalyer[i]["userId"] == PlayerId):
			print("成功断开匹配")
			isMatchingPalyer.remove_at(i)
