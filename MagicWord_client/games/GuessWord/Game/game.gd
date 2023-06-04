extends Node2D
var textInput = ""
var positionOfGame = -1
var countOfGame = -1
signal out
signal win
signal next
#问题
var question = ""
#答案
var answer = ""
#一共多少道题

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_tips_pressed():
	$tip_prompt.visible = true
	$tip_prompt/back.text = answer
func _on_back_pressed():
	#信号传递到主场景让他操作
	out.emit()

func _on_cancel_pressed():
	$tip_prompt.visible = false


func _on_commit_pressed():
	textInput = $td1.text;
	if(answer.find(textInput)):
		$tip_win.visible = true
		win.emit(positionOfGame)
	else:
		$tip_lose.visible = true

func _init_screen(idx,ques,ans,count):
	positionOfGame = idx
	question = ques
	answer = ans
	countOfGame = count
	#更改界面的值
	$Label.text = question
	$td1.text = ""
func _on_try_again_pressed():
	$tip_lose.visible = false
	$tip_win.visible = false
	$tip_prompt.visible = false
	$td1.text = ""


func _on_next_pressed():
	#将页面隐藏
	$tip_win.visible = false
	#先退出，在跳转到下一道题界面
	_on_back_pressed()
	next.emit(positionOfGame+1)
