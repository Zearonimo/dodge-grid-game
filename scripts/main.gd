extends Node2D
## 게임 흐름: 타이틀 → 플레이 → 게임 오버 → 다시 플레이.
## 입력(스와이프·방향키), 장애물 생성, 난이도, 최고 기록 저장을 맡는다.

const Board := preload("res://scripts/board.gd")
const Player := preload("res://scripts/player.gd")
const Hazards := preload("res://scripts/hazards.gd")
const Ui := preload("res://scripts/ui.gd")

enum State { TITLE, PLAYING, OVER }  # ui.gd의 TITLE/PLAYING/OVER와 같은 순서

const SWIPE_MIN := 40.0  # 이만큼(px) 끌면 스와이프로 본다
const OVER_LOCK := 0.6  # 게임 오버 직후 실수로 다시 시작하지 않게
const SAVE_PATH := "user://save.cfg"

var state := State.TITLE
var elapsed := 0.0
var best := 0.0
var new_best := false
var spawn_timer := 0.0
var over_lock := 0.0

var touching := false
var swiped := false
var touch_start := Vector2.ZERO

## CI 점검용: `-- --smoke`로 실행하면 혼자 움직이며 계속 플레이한다.
var smoke := false
var smoke_timer := 0.0

var rng := RandomNumberGenerator.new()
var board: Board
var player: Player
var hazards: Hazards
var ui: Ui


func _ready() -> void:
	rng.randomize()
	RenderingServer.set_default_clear_color(Board.COLOR_BG)

	board = Board.new()
	add_child(board)
	hazards = Hazards.new()
	hazards.board = board
	add_child(hazards)
	player = Player.new()
	player.board = board
	add_child(player)
	ui = Ui.new()
	add_child(ui)

	best = _load_best()
	get_viewport().size_changed.connect(_on_resize)
	_on_resize()
	player.reset()
	_refresh_ui()

	if "--smoke" in OS.get_cmdline_user_args():
		smoke = true
		print("SMOKE: autoplay on")
		_start()


func _process(delta: float) -> void:
	over_lock = maxf(0.0, over_lock - delta)
	if smoke:
		_smoke_step(delta)
	if state != State.PLAYING:
		return

	elapsed += delta
	spawn_timer -= delta
	if spawn_timer <= 0.0:
		_spawn()
		spawn_timer = maxf(0.42, 1.3 - elapsed * 0.025)
	hazards.update(delta)
	_check_hit()
	_refresh_ui()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch
		if touch.pressed:
			touching = true
			swiped = false
			touch_start = touch.position
		else:
			if touching and not swiped:
				_on_tap()
			touching = false
	elif event is InputEventScreenDrag:
		var drag := event as InputEventScreenDrag
		if touching:
			var d := drag.position - touch_start
			if d.length() >= SWIPE_MIN:
				_on_dir(_swipe_dir(d))
				touch_start = drag.position
				swiped = true
	elif event is InputEventKey and event.is_pressed() and not event.is_echo():
		if event.is_action_pressed("ui_left"):
			_on_dir(Vector2i.LEFT)
		elif event.is_action_pressed("ui_right"):
			_on_dir(Vector2i.RIGHT)
		elif event.is_action_pressed("ui_up"):
			_on_dir(Vector2i.UP)
		elif event.is_action_pressed("ui_down"):
			_on_dir(Vector2i.DOWN)
		elif event.is_action_pressed("ui_accept"):
			_on_tap()


func _swipe_dir(d: Vector2) -> Vector2i:
	if absf(d.x) > absf(d.y):
		return Vector2i.RIGHT if d.x > 0.0 else Vector2i.LEFT
	return Vector2i.DOWN if d.y > 0.0 else Vector2i.UP


func _on_dir(dir: Vector2i) -> void:
	match state:
		State.PLAYING:
			if player.try_move(dir):
				_check_hit()
		State.TITLE:
			_start()
		State.OVER:
			_on_tap()


func _on_tap() -> void:
	if state == State.TITLE or (state == State.OVER and over_lock <= 0.0):
		_start()


func _start() -> void:
	state = State.PLAYING
	elapsed = 0.0
	new_best = false
	spawn_timer = 0.6
	hazards.clear()
	player.reset()
	_refresh_ui()


func _check_hit() -> void:
	if state != State.PLAYING or not hazards.hits(player.cell):
		return
	if smoke and elapsed < 15.0:
		return  # 점검 때는 레이저·폭탄이 나올 때까지 버틴다
	_game_over()


func _game_over() -> void:
	state = State.OVER
	player.alive = false
	over_lock = OVER_LOCK
	if elapsed > best:
		best = elapsed
		new_best = true
		_save_best()
	if smoke:
		print("SMOKE: game over at %.1f" % elapsed)
	_refresh_ui()


func _spawn() -> void:
	var warn := maxf(0.5, 1.0 - elapsed * 0.01)
	var roll := rng.randf()
	if elapsed > 8.0 and roll < 0.22:
		var axis := rng.randi_range(0, 1)
		hazards.add_laser(axis, _lane_index(axis), warn + 0.2)
	elif elapsed > 4.0 and roll < 0.5:
		var target := player.cell if rng.randf() < 0.6 else _random_cell()
		hazards.add_bomb(target, warn + 0.1)
	else:
		var axis := rng.randi_range(0, 1)
		var dir := 1 if rng.randf() < 0.5 else -1
		hazards.add_stone(axis, _lane_index(axis), dir, warn, minf(9.0, 4.0 + elapsed * 0.08))


## 절반은 플레이어가 있는 줄을 노린다.
func _lane_index(axis: int) -> int:
	if rng.randf() < 0.5:
		return player.cell.y if axis == 0 else player.cell.x
	return rng.randi_range(0, Board.SIZE - 1)


func _random_cell() -> Vector2i:
	return Vector2i(rng.randi_range(0, Board.SIZE - 1), rng.randi_range(0, Board.SIZE - 1))


func _smoke_step(delta: float) -> void:
	smoke_timer -= delta
	if smoke_timer > 0.0:
		return
	smoke_timer = 0.25
	if state == State.OVER:
		_on_tap()
		return
	var dirs: Array[Vector2i] = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]
	_on_dir(dirs[rng.randi_range(0, 3)])


func _on_resize() -> void:
	var view := get_viewport_rect().size
	board.layout(view)
	ui.view_size = view
	_refresh_ui()


func _refresh_ui() -> void:
	ui.mode = state
	ui.score = elapsed
	ui.best = best
	ui.new_best = new_best
	ui.queue_redraw()


func _load_best() -> float:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) == OK:
		return float(cfg.get_value("score", "best", 0.0))
	return 0.0


func _save_best() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("score", "best", best)
	cfg.save(SAVE_PATH)
