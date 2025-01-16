extends MeshInstance3D

class_name 원판

func init(r :float,h :float, co :Color) -> void:
	var mesh = CylinderMesh.new()
	mesh.bottom_radius = r
	mesh.top_radius = r
	mesh.height = h
	#mesh.radial_segments = 100
	#mesh.rings = 100
	var mat = StandardMaterial3D.new()
	mat.albedo_color = co
	mesh.material = mat
	$".".mesh = mesh
	$".".rotate_x(PI/2)
