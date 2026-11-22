extends Node2D
## 장애물 세 가지. 모두 "경고 → 작동 → 사라짐" 순서로 움직인다.
## - 돌(STONE): 줄 끝 화살표로 경고한 뒤 그 줄을 따라 굴러간다.
## - 레이저(LASER): 줄 전체가 깜빡인 뒤 잠깐 줄 전체를 친다.
## - 폭탄(BOMB): 칸에 조준 표시가 좁혀진 뒤 그 칸이 터진다.

const Board := preload("res://scripts/board.gd")

enum Kind { STONE, LASER, BOMB }

const LASER_TIME := 0.35
const BLAST_TIME := 0.3
const STONE_HIT := 0.6  # 돌 중심과 이 거리(칸) 안이면 맞음

const COLOR_WARN := Color("ffcc4d")
const COLOR_STONE := Color("b8a58c")
const COLOR_LASER := Color("ff4d6d")
const COLOR_BLAST := Color("ff8c42")


class Hazard:
	var kind := 0
	var axis := 0  # 0: 가로줄(왼↔오), 1: 세로줄(위↔아래)
	var index := 0  # 몇 번째 줄인지
	var dir := 1  # 돌이 굴러가는 방향 (+1 / -1)
	var cell := Vector2i.ZERO  # 폭탄이 떨어질 칸
	var warn := 1.0  # 경고 시간(초)
	var speed := 4.0  # 돌 속도(칸/초)
	var timer := 0.0
	var pos := -1.0  # 돌이 출발점에서 굴러간 거리(칸)
	var active := false
	var done := false


var board: Board
var items: Array = []
var _blink := 0.0


func clear() -> void:
	items.clear()
	queue_redraw()


func add_stone(axis: int, index: int, dir: int, warn: float, speed: float) -> void:
	var h := Hazard.new()
	h.kind = Kind.STONE
	h.axis = axis
	h.index = index
	h.dir = dir
	h.warn = warn
	h.speed = speed
	items.append(h)


func add_laser(axis: int, index: int, warn: float) -> void:
	var h := Hazard.new()
	h.kind = Kind.LASER
	h.axis = axis
	h.index = index
	h.warn = warn
	items.append(h)


func add_bomb(cell: Vector2i, warn: float) -> void:
	var h := Hazard.new()
	h.kind = Kind.BOMB
	h.cell = cell
	h.warn = warn
	items.append(h)


func update(delta: float) -> void:
	_blink += delta
	for h: Hazard in items:
		h.timer += delta
		if not h.active:
			if h.timer >= h.warn:
				h.active = true
				h.timer = 0.0
			continue
		match h.kind:
			Kind.STONE:
				h.pos += h.speed * delta
				if h.pos > Board.SIZE:
					h.done = true
			Kind.LASER:
				if h.timer >= LASER_TIME:
					h.done = true
			Kind.BOMB:
				if h.timer >= BLAST_TIME:
					h.done = true
	items = items.filter(func(h: Hazard) -> bool: return not h.done)
	queue_redraw()


func hits(cell: Vector2i) -> bool:
	for h: Hazard in items:
		if not h.active:
			continue
		var along := cell.x if h.axis == 0 else cell.y
		var across := cell.y if h.axis == 0 else cell.x
		match h.kind:
			Kind.STONE:
				if across == h.index and absf(_stone_coord(h) - along) < STONE_HIT:
					return true
			Kind.LASER:
				if across == h.index:
					return true
			Kind.BOMB:
				if cell == h.cell:
					return true
	return false


## 돌의 실제 줄 위 좌표 (칸 단위, 0이 왼쪽/위)
func _stone_coord(h: Hazard) -> float:
	return h.pos if h.dir == 1 else float(Board.SIZE - 1) - h.pos


func _lane_point(h: Hazard, t: float) -> Vector2:
	return board.point_at(Vector2(t, h.index) if h.axis == 0 else Vector2(h.index, t))


func _axis_vec(h: Hazard) -> Vector2:
	return Vector2.RIGHT if h.axis == 0 else Vector2.DOWN


func _draw() -> void:
	if board == null:
		return
	var on := fmod(_blink, 0.2) < 0.12  # 경고 깜빡임
	for h: Hazard in items:
		match h.kind:
			Kind.STONE:
				_draw_stone(h, on)
			Kind.LASER:
				_draw_laser(h, on)
			Kind.BOMB:
				_draw_bomb(h)


func _draw_stone(h: Hazard, on: bool) -> void:
	if not h.active:
		if on:
			var start := -1.0 if h.dir == 1 else float(Board.SIZE)
			_draw_arrow(_lane_point(h, start), _axis_vec(h) * h.dir, board.step * 0.55, COLOR_WARN)
		return
	var p := _lane_point(h, _stone_coord(h))
	draw_circle(p, board.step * 0.36, COLOR_STONE)
	draw_circle(p - Vector2(0.1, 0.1) * board.step, board.step * 0.1, COLOR_STONE.lightened(0.35))


func _draw_laser(h: Hazard, on: bool) -> void:
	var r := board.lane_rect(h.axis, h.index)
	if not h.active:
		draw_rect(r, Color(COLOR_LASER, 0.28 if on else 0.1))
		if on:
			var d := _axis_vec(h)
			_draw_arrow(_lane_point(h, -1.0), d, board.step * 0.45, COLOR_LASER)
			_draw_arrow(_lane_point(h, float(Board.SIZE)), -d, board.step * 0.45, COLOR_LASER)
		return
	var a := 1.0 - h.timer / LASER_TIME
	draw_rect(r.grow(board.gap * 0.5), Color(COLOR_LASER, 0.4 + 0.6 * a))
	draw_rect(r.grow(-board.step * 0.3), Color(1, 1, 1, a))


func _draw_bomb(h: Hazard) -> void:
	var r := board.cell_rect(h.cell)
	if not h.active:
		var k := clampf(h.timer / h.warn, 0.0, 1.0)
		draw_rect(r, Color(COLOR_WARN, 0.12 + 0.25 * k))
		draw_rect(r.grow(board.step * 0.5 * (1.0 - k)), COLOR_WARN, false, 4.0)
		return
	var a := 1.0 - h.timer / BLAST_TIME
	draw_rect(r.grow(board.gap), Color(COLOR_BLAST, a))


func _draw_arrow(center: Vector2, d: Vector2, s: float, color: Color) -> void:
	var perp := Vector2(-d.y, d.x)
	var tip := center + d * s * 0.5
	var back := center - d * s * 0.5
	draw_colored_polygon(PackedVector2Array([tip, back + perp * s * 0.5, back - perp * s * 0.5]), color)
