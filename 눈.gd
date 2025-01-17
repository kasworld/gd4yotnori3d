extends Node3D
class_name 눈

var 번호 :int

func _to_string() -> String:
	return "눈%d" % 번호

func init(반지름 :float, 높이 :float, 색깔: Color, n:int) -> void:
	self.번호 = n
	$"말통".init(반지름,높이,색깔,64,1.1,"%d" % 번호, Vector3(반지름,-반지름,0))
	눈번호보기(false)


func 말놓기(놓을말들 :Array)->Array[말]:
	if 놓을말들.size() == 0 :
		print("문제:놓을말들이 비어있습니다.", 번호)
		return []

	var 선두말 :말
	var 잡은말들 : Array[말]
	var 있던말들 = 말보기()
	if 있던말들.size() != 0:
		if 있던말들[0].편얻기() != 놓을말들[0].편얻기():
			# 말을 잡는다.
			잡은말들 = 말빼기()
			선두말 = 놓을말들[0]
		else :
			선두말 = 있던말들[0]
	else :
		선두말 = 놓을말들[0]

	for m in 놓을말들:
		$"말통".말넣기(m)
		m.지나온눈번호들 = 선두말.지나온눈번호들
	return 잡은말들

func 말빼기()->Array[말]:
	return $"말통".말모두빼기()

func 말보기()->Array[말]:
	return $"말통".말보기()

func 눈번호보기(b :bool):
	$"말통".설명보기(b)
