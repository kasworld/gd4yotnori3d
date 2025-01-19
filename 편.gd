extends PanelContainer
class_name 편

class 인자틀:
	var 이름 :String
	var 색 :Color
	var 모양 :int
	var 크기보정 :float
	func _init(a,b,c,d) -> void:
		이름 = a
		색 = b
		모양 = c
		크기보정 = d

@onready var 길단추 = $HBoxContainer/Button

var 말_scene = preload("res://말.tscn")
var 말이동길_scene = preload("res://말이동길.tscn")

var 인자 :인자틀
var 눈들 :말눈들
var 길 :말이동길
var 말들 :Array[말]
var 등수 :int
func _to_string() -> String:
	return "%s편" % [인자.이름]

func 등수쓰기(n :int):
	등수 = n
	$HBoxContainer/Label.text = "%d등" % n

func 등수얻기() -> int:
	return 등수

func init(편정보 :인자틀, 말수 :int, 크기:float, es :말눈들, 시작눈 :int, mirror :bool = false) -> 편:
	인자 = 편정보
	눈들 = es
	길 = 말이동길_scene.instantiate()
	길.init( max(1,크기/200), 인자.색, es.눈들, 시작눈, mirror)
	var r = 크기/30
	custom_minimum_size = Vector2(r*2*10,r*2)
	길단추.text = 인자.이름
	길단추.modulate = 인자.색
	for i in range(0,말수):
		var m = 말_scene.instantiate().init(self, r,r/3, i+1)
		말들.append(m)
	return self

func 난말수얻기() -> int:
	var rtn :int = 0
	for n in 말들:
		if n.말위치얻기() == 말.위치.난말통:
			rtn +=1
	return rtn

func 모든말이났나() -> bool:
	return 난말수얻기() == 말들.size()

# 이동 주체로 사용 불가
func 업힌말인가(m :말)->bool:
	var ms = 눈들.눈얻기(m.마지막눈번호()).말보기()
	return m.말위치얻기() == 말.위치.판위눈 and ms[0] != m

func 업은말들얻기(m :말)->Array[말]:
	return 눈들.눈얻기(m.마지막눈번호()).말보기()

func 쓸말고르기(윷짝a :윷짝)->말:
	var 섞은말 = 말들.duplicate()
	섞은말.shuffle()
	for m in 섞은말:
		if m.말위치얻기() == 말.위치.난말통:
			continue
		if m.말위치얻기() == 말.위치.달말통:
			if 윷짝a.결과얻기() < 0:
				continue
			return m
		if 업힌말인가(m):
			continue
		return m
	# 모두 났다.
	return null

func 말이동정보만들기(윷짝a :윷짝, m :말)->말들이동정보:
	if m == null :
		return 말들이동정보.new()
	if m.말위치얻기() == 말.위치.난말통:
		return 말들이동정보.new()
	if m.말위치얻기() == 말.위치.달말통 and 윷짝a.결과얻기() > 0:
		return 새로말달정보만들기(윷짝a, m)
	if 업힌말인가(m):
		return 말들이동정보.new()
	return 판위의말이동할정보만들기(윷짝a, m)

func 새로말달정보만들기(윷짝a :윷짝, m :말)->말들이동정보:
	var 결과 = 말들이동정보.new()
	결과.이동과정눈번호들 = 길.말이동과정찾기(-1,윷짝a.결과얻기())
	for i in 결과.이동과정눈번호들:
		m.지나온눈번호들.append(i)
	결과.도착눈 = 눈들.눈얻기(결과.이동과정눈번호들[-1])
	결과.잡힐말들 = 결과.도착눈.말잡기시도([m])
	결과.새로달말 = m
	결과.이동할말들.append(m)
	결과.이동성공 = true
	return 결과

func 판위의말이동할정보만들기(윷짝a :윷짝, m :말)->말들이동정보:
	var 결과 = 말들이동정보.new()
	결과.이동할말들 = 눈들.눈얻기(m.마지막눈번호()).말보기()
	if 윷짝a.결과얻기() < 0: # 뒷도개걸 처리
		if m.지나온눈번호들.size() <= -윷짝a.결과얻기(): #판에서 빼서 놓을 말로 돌아간다.
			for i in m.지나온눈번호들:
				결과.이동과정눈번호들.append(i)
			결과.이동과정눈번호들.reverse()
			결과.놓을말로돌아갈말들 = 결과.이동할말들
			결과.이동성공 = true
			return 결과
		for i in range(윷짝a.결과얻기(),0): # 업은말의 첫말의 지나온눈번호들에서 빼면서 뒤로 이동한다.
			결과.이동과정눈번호들.append(m.지나온눈번호들.pop_back())
		결과.이동과정눈번호들.append(m.마지막눈번호())
		결과.도착눈 = 눈들.눈얻기(m.마지막눈번호())
		결과.잡힐말들 = 결과.도착눈.말잡기시도(결과.이동할말들)
		결과.이동성공 = true
		return 결과

	# 앞으로 가기
	var 기존위치눈번호 = m.마지막눈번호()
	결과.이동과정눈번호들 = 길.말이동과정찾기(m.마지막눈번호(),윷짝a.결과얻기())
	for i in 결과.이동과정눈번호들: # 말에 지나가는 눈들 추가
		m.지나온눈번호들.append(i)
	결과.이동과정눈번호들.push_front(기존위치눈번호)
	if 결과.이동과정눈번호들[-1] == 길.종점눈번호(): # 말이 났다.
		결과.날말들 = 결과.이동할말들
		결과.이동성공 = true
		return 결과
	결과.도착눈 = 눈들.눈얻기(결과.이동과정눈번호들[-1])
	결과.잡힐말들 = 결과.도착눈.말잡기시도(결과.이동할말들)
	결과.이동성공 = true
	return 결과
