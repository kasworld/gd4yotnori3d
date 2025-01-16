extends Node3D
class_name 말판

func init(r :float, h :float) -> void:
	$"원판".init(r,h,Color.DIM_GRAY)
	$"원판".position.z = -h
