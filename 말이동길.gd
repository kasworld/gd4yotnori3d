extends Node3D
class_name 말이동길

var 화살표_scene = preload("res://arrow3d/arrow3d.tscn")

const 가능한시작눈목록 = [0,1,2,3,5,6,7,8,10,11,12,13,15,16,17,18]
var 화살표두께 :float
var 화살표색 :Color
var 눈들 :Array[눈]
# 눈번호
var 바깥길 :Array[int]
var 첫지름길 :Array[int]
var 둘째지름길 :Array[int]
var 세째지름길 :Array[int]
var 놓을길시작 : Vector3
var 나는길끝 : Vector3

func _to_string() -> String:
	return "%s\n%s\n%s\n%s\n" %[바깥길,첫지름길,둘째지름길,세째지름길]

func init(w: float, co :Color, es :Array[눈], 시작눈 :int, mirror :bool = false) -> 말이동길:
	화살표색 = co
	화살표두께 = w
	눈들 = es

	# 말 이동 순서 연결하기
	바깥길 = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]
	for i in range(0,시작눈):
		var v = 바깥길.pop_front()
		바깥길.push_back(v)

	var 지름길1 :Array[int] = [4,20,21,22,23,24,14] # 할일. 종점눈까지 추가해둘것.
	var 지름길2 :Array[int] = [9,25,26,22,27,28,19]
	if mirror:
		var v = 바깥길.pop_front()
		바깥길.push_back(v)
		바깥길.reverse()
		var tmp = 지름길1
		지름길1 = 지름길2
		지름길2 = tmp

	match 시작눈:
		0,1,2,3:
			if mirror:
				지름길1.reverse()
				지름길2.reverse()
			첫지름길 = 지름길1
			둘째지름길 = 지름길2
		5,6,7,8:
			첫지름길 = 지름길2
			지름길1.reverse()
			둘째지름길 = 지름길1
		10,11,12,13:
			if not mirror:
				지름길1.reverse()
				지름길2.reverse()
			첫지름길 = 지름길1
			둘째지름길 = 지름길2
		15,16,17,18:
			지름길2.reverse()
			첫지름길 = 지름길2
			둘째지름길 = 지름길1
		_:
			print_debug("잘못된 시작점입니다.", 가능한시작눈목록,"만 가능")
			get_tree().quit()

	세째지름길 = 둘째지름길.slice(3)
	첫지름길.append_array(바깥길.slice(바깥길.find(첫지름길[-1])+1))
	둘째지름길.append_array(바깥길.slice(바깥길.find(둘째지름길[-1])+1))
	세째지름길.append_array(바깥길.slice(바깥길.find(세째지름길[-1])+1))

	for i in range(0,바깥길.size()-1):
		var p1 = 눈들[바깥길[i]].position
		var p2 = 눈들[바깥길[i+1]].position
		화살표추가(p1,p2)

	for i in range(0,첫지름길.size()-1):
		var p1 = 눈들[첫지름길[i]].position
		var p2 = 눈들[첫지름길[i+1]].position
		화살표추가(p1,p2)

	for i in range(0,둘째지름길.size()-1):
		var p1 = 눈들[둘째지름길[i]].position
		var p2 = 눈들[둘째지름길[i+1]].position
		화살표추가(p1,p2)

	var 중점 = 눈들[22].position

	var 시작점 = 눈들[바깥길[0]].position
	놓을길시작 = ((중점-시작점)*0.3).rotated(Vector3.FORWARD, -PI/6) + 시작점
	화살표추가(놓을길시작,시작점)

	var 끝점 = 눈들[바깥길[-1]].position
	나는길끝 = ((중점-끝점)*0.3).rotated(Vector3.FORWARD, -PI/6) + 끝점
	화살표추가(끝점,나는길끝)

	return self

# 도착 말눈번호를 돌려준다.
# 말을 새로 다는 경우 현재말눈번호를 -1
# 이동거리가 - 인경우(뒷도개걸)는 말의 이동거리기록을 사용한다.
# 말이 나는 경우 마지막눈까지를 돌려준다.
# 에러인 경우 [] 들 돌려준다.
func 말이동과정찾기(현재말눈번호:int, 이동거리:int)->Array[int]:
	if 이동거리 < 1 or 이동거리 > 5 :
		print_debug("잘못된 이동거리 ", 이동거리)
		return []
	if 현재말눈번호 < -1 or 현재말눈번호 > 28 :
		print_debug("잘못된 현재말눈번호 ", 현재말눈번호)
		return []
	if 현재말눈번호 == -1: # 말을 새로 다는 경우
		return 바깥길.slice(0,이동거리)

	# 갈길 고르기
	var 갈길 = 바깥길
	if 세째지름길.find(현재말눈번호) != -1 : # 세째지름길 진입
		갈길 = 세째지름길
	elif 둘째지름길.find(현재말눈번호) != -1: # 둘째지름길 진입
		갈길 = 둘째지름길
	elif 첫지름길.find(현재말눈번호) != -1: # 첫지름길 진입
		갈길 = 첫지름길
	# 길에서 위치 찾기
	var i = 갈길.find(현재말눈번호)
	if i < 0:
		print_debug("이상한 문제 ", 갈길, 현재말눈번호 )
		return []
	if i+이동거리 >= 갈길.size(): # 말이 나는 경우
		return 갈길.slice(i+1)
	return 갈길.slice(i+1,i+이동거리+1)

func 종점눈번호()->int:
	return 바깥길[-1]

func 화살표추가(p1 :Vector3, p2 :Vector3):
	var 화살표 = 화살표_scene.instantiate()
	var t1 = (p1-p2)*0.8+p2
	var t2 = (p2-p1)*0.8+p1
	화살표.init((t1-t2).length(), 화살표색, 화살표두께, 화살표두께*4)
	var temp = p2-p1
	var v2 = Vector2(temp.x, temp.y)
	var a2 = v2.angle()
	화살표.rotate_z( a2 -PI/2 )
	화살표.position = (p1+p2)/2
	$"화살표통".add_child(화살표)
