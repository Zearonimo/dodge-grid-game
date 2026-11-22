extends Node2D
## 플레이어: 한 번에 한 칸씩 움직인다. 판정은 cell, 그림은 부드럽게 따라간다.

const Board := preload("res://scripts/board.gd")

const START_CELL := Vector2i(2, 3)
const COLOR_BODY := Color("4dd6ff")
const COLOR_CORE := Color("e8fbff")
const COLOR_DEAD := Color("ff4d6d")

var board: Board
var cell := START_CELL
var alive := true
var _draw_pos := Vector2(START_CELL)


func reset() -> void:
	cell = START_CELL
	_draw_pos = Vector2(cell)
	alive = true
	queue_redraw()


func try_move(dir: Vector2i) -> bool:
	var next := cell + dir
	if next.x < 0 or next.y < 0 or next.x >= Board.SIZE or next.y >= Board.SIZE:
		return false
	cell = next
	return true


func _process(delta: float) -> void:
	_draw_pos = _draw_pos.lerp(Vector2(cell), minf(1.0, delta * 25.0))
	queue_redraw()


func _draw() -> void:
	if board == null:
		return
	var p := board.point_at(_draw_pos)
	var r := board.step * 0.32
	draw_circle(p, r, COLOR_BODY if alive else COLOR_DEAD)
	draw_circle(p, r * 0.45, COLOR_CORE)
