extends Node3D
class_name 말판

var 반지름 :float
var 깊이 :float

func init(반지름a :float, 깊이a :float) -> void:
	반지름 = 반지름a *1.1
	깊이 = 깊이a
	배경원판만들기(Color.DIM_GRAY)

func 배경원판만들기(원판색깔 :Color) -> void:
	var plane = Global3d.new_cylinder(깊이, 반지름, 반지름, Global3d.get_color_mat(원판색깔))
	plane.rotate_x(PI/2)
	plane.position.z = -깊이
	add_child(plane)
