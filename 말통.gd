extends Node3D

class_name 말통

var 반지름 :float
var 높이 :float

func init(반지름a :float, 높이a :float, 색깔 :Color, 각수 :int = 64) -> void:
	반지름 = 반지름a
	높이 = 높이a
	$"모양".init(반지름, 높이, 색깔, 각수)

func 말들넣기(넣을말들 :Array[말]) -> void:
	for m in 넣을말들:
		말넣기(m)

func 말넣기(넣을말 :말) -> void:
	$"말들".add_child(넣을말)
	넣을말.position = Vector3(randfn(0,반지름/4),randfn(0,반지름/4), randfn(높이, 높이/2) )

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
