extends Node3D
class_name 말판

var 반지름 :float
var 깊이 :float

func init(반지름a :float, 깊이a :float) -> void:
	반지름 = 반지름a *1.1
	깊이 = 깊이a
	배경원판만들기(Color.DIM_GRAY)
	#중앙장식만들기(Color.GOLD, Color.GOLDENROD)

func 배경원판만들기(원판색깔 :Color) -> void:
	var plane = Global3d.new_cylinder(깊이, 반지름, 반지름, Global3d.get_color_mat(원판색깔))
	plane.rotate_x(PI/2)
	plane.position.z = -깊이
	add_child(plane)

func 중앙장식만들기(색깔1 :Color, 색깔2 :Color) -> void:
	var 원판반지름 = 반지름
	var cc = Global3d.new_cylinder(깊이, 원판반지름*0.04, 원판반지름*0.04, Global3d.get_color_mat(색깔1))
	cc.position.y = 깊이/2
	add_child(cc)
	var cc2 = Global3d.new_torus(원판반지름*0.1, 원판반지름*0.06, Global3d.get_color_mat(색깔2))
	cc2.position.y = 깊이/2
	add_child(cc2)
