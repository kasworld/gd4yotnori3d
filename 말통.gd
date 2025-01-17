extends Node3D

class_name 말통

var 반지름 :float
var 높이 :float
var 넣을크기비율 :float = 1.0

func init(반지름a :float, 높이a :float, 색깔 :Color, 각수 := 64, 배치비율 := 1.0, 설명 :String = "",설명위치 :=Vector3.ZERO ) -> 말통:
	반지름 = 반지름a
	높이 = 높이a
	$"모양".init(반지름, 높이, 색깔, 각수)
	넣을크기비율바꾸기(배치비율)
	if 설명 != "" :
		설명달기(설명, 설명위치)
	return self

func 넣을크기비율바꾸기(새비율 :float) -> void:
	넣을크기비율 = 새비율

func 설명달기(설명 :String, 위치 := Vector3.ZERO) -> void:
	$"설명".text = 설명
	$"설명".position = 위치

func 설명보기(b :bool) -> void:
	$"설명".visible = b

func 말들넣기(넣을말들 :Array[말]) -> void:
	for m in 넣을말들:
		말넣기(m)

func 말넣기(넣을말 :말) -> void:
	$"말들".add_child(넣을말)
	넣을말.position = rand_circle(반지름*넣을크기비율, 높이)

func 말모두빼기() -> Array[말]:
	var rtn :Array[말]
	for m in $"말들".get_children():
		rtn.append(m)
		$"말들".remove_child(m)
	return rtn

func 말빼기(m :말) -> void:
	$"말들".remove_child(m)

func 말보기() -> Array[말]:
	var rtn :Array[말]
	for m in $"말들".get_children():
		rtn.append(m)
	return rtn

func rand_circle(r :float, h :float) -> Vector3:
	var l = randf_range(0,r)
	var rad = randf_range(0,2*PI)
	return Vector3(sin(rad)*l, cos(rad)*l, randf_range(h/2,h))
