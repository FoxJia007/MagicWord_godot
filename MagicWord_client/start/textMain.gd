extends Node2D
var process_path = "user://process_data.save"
var guessWord_data_path = "user://guessWord_data.save"
var linkWord_data_path = "user://linkWord_data.save"
#表示游戏通关进度列表
var process_store = {
	#采用二进制的格式
	"GuessWord" : 0,
	"LinkWord" : 0,
	"MakeSentence" : 0,
	"WordInWord" : 0
}
#表示猜词游戏的问题列表
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
	"登科后(打一成语)"]
#表示猜词游戏的答案列表列表
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
	"谜底: 走马观花"]

var dataOfLinkWords = [{
	"data_string":"流红豆生南国锄禾海枝几发来春当日入河黄尽山依午汗径万鸟山千日禾滴人绝飞思亲白下土踪雨声倍独在异乡灭风花节佳逢每为夜来落知多少客异",
	"matches_data" : ["独在异乡为异客每逢佳节倍思亲",
		"千山鸟飞绝万径人踪灭",
		"红豆生南国春来发几枝",
		"锄禾日当午汗滴禾下土",
		"夜来风雨声花落知多少",
		"白日依山尽黄河入海流"],
	"poems_name" : ["《九月九日忆山东兄弟》","《江雪》","《相思》","《锄禾》","《春晓》","《登鹳雀楼》"]
},{
	"data_string":"春色乡故思头头举园满一枝红低望惊关不住来杏月明不火野好墙出还在鸟烧生雨春去花人来不又知时节当春乃尽吹只在此山中发春风处知不深云生",
	"matches_data" : ["举头望明月低头思故乡",
		"春色满园关不住一枝红杏出墙来",
		"好雨知时节当春乃发生",
		"春去花还在人来鸟不惊",
		"只在此山中云深不知处",
		"野火烧不尽春风吹又生"],
	"poems_name" : ["《静夜思》","《游园不值》","《春夜喜雨》","《画》","《寻隐者不遇》","《草》"]
},
{
	"data_string":"晓月国破山河在行残过深木草春城到垒起云看坐处穷水繁时生残不归如水星海日夜归色凉卧宿故关江孙夜星看年旧入春王阶女牵春草明年绿天织牛",
	"matches_data" : ["晓月过残垒繁星宿故关",
		"国破山河在城春草木深",
		"行到水穷处坐看云起时",
		"海日生残夜江春入旧年",
		"春草明年绿王孙归不归",
		"天阶夜色凉如水卧看牵牛织女星"],
	"poems_name" : ["《贼平后送人北归》","《春望》","《终南别业》","《次北固山下》","《送别》","《秋夕》"]
},
{
	"data_string":"晓月国破山河在行残过深木草春城到垒起云看坐处穷水繁时生残不归如水星海日夜归色凉卧宿故关江孙夜星看年旧入春王阶女牵春草明年绿天织牛",
	"matches_data" : ["晓月过残垒繁星宿故关",
		"国破山河在城春草木深",
		"行到水穷处坐看云起时",
		"海日生残夜江春入旧年",
		"春草明年绿王孙归不归",
		"天阶夜色凉如水卧看牵牛织女星"],
	"poems_name" : ["《贼平后送人北归》","《春望》","《终南别业》","《次北固山下》","《送别》","《秋夕》"]
},
{
	"data_string":"白桑林风多响征人头空八进沉易长未宫鸣月难飞重里还女蝉萧关道露万秦住长风几万里关时闲举杯邀人吹时明坐宗月明三度汉月说玄对影成玉门关",
	"matches_data" : ["白头宫女住闲坐说玄宗",
		"举杯邀明月对影成三人",
		"长风几万里吹度玉门关",
		"蝉鸣空桑林八月萧关道",
		"露重飞难进风多响易沉",
		"秦时明月汉时关万里长征人未还"],
	"poems_name" : ["行宫","月下独酌四首·其一","关山月","塞上曲·其一","在狱咏蝉","出赛"]
},
]
# Called when the node enters the scene tree for the first time.
func _ready():
	if(!FileAccess.file_exists(process_path)):
		_init_data()
	if(!FileAccess.file_exists(guessWord_data_path)):
		_save_guessData()
	if(!FileAccess.file_exists(linkWord_data_path)):
		_save_linkWordData()
	_on_btn_1_pressed()
func _init_data():
	#给这个文件初始化
	var file = FileAccess.open(process_path, FileAccess.WRITE_READ)
	file.store_line(JSON.stringify(process_store))
	file.close()      
	return

func _load():
	#文件存在，这时候传入数据，表示那一关通过了
	var file = FileAccess.open(process_path, FileAccess.READ)
	var data = file.get_as_text()
	file.close
	var process_data = JSON.parse_string(data)
	return process_data
	
#获取某一游戏所有关卡的通关信息
func _save(data):
	var file = FileAccess.open(process_path, FileAccess.READ)
	file.seek(0)
	file.store_line(data)
	file.close
	
#初始化保存猜词游戏的数据
func _save_guessData():
	var file = FileAccess.open(guessWord_data_path, FileAccess.WRITE)
	file.seek(0)
	file.store_line(JSON.stringify(data_guessWord_question))
	file.store_line(JSON.stringify(data_guessWord_answer))
	file.close()
#获取猜词游戏的相关数据
func _getGuessWordData():
	var file = FileAccess.open(guessWord_data_path, FileAccess.READ)
	file.seek(0)
	var d1 = file.get_line()
	var d2 = file.get_line()
	file.close()
	return [d1,d2]
#初始化保存连词游戏的数据
func _save_linkWordData():
	var file = FileAccess.open(linkWord_data_path, FileAccess.WRITE)
	file.seek(0)
	for data in dataOfLinkWords:
		file.store_line(JSON.stringify(data))
	file.close()
#获取连词游戏的相关数据
func _getLinkWordData():
	var file = FileAccess.open(linkWord_data_path, FileAccess.READ)
	file.seek(0)
	var d1 = file.get_line()
	file.close()
	return d1

func _on_btn_1_pressed():
	get_tree().change_scene_to_file("res://start/startScene.tscn")
