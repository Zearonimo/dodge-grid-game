extends Node2D
## 점수와 화면 전환(타이틀, 게임 오버). 맨 위에 그린다.
## 기본 폰트에 한글이 없어서 화면 글자는 영어로 둔다.

const TITLE := 0
const PLAYING := 1
const OVER := 2

const COLOR_TEXT := Color("e8e8f0")
const COLOR_DIM := Color("8a8fa8")
const COLOR_ACCENT := Color("4dd6ff")
const COLOR_GOLD := Color("ffcc4d")
const COLOR_SHADE := Color(0.05, 0.05, 0.1, 0.7)

var view_size := Vector2(720, 1280)
var mode := TITLE
var score := 0.0
var best := 0.0
var new_best := false


func _draw() -> void:
	var h := view_size.y
	if mode != TITLE:
		_text("%.1f" % score, h * 0.12, 72, COLOR_TEXT)
		_text("BEST %.1f" % best, h * 0.12 + 48, 26, COLOR_DIM)

	if mode == TITLE:
		draw_rect(Rect2(Vector2.ZERO, view_size), COLOR_SHADE)
		_text("DODGE GRID", h * 0.34, 84, COLOR_ACCENT)
		_text("Swipe or use arrow keys to move", h * 0.34 + 72, 28, COLOR_TEXT)
		_text("Dodge stones, lasers and bombs", h * 0.34 + 112, 28, COLOR_DIM)
		if best > 0.0:
			_text("BEST %.1f" % best, h * 0.56, 32, COLOR_GOLD)
		_text("Tap to start", h * 0.66, 44, COLOR_TEXT)
	elif mode == OVER:
		draw_rect(Rect2(Vector2.ZERO, view_size), COLOR_SHADE)
		_text("GAME OVER", h * 0.38, 80, COLOR_TEXT)
		_text("%.1f sec" % score, h * 0.38 + 70, 40, COLOR_ACCENT)
		if new_best:
			_text("NEW BEST!", h * 0.38 + 120, 34, COLOR_GOLD)
		_text("Tap to retry", h * 0.66, 44, COLOR_TEXT)


func _text(s: String, y: float, size: int, color: Color) -> void:
	draw_string(ThemeDB.fallback_font, Vector2(0, y), s, HORIZONTAL_ALIGNMENT_CENTER, view_size.x, size, color)
