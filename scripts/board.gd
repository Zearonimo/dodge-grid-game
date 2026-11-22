extends Node2D
## 6x6 격자의 크기·위치 계산과 바닥 그리기.
## 좌표는 "칸 단위"(Vector2, 0~5)를 point_at()으로 화면 좌표로 바꿔 쓴다.

const SIZE := 6

const COLOR_BG := Color("1b1d2a")
const COLOR_BOARD := Color("23263a")
const COLOR_CELL := Color("2e3247")

var view_size := Vector2(720, 1280)
var top_left := Vector2.ZERO
var step := 96.0  # 칸 하나의 간격 (칸 + 틈)
var gap := 8.0


func layout(view: Vector2) -> void:
	view_size = view
	# 양옆에 경고 화살표가 들어갈 여백을 남긴다.
	var board_px: float = minf(view.x * 0.78, view.y * 0.55)
	step = board_px / SIZE
	gap = step * 0.08
	top_left = Vector2((view.x - board_px) / 2.0, (view.y - board_px) / 2.0 + view.y * 0.03)
	queue_redraw()


func point_at(c: Vector2) -> Vector2:
	return top_left + (c + Vector2(0.5, 0.5)) * step


func cell_rect(c: Vector2i) -> Rect2:
	var half := (step - gap) / 2.0
	var center := point_at(Vector2(c))
	return Rect2(center - Vector2(half, half), Vector2(half, half) * 2.0)


## axis 0 = 가로줄(index는 y), axis 1 = 세로줄(index는 x) 전체 영역
func lane_rect(axis: int, index: int) -> Rect2:
	var first := Vector2i(0, index) if axis == 0 else Vector2i(index, 0)
	var last := Vector2i(SIZE - 1, index) if axis == 0 else Vector2i(index, SIZE - 1)
	return cell_rect(first).merge(cell_rect(last))


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, view_size), COLOR_BG)
	var board_px := step * SIZE
	draw_rect(Rect2(top_left, Vector2(board_px, board_px)).grow(gap), COLOR_BOARD)
	for y in SIZE:
		for x in SIZE:
			draw_rect(cell_rect(Vector2i(x, y)), COLOR_CELL)
