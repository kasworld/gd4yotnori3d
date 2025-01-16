extends MeshInstance3D

class_name 다각기둥

func init(반지름 :float, 높이 :float, 색깔 :Color, 각수 :int = 64) -> void:
	var mesh = CylinderMesh.new()
	mesh.bottom_radius = 반지름
	mesh.top_radius = 반지름
	mesh.height = 높이
	mesh.radial_segments = 각수
	#mesh.rings = 100
	var mat = StandardMaterial3D.new()
	mat.albedo_color = 색깔
	mesh.material = mat
	$".".mesh = mesh
	$".".rotate_x(PI/2)

func set_color(co :Color) -> void:
	$".".mesh.material.albedo_color = co
