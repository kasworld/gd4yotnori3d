extends Node3D
class_name 말

var 속한편 :편
var 말번호 :int
var 지나온눈번호들 :Array[int]
var 났다 :bool

func string_debug() -> String:
	var s :String = ""
	for n in 지나온눈번호들:
		s += "%d " % n
	return "말(%s %d 눈[%s])" % [속한편,말번호,s]

func _to_string() -> String:
	return "%s말%d" % [속한편,말번호]

func init(t :편, 반지름 :float,높이 :float, n:int, hide_num :bool = false) -> 말:
	속한편 = t
	말번호 = n
	반지름 = 반지름*1.0 * t.인자.크기보정
	$"다각기둥".init(반지름, 높이, t.인자.색, t.인자.모양)
	$"번호".position = Vector3(반지름/2,-반지름/2,0)
	$"번호".text = "%d" % 말번호
	$"번호".visible = not hide_num
	return self

func 편얻기()->편:
	return 속한편

func 마지막눈번호()->int:
	return 지나온눈번호들[-1]

func 놓을말인가() -> bool:
	return 지나온눈번호들.size() == 0

func 난말인가() -> bool:
	return 났다

func 판위말인가() -> bool:
	return not 놓을말인가() and not 난말인가()
