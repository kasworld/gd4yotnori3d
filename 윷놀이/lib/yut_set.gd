class_name YutSet

const ValueToString :Dictionary[int,String] = {
	-3:"뒷걸",
	-2:"뒷개",
	-1:"뒷도",
	0: "낙",
	1:"도",
	2:"개",
	3:"걸",
	4:"윷",
	5:"모",
}

const ArrayToValue :Dictionary[Array,int] = {
	# 0:등 1:배
	[0,0,0,1] : -1, # 도 백
	[0,0,1,0] : 1, # 도
	[0,1,0,0] : 1, # 도
	[1,0,0,0] : 1, # 도
	[0,0,1,1] : -2, # 개 백
	[0,1,0,1] : 2, # 개
	[1,0,0,1] : 2, # 개
	[0,1,1,0] : 2, # 개
	[1,0,1,0] : 2, # 개
	[1,1,0,0] : 2, # 개
	[0,1,1,1] : -3, # 걸 백
	[1,0,1,1] : 3, # 걸
	[1,1,0,1] : 3, # 걸
	[1,1,1,0] : 3, # 걸
	[1,1,1,1] : 4, # 윷
	[0,0,0,0] : 5, # 모
}

var result_array :Array[int]
var result_value :int
var result_string :String
var can_more_turn :bool

func _to_string() -> String:
	return result_string

func 윷던지기() -> void:
	result_array = [randi_range(0,1),randi_range(0,1),randi_range(0,1),randi_range(0,1)]
	result_value = ArrayToValue[result_array]
	result_string = ValueToString[result_value]
	can_more_turn = result_value==5 or result_value == 4
