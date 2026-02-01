extends Node3D

const WorldSize := Vector3(160,90,80)

func on_viewport_size_changed() -> void:
	var vp_size := get_viewport().get_visible_rect().size
	var 짧은길이 :float = min(vp_size.x, vp_size.y)
	var panel_size := Vector2(vp_size.x/2 - 짧은길이/2, vp_size.y)
	$"왼쪽패널".size = panel_size
	$"왼쪽패널".custom_minimum_size = panel_size
	$오른쪽패널.size = panel_size
	$"오른쪽패널".custom_minimum_size = panel_size
	$오른쪽패널.position = Vector2(vp_size.x/2 + 짧은길이/2, 0)


func _ready() -> void:
	on_viewport_size_changed()
	get_viewport().size_changed.connect(on_viewport_size_changed)
	$OmniLight3D.omni_range = WorldSize.length()*3
	#$CenterCameraLight.set_center_pos_far( Vector3(0, 0, -WorldSize.z), Vector3.ZERO, WorldSize.length()*3)
	$FixedCameraLight.set_center_pos_far(Vector3.ZERO, Vector3(0, 0, WorldSize.z),  WorldSize.length()*3)
	$MovingCameraLightHober.set_center_pos_far(Vector3.ZERO, Vector3(0, 0, WorldSize.z),  WorldSize.length()*3)
	$MovingCameraLightAround.set_center_pos_far(Vector3.ZERO, Vector3(0, 0, WorldSize.z),  WorldSize.length()*3)
	$AxisArrow3D.set_colors().set_size(WorldSize.length()/20)
	$GlassCabinet.init(WorldSize)

func _process(_delta: float) -> void:
	var now := Time.get_unix_time_from_system()
	if $MovingCameraLightHober.is_current_camera():
		$MovingCameraLightHober.move_hober_around_z(now/2.3, Vector3.ZERO, WorldSize.length()/2, WorldSize.length()/4 )
	elif $MovingCameraLightAround.is_current_camera():
		$MovingCameraLightAround.move_wave_around_y(now/2.3, Vector3.ZERO, WorldSize.length()/2, WorldSize.length()/4 )

func _on_카메라변경_pressed() -> void:
	MovingCameraLight.NextCamera()
func _on_끝내기_pressed() -> void:
	get_tree().quit()
func _on_fov_inc_pressed() -> void:
	MovingCameraLight.GetCurrentCamera().camera_fov_inc()
func _on_fov_dec_pressed() -> void:
	MovingCameraLight.GetCurrentCamera().camera_fov_dec()
var key2fn = {
	KEY_ESCAPE:_on_끝내기_pressed,
	KEY_ENTER:_on_카메라변경_pressed,
	KEY_PAGEUP:_on_fov_inc_pressed,
	KEY_PAGEDOWN:_on_fov_dec_pressed,
}
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		var fn = key2fn.get(event.keycode)
		if fn != null:
			fn.call()
		if $FixedCameraLight.is_current_camera():
			var fi = FlyNode3D.Key2Info.get(event.keycode)
			if fi != null:
				FlyNode3D.fly_node3d($FixedCameraLight, fi)
		#elif $CenterCameraLight.is_current_camera():
			#var fi = FlyNode3D.Key2Info.get(event.keycode)
			#if fi != null:
				#FlyNode3D.fly_node3d($CenterCameraLight, fi)
	elif event is InputEventMouseButton and event.is_pressed():
		pass
