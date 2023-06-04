extends Node2D
var userInfo_path = "user://userInfo.save"
#网络
var netWork = ENetMultiplayerPeer.new()
var userInfos = [
	{
	"userName" : "第一",
	"userAccount" : "www123456789",
	"userPassword" : "111111",
	"score" : 100,
	},
	{
	"userName" : "第二",
	"userAccount" : "aaa123456789",
	"userPassword" : "111111",
	"score" : 100,
	},
	{
	"userName" : "天下第一词汇高手",
	"userAccount" : "www",
	"userPassword" : "111",
	"score" : 80,
	},
	{
	"userName" : "小无相",
	"userAccount" : "aaa",
	"userPassword" : "111",
	"score" : 120,
	}
]
var loadingUser = {}

var minScore = 60
# Called when the node entsers the scene tree for the first time.
func _ready():
	_init_server()

#登录功能,客户端传来数据，必须加上anypeer注解
@rpc("any_peer")
func _login(userId,userAccount,userPassword):
	#判断是否重复登录
	if(loadingUser.has(userId)):
		self.rpc("_isLoginOK",false,null,"不能重复登录")
		return
	var data = _get_data()
	for user in data:
		if(user.get("userAccount") == userAccount and user.get("userPassword") == userPassword):
			var temp_user = {
				"userAccount":user.get("userAccount"),
				"userName":user.get("userName"),
				"score":user.get("score")
			}
			loadingUser.merge({userId:temp_user})
			self.rpc("_isLoginOK",true,temp_user,"")
			return
	self.rpc("_isLoginOK",false,null,"用户名或者密码错误")

#退出登录
@rpc("any_peer")
func _logOut(userId):
	#判断是否在登录，没有在登录态，直接停止
	if(loadingUser.has(userId)):
		loadingUser.erase(userId)

#注册功能,客户端传来数据，必须加上anypeer注解
@rpc("any_peer")
func _registry(userName,userAccount,userPassword):
	var data = _get_data()
	for user in data:
		if(user.get("userAccount") == userAccount):
			print("注册失败")
			self.rpc("_isRegistry",false)
			return
	var user = {
		"userName" : userName,
		"userAccount" : userAccount,
		"userPassword" : userPassword,
		"score" : 100,
	}
	data.append(user)
	_save_data(data)
	self.rpc("_isRegistry",true)

#数据操作
func _save_data(userInfos_data):
	#给这个文件初始化
#	var file = FileAccess.open(userInfo_path, FileAccess.WRITE_READ)
#	for userInfo in userInfos_data:
#		file.store_line(JSON.stringify(userInfo))
#	file.close()
	userInfos = userInfos_data
	return
func _get_data():
#	var file = FileAccess.open(userInfo_path, FileAccess.READ)
#	var userInfo_data = []
#	while(!file.eof_reached()):
#		var data_now = file.get_line()
#		if(data_now.length()>0):
#			userInfo_data.append(JSON.parse_string(data_now))
#	file.close()
	return userInfos

#返回用户登录成功与否
@rpc
func _isLoginOK(leek,tempUser,styleError):
	pass

#返回用户注册成功与否
@rpc
func _isRegistry(leek):
	pass

#创建服务器
func _init_server():
	if netWork.create_server(8081) == OK:
		print("用户信息,创建服务器成功")
	self.multiplayer.multiplayer_peer = netWork
	netWork.peer_disconnected.connect(_player_disconnected)
	netWork.peer_connected.connect(_player_connected)
	print("————————————————————————")
	print(netWork.host)

func _updateScore(user1,user2,score):
	#"更新数据"
	var userInfoes = userInfos
	for i in range(userInfoes.size()):
		if(userInfoes[i]["userAccount"]==user1["userAccount"]):
			userInfoes[i]["score"] += score
		elif(userInfoes[i]["userAccount"]==user2["userAccount"]):
			userInfoes[i]["score"] -= score
			if(userInfoes[i]["score"] < minScore):
				userInfoes[i]["score"] = minScore
	userInfos = userInfoes

func _player_connected(PlayerId):
	pass
func _player_disconnected(PlayerId):
	#这里要判断是否在登录中
	_logOut(PlayerId)
