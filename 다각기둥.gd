extends MeshInstance3D

class_name 다각기둥

func init(반지름 :float, 높이 :float, 색깔 :Color, 각수 :int = 64) -> void:
	var msh = CylinderMesh.new()
	msh.bottom_radius = 반지름
	msh.top_radius = 반지름
	msh.height = 높이
	msh.radial_segments = 각수
	#msh.rings = 100
	var mat = StandardMaterial3D.new()
	mat.albedo_color = 색깔
	msh.material = mat
	$".".mesh = msh
	$".".rotation.x = PI/2

func set_color(co :Color) -> void:
	$".".mesh.material.albedo_color = co
