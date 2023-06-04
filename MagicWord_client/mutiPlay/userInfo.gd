extends Node2D
signal isLoginOk
var userAccount = ""
var isLoading = false
var userId = 0
#var ip = "192.168.124.1"
#var ip = "121.36.29.151"
var ip = "169.254.254.233"
var port = 8081
# Called when the node enters the scene tree for the first time.
func _ready():
	_init_client()
	_init_screen()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#退出登录w
func _logOut_pressed(user):
	#给服务器发退出信号
	self.rpc("_logOut",userId)
	#初始化界面
	_init_screen()

func _on_login_pressed():
	$tips.visible = false
	#这里记录以下自己输入的用户账号
	userAccount = $LoginScreen/userAccount.text
	var password = $LoginScreen/userpassword.text
	self.rpc("_login",userId,userAccount,password)
	
	
func _on_registry_pressed():
	var account = $RegistryScreen/userAccount.text
	var password = $RegistryScreen/userpassword.text
	var checkPassword = $RegistryScreen/checkpassword.text
	if(password != checkPassword):
		$tips.text = "两次输入密码不一致，请重新输入"
		$tips.visible = true
		return
	if(len(account)<8||len(account)>16):
		$tips.text = "账号长度为8到16位"
		$tips.visible = true
		return
	if(len(password)<8||len(password)>16):
		$tips.text = "密码长度为8到16位"
		$tips.visible = true
		return
	var isOk = true
	for i in account:
		if((i>='a'and i<='z') || (i>='A'and i<='Z') || (i>='0'and i<='9')):
			continue
		isOk = false
		break
	for i in password:
		if((i>='a'and i<='z') || (i>='A'and i<='Z') || (i>='0'and i<='9')):
			continue
		isOk = false
		break
	if(!isOk):
		$tips.text = "账号密码仅允许字母和数字"
		$tips.visible = true
		return
	self.rpc("_registry",$RegistryScreen/userName.text
	,$RegistryScreen/userAccount.text,$RegistryScreen/userpassword.text)


func _toggle():
	$LoginScreen.visible = !$LoginScreen.visible
	$RegistryScreen.visible = !$RegistryScreen.visible

@rpc
func _login(userId,useuserAccount,userPassword):
	#调用远程服务器代码
	pass

@rpc
func _registry(userName,userAccount,userPassword):
	pass

#返回用户登录成功与否,并传回名称和分数信息
@rpc
func _isLoginOK(leek,tempUser,styleError):
	#返回登录成功的信号和
	if(leek and tempUser["userAccount"]==userAccount):
		isLoginOk.emit(tempUser)
		#更改登录态，为已经登录的状态，则userAccount是当前的账号
		isLoading = true
	else:
		$tips.text = styleError
		$tips.visible = true
		_init_screen()

#返回用户注册成功与否
@rpc
func _isRegistry(leek):
	if(leek):
		print()
	else:
		$tips.text = "注册成功"
		$tips.visible = true
	#跳转到登录页面
	_toggle()
	
#@rpc
#func _isConnecting(account):
#	if(isLoading and account == userAccount):
#		self.rpc("_isConnectingSure",account)
#@rpc
#func _isConnectingSure(account):
#	pass
#退出登录
@rpc
func _logOut(userId):
	pass
#创建客户端
func _init_client():
	print("客户端测试")
	var peer = ENetMultiplayerPeer.new()
	if peer.create_client(ip,port) == OK:
		print("链接成功")
	else:
		return
	self.multiplayer.multiplayer_peer = peer
	self.get_multiplayer().connect("connection_failed",Callable(self,"_OnConnectionFailed"))
	self.get_multiplayer().connect("connected_to_server",Callable(self, "_OnConnectionSuccessded"))
	userId = self.get_multiplayer().get_unique_id()
func _init_screen():
	$LoginScreen/userAccount.text = ""
	$LoginScreen/userpassword.text = ""
	isLoading = false

func _OnConnectionSuccessded():
	print("链接成功")
func _OnConnectionFailed():
	print("链接中断")


func _on_back_pressed():
	get_tree().change_scene_to_file("res://start/startScene.tscn")
