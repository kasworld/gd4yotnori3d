extends Node3D

@onready var 놀이_scene = preload("res://윷놀이.tscn")

var 현재놀이 :윷놀이
func _ready() -> void:
	놀이시작()

func 놀이시작() -> void:
	현재놀이 =  놀이_scene.instantiate()
	현재놀이.놀이종료.connect(놀이재시작)
	add_child(현재놀이)


func 놀이재시작() -> void:
	if 현재놀이 != null:
		#현재놀이.놀이종료.disconnect()
		현재놀이.queue_free()
	놀이시작()
