class_name 윷짝

const 결과문자변환 = {
	-3:"뒷걸",
	-2:"뒷개",
	-1:"뒷도",
	1:"도",
	2:"개",
	3:"걸",
	4:"윷",
	5:"모",
}

class 윷가락:
	func 던지기() -> int:
		return randi_range(0,1)

var 윷들 :Array[윷가락]
var 결과수치 :int
var 던진횟수 :int = 0

func _to_string() -> String:
	return 결과문자변환[결과수치]

func init() -> 윷짝:
	for i in range(0,4):
		윷들.append(윷가락.new())
	return self

func 윷던지기():
	var 결과 :Array[int]
	for n in 윷들:
		결과.append( n.던지기() )
	결과수치 = 결과해석(결과)
	던진횟수 += 1

func 결과얻기()->int:
	return 결과수치

func 던진횟수얻기()->int:
	return 던진횟수

func 결과해석(결과 :Array[int])->int:
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
