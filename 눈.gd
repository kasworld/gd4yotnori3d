extends Node3D
class_name 눈

var 번호 :int

func _to_string() -> String:
	return "눈%d" % 번호

func init(반지름 :float, 높이 :float, 색깔: Color, n:int) -> void:
	self.번호 = n
	$"원판".init(반지름,높이,색깔)
	#$"원판".position.z = -r/2
	$"번호".text = "%d" % 번호
	$"번호".position = Vector3(반지름,-반지름,0)

func 말놓기(놓을말들 :Array)->Array[말]:
	var 있던말들 :Array[말]
	if 놓을말들.size() == 0 :
		print("문제:놓을말들이 비어있습니다.", 번호)
		return 있던말들
	if $"말들".get_child_count() != 0 and $"말들".get_children()[0].편얻기() != 놓을말들[0].편얻기():
		있던말들 = 말빼기()

	for m in 놓을말들:
		$"말들".add_child(m)
		if $"말들".get_child_count() != 0:
			m.지나온눈번호들 = $"말들".get_children()[0].지나온눈번호들
	return 있던말들

func 말빼기()->Array[말]:
	var rtn :Array[말]
	for m in $"말들".get_children():
		rtn.append(m)
		$"말들".remove_child(m)
	return rtn

func 말보기()->Array[말]:
	var rtn :Array[말]
	for m in $"말들".get_children():
		rtn.append(m)
	return rtn

func 눈번호보기(b :bool):
	$"번호".visible = b
