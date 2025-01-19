extends Node3D

@onready var 편통 = $"오른쪽패널/편들상태/내용"
@onready var 진행사항 = $"왼쪽패널/ScrollContainer/진행사항"
@onready var 윷짝1 = $"오른쪽패널/윷짝"

var 편_scene = preload("res://편.tscn")

var 편들 :Array[편]
var vp_size :Vector2
var 판반지름 :float

func _ready() -> void:
	Settings.놀이횟수 +=1
	$"왼쪽패널/Label".text = "진행사항 (놀이횟수 %d)" % Settings.놀이횟수
	vp_size = get_viewport().get_visible_rect().size
	RenderingServer.set_default_clear_color( Global3d.colors.default_clear)

	판반지름 = min(vp_size.x,vp_size.y)/2
	var depth = 판반지름/40

	reset_camera_pos()
	$DirectionalLight3D.position = Vector3(판반지름,판반지름,판반지름)
	$DirectionalLight3D.look_at(Vector3.ZERO)
	$OmniLight3D.position = Vector3(판반지름,-판반지름,판반지름)
	$"말판/원판".init(판반지름, depth, Color.DIM_GRAY, 20)
	$"말판/원판".position.z = -depth/2-1
	$"말판/말눈들".init(판반지름*0.95, depth, Color.GRAY)
	$"말판/말눈들".position.z = -depth/2

	$"말판/달말통".init(판반지름/4, depth, Color.CYAN,64,0.9).설명달기("달말통",Vector3(0,판반지름/3.5,0), Color.CYAN)
	$"말판/달말통".position = Vector3(-판반지름/3,판반지름/3, -depth/2)
	$"말판/난말통".init(판반지름/4, depth, Color.HOT_PINK,64,0.9).설명달기("난말통",Vector3(0,판반지름/3.5,0), Color.HOT_PINK)
	$"말판/난말통".position = Vector3(판반지름/3,판반지름/3, -depth/2)

	var r = min(vp_size.x,vp_size.y)/2
	$"왼쪽패널".size = Vector2(vp_size.x/2 -r, vp_size.y)
	$오른쪽패널.size = Vector2(vp_size.x/2 -r, vp_size.y)
	$오른쪽패널.position = Vector2(vp_size.x/2 + r, 0)

	윷짝1.init()

	Settings.편인자들.shuffle()
	# 편 가르기
	for ti in Settings.편인자들:
		var t = 편_scene.instantiate()
		편통.add_child(t)
		var 시작눈 = 말이동길.가능한시작눈목록.pick_random()
		var mirror = randi_range(0,1)==0
		t.init(ti,Settings.편당말수, 판반지름, $"말판/말눈들", 시작눈, mirror)
		편들.append(t)
		$"말판".add_child(t.길)
		t.길단추.pressed.connect(
			func():
				self.말이동길보이기(t)
				)
		$"말판/달말통".말들넣기(t.말들)

	$"오른쪽패널/자동진행".button_pressed = Settings.자동진행
	$"오른쪽패널/길보기".button_pressed = Settings.모든길보기
	$"오른쪽패널/눈번호보기".button_pressed = Settings.눈번호보기
	$"오른쪽패널/HBoxContainer/HSlider".value = Settings.말빠르기
	차례준비하기(0)
	if Settings.자동진행:
		윷던지기()

func 말이동길보이기(t:편) ->void:
	if Settings.모든길보기:
		말이동길모두보기()
	else:
		for i in 편들:
			i.길.visible = false
		t.길.visible = true
		t.길.position = Vector3.ZERO

func 말이동길모두보기() ->void:
	var deg_start = 30.0
	var deg_inc = 360.0 / 편들.size()
	var r = min(vp_size.x,vp_size.y)/2 * 0.03
	var i = 0
	for t in 편들:
		t.길.visible = true
		var rd = deg_to_rad( deg_start + i*deg_inc)
		t.길.position = Vector3(sin(rd)*r, cos(rd)*r, 0)
		i+=1

func 눈번호들을좌표로(눈번호들 :Array[int])->Array[Vector3]:
	var 좌표들 :Array[Vector3] = []
	for i in 눈번호들:
		좌표들.append($"말판/말눈들".눈들[i].position )
	return 좌표들

var 이번윷던질편번호 =0
var 난편들 :Array[편]
func 다음편차례준비하기():
	while true:
		if 난편들.size() == Settings.편인자들.size(): # 모든 편이 다 났다.
			놀이가끝났다()
			return
		이번윷던질편번호 +=1
		이번윷던질편번호 %= 편들.size()
		if 편들[이번윷던질편번호].모든말이났나():
			if 난편들.find(편들[이번윷던질편번호]) == -1:
				난편들.append(편들[이번윷던질편번호])
				편들[이번윷던질편번호].등수쓰기(난편들.size())
			continue
		차례준비하기(이번윷던질편번호)
		break

func 놀이가끝났다() -> void:
	진행사항.text = "놀이가 끝났습니다.\n" + 진행사항.text
	if Settings.자동진행:
		_on_놀이재시작_pressed()

func 차례준비하기(편번호 :int):
	말이동길보이기(편들[편번호])
	$"오른쪽패널/윷던지기".modulate = 편들[편번호].인자.색
	$"오른쪽패널/윷던지기".text = "%s\n윷던지기" % 편들[편번호]

func 윷던지기() -> void:
	if 난편들.size() == Settings.편인자들.size(): # 모든 편이 다 났다.
		놀이가끝났다()
		return
	윷짝1.윷던지기()
	var 윷던진편 = 편들[이번윷던질편번호]
	진행사항.text = "%d %s %s\n" % [윷짝1.던진횟수얻기(), 윷던진편 , 윷짝1 ] + 진행사항.text
	if 윷짝1.한번더던지나():
		진행사항.text = "    %s 던저서 한번더 던진다. \n" % [ 윷짝1 ] + 진행사항.text
	말이동하기()
var 이동결과g :이동결과
func 말이동하기() -> void:
	var 윷던진편 = 편들[이번윷던질편번호]
	var m = 윷던진편.쓸말고르기(윷짝1)
	if m != null and m.놓을말인가():
		$"말판/달말통".말빼기(m)

	이동결과g = 윷던진편.말쓰기(윷짝1, m)
	이동결과g.다음편으로넘어가나 = (not 윷짝1.한번더던지나()) and 이동결과g.잡힌말들.size() == 0
	if not 이동결과g.성공:
		진행사항.text = "%d %s %s 이동할 말이 없습니다.\n" % [윷짝1.던진횟수얻기(), 윷던진편 , 윷짝1 ] + 진행사항.text
		이동애니메이션후처리하기()
		return
	var 좌표들 = 눈번호들을좌표로(이동결과g.말이동과정눈번호)
	if 이동결과g.새로단말 != null:
		좌표들.push_front(윷던진편.길.놓을길시작 )
	if 이동결과g.놓을말로돌아간말들.size() != 0:
		진행사항.text = "    %s 놓을말로되돌아갔습니다.\n" % [이동결과g.놓을말로돌아간말들 ] + 진행사항.text
		좌표들.push_back(윷던진편.길.놓을길시작 )
		$"말판/달말통".말들넣기(이동결과g.놓을말로돌아간말들)
	if 이동결과g.난말들.size() != 0:
		진행사항.text = "    %s 났습니다.\n" % [이동결과g.난말들 ] + 진행사항.text
		좌표들.push_back(윷던진편.길.나는길끝 )
		$"말판/난말통".말들넣기(이동결과g.난말들)
	if 이동결과g.잡힌말들.size() != 0 :
		진행사항.text = "    %s 을 잡아 한번더 던진다. \n" % [ 이동결과g.잡힌말들 ] + 진행사항.text
		$"말판/달말통".말들넣기(이동결과g.잡힌말들)
	$"오른쪽패널/윷던지기".disabled = true
	이동애니메니션하기(윷던진편,좌표들)

func 이동애니메니션하기(t :편, 이동좌표들 :Array[Vector3]):
	$"말판/말이동AnimationPlayer".stop()
	var 말이동 = $"말판/말이동AnimationPlayer".get_animation("말이동")
	말이동.length = $"오른쪽패널/HBoxContainer/HSlider".value * 이동좌표들.size()
	for i in 말이동.track_get_key_count(0) :
		말이동.track_remove_key(0,0)
	for i in 이동좌표들.size():
		말이동.track_insert_key(0, $"오른쪽패널/HBoxContainer/HSlider".value * i, 이동좌표들[i])
	var r = min(vp_size.x,vp_size.y)/2 *0.9 / 30
	$"말판/이동용말통".init(r, r/4, Color.BLACK )
	$"말판/이동용말통".visible = true
	$"말판/말이동AnimationPlayer".play("말이동")

func 이동애니메이션후처리하기() -> void:
	$"말판/이동용말통".visible = false
	if 이동결과g.다음편으로넘어가나:
		다음편차례준비하기()
	if Settings.자동진행:
		윷던지기.call_deferred()
	else:
		$"오른쪽패널/윷던지기".disabled = false

func _on_말이동animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "말이동":
		이동애니메이션후처리하기()

func _on_윷던지기_pressed() -> void:
	윷던지기()

func _on_자동진행_toggled(toggled_on: bool) -> void:
	Settings.자동진행 = toggled_on
	if Settings.자동진행:
		윷던지기()

func _on_길보기_toggled(toggled_on: bool) -> void:
	Settings.모든길보기 = toggled_on
	말이동길보이기(편들[이번윷던질편번호])

func _on_눈번호보기_toggled(toggled_on: bool) -> void:
	Settings.눈번호보기 = toggled_on
	$"말판/말눈들".눈번호보기(Settings.눈번호보기)

var 재시작중 :bool
func _on_놀이재시작_pressed() -> void:
	if 재시작중:
		return
	재시작중 = true
	$"말판/말이동AnimationPlayer".stop()
	Settings.말빠르기 = $"오른쪽패널/HBoxContainer/HSlider".value
	get_tree().reload_current_scene()

func reset_camera_pos()->void:
	$Camera3D.position = Vector3(1,1,판반지름*1)
	$Camera3D.look_at(Vector3.ZERO)

var camera_move = false
func _process(_delta: float) -> void:
	var t = Time.get_unix_time_from_system() /-3.0
	if camera_move:
		$Camera3D.position = Vector3(sin(t)*판반지름, cos(t)*판반지름, 판반지름*0.6  )
		$Camera3D.look_at(Vector3(sin(t)*판반지름/2, cos(t)*판반지름/2, 0) )
		#$Camera3D.look_at(Vector3.ZERO)

# esc to exit
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			_on_끝내기_pressed()
		elif event.keycode == KEY_ENTER:
			_on_시야바꾸기_pressed()

func _on_시야바꾸기_pressed() -> void:
	camera_move = !camera_move
	if camera_move == false:
		reset_camera_pos()

func _on_끝내기_pressed() -> void:
	get_tree().quit()
