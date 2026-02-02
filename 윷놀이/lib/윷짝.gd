class_name 윷짝

const 결과문자변환 = {
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

var 결과수치 :int

func _to_string() -> String:
	return 결과문자변환[결과수치]

func 윷던지기() -> void:
	var 결과 :Array[int]
	for i in 4:
		결과.append( randi_range(0,1) )
	결과수치 = 결과해석(결과)

func 결과얻기() -> int:
	return 결과수치

func 결과해석(결과 :Array[int]) -> int:
	if 결과 == [1,0,0,0]:
		return -1
	if 결과 == [1,1,0,0]:
		return -2
	# 백개를 두가지 경우 다 가능 하게 하려면 아래를 사용.
	#if 결과 == [1,0,1,0]:
		#return -2
	if 결과 == [1,1,1,0]:
		return -3
	if 결과 == [0,0,0,0]:
		return 5
	var sum = 0
	for i in 결과:
		sum += i
	return sum

func 한번더던지나() -> bool:
	return 결과수치==5 or 결과수치 == 4
