extends Node3D
class_name 말

enum 위치 {달말통, 판위눈, 이동중, 난말통}

var 속한편 :편
var 말번호 :int
var 지나온눈번호들 :Array[int]
var 말위치 :위치

func string_debug() -> String:
	var s :String = ""
	for n in 지나온눈번호들:
		s += "%d " % n
	return "말(%s %d 눈[%s])" % [속한편,말번호,s]

func _to_string() -> String:
	return "%s말%d%s" % [속한편,말번호]

func init(t :편, 반지름 :float, 높이 :float, n:int, hide_num :bool = false) -> 말:
	속한편 = t
	말번호 = n
	반지름 = 반지름*1.0 * t.인자.크기보정
	$"다각기둥".init(반지름, 높이, t.인자.색, t.인자.모양)
	$"번호".text = "%d" % 말번호
	$"번호".visible = not hide_num
	$"번호".modulate = t.인자.색
	#$"번호".position.z = 높이
	달말로만들기()
	return self

func 편얻기()->편:
	return 속한편

func 마지막눈번호()->int:
	return 지나온눈번호들[-1]

func 난말로만들기() -> void:
	지나온눈번호들 = []
	말위치 = 위치.난말통

func 달말로만들기() -> void:
	지나온눈번호들 = []
	말위치 = 위치.달말통

func 말위치설정(위치a :위치):
	말위치 = 위치a

func 말위치얻기() -> 위치:
	return 말위치
