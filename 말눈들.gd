extends Node3D
class_name 말눈들

const 눈사이각도 = 360.0/20.0
var 눈_scene = preload("res://눈.tscn")
var 눈들 :Array[눈]

func init(반지름: float, co :Color) -> void:
	var 눈반지름 = max(10,반지름/30)

	# 눈 추가하기
	for i in range(눈사이각도,360+눈사이각도,눈사이각도):
		var rd = deg_to_rad(i)
		var pos = Vector3(sin(rd)*반지름, 0, cos(rd)*반지름) # PolygonNode.make_pos_by_rad_r_3d(rd,반지름)
		눈추가(눈반지름, pos, co)

	for i in [0.66,0.33,0,-0.33,-0.66]:
		눈추가(눈반지름, Vector3(반지름*i,0,0),co)

	for i in [-0.66,-0.33,0.33,0.66]:
		눈추가(눈반지름, Vector3(0,0,반지름*i),co)

func 눈추가(눈반지름: float, pos:Vector3, co:Color):
	var 눈1 = 눈_scene.instantiate()
	눈1.init(눈반지름, co, 눈들.size())
	눈1.position = pos
	#print(pos)
	add_child(눈1)
	눈들.append(눈1)

func 눈얻기(눈번호 :int)->눈:
	return 눈들[눈번호]

func 눈번호보기(b :bool):
	for n in 눈들:
		n.눈번호보기(b)
