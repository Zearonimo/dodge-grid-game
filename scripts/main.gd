extends Node2D
## 첫 화면: "준비 중" 문구와 6x6 격자만 그린다.

const GRID_SIZE := 6
const CELL := 96.0
const GAP := 8.0

const COLOR_BG := Color("1b1d2a")
const COLOR_CELL := Color("2e3247")
const COLOR_TEXT := Color("e8e8f0")


func _ready() -> void:
	get_viewport().size_changed.connect(queue_redraw)


func _draw() -> void:
	var view := get_viewport_rect().size
	var board := GRID_SIZE * CELL + (GRID_SIZE - 1) * GAP
	var origin := (view - Vector2(board, board)) / 2.0

	draw_rect(Rect2(Vector2.ZERO, view), COLOR_BG)
	for y in GRID_SIZE:
		for x in GRID_SIZE:
			var pos := origin + Vector2(x, y) * (CELL + GAP)
			draw_rect(Rect2(pos, Vector2(CELL, CELL)), COLOR_CELL)

	# 기본 폰트에는 한글이 없어서 웹에서 깨진다. 한글 UI는 폰트를 넣은 뒤에 쓴다.
	var font := ThemeDB.fallback_font
	draw_string(font, Vector2(0, origin.y - 60), "Getting ready...",
			HORIZONTAL_ALIGNMENT_CENTER, view.x, 40, COLOR_TEXT)
