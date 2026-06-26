class_name PixelSpriteGenerator
extends RefCounted
## Generates pixel art sprite sheets for characters at runtime.
## Each frame is 32x32. Returns an ImageTexture containing a horizontal strip of frames.

const FRAME_SIZE: int = 32


## Generate player ninja sprite sheet (6 frames: idle, run1, run2, jump, attack, hurt)
static func generate_player_sheet() -> ImageTexture:
	var frames: int = 6
	var img: Image = Image.create(frames * FRAME_SIZE, FRAME_SIZE, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))  ## Transparent background

	## Colors
	var body_color: Color = Color(0.15, 0.2, 0.35, 1)      ## Dark blue outfit
	var skin_color: Color = Color(0.85, 0.7, 0.55, 1)        ## Skin tone
	var blade_color: Color = Color(0.7, 0.75, 0.8, 1)        ## Silver blade
	var eye_color: Color = Color(0.9, 0.25, 0.25, 1)         ## Red eyes
	var belt_color: Color = Color(0.5, 0.15, 0.15, 1)        ## Dark red belt

	for f in frames:
		var ox: int = f * FRAME_SIZE
		match f:
			0: _draw_player_idle(img, ox, body_color, skin_color, eye_color, belt_color)
			1: _draw_player_run(img, ox, body_color, skin_color, eye_color, belt_color, false)
			2: _draw_player_run(img, ox, body_color, skin_color, eye_color, belt_color, true)
			3: _draw_player_jump(img, ox, body_color, skin_color, eye_color, belt_color)
			4: _draw_player_attack(img, ox, body_color, skin_color, eye_color, belt_color, blade_color)
			5: _draw_player_hurt(img, ox, body_color, skin_color, eye_color, belt_color)

	return ImageTexture.create_from_image(img)


## Generate Shadow Crawler sheet (5 frames: idle, walk1, walk2, attack, hurt)
static func generate_crawler_sheet() -> ImageTexture:
	var frames: int = 5
	var img: Image = Image.create(frames * FRAME_SIZE, FRAME_SIZE, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))

	var body_color: Color = Color(0.35, 0.2, 0.1, 1)     ## Brown
	var eye_color: Color = Color(0.9, 0.8, 0.1, 1)        ## Yellow eyes
	var claw_color: Color = Color(0.25, 0.15, 0.08, 1)    ## Dark brown claws

	for f in frames:
		var ox: int = f * FRAME_SIZE
		match f:
			0: _draw_crawler_idle(img, ox, body_color, eye_color, claw_color)
			1: _draw_crawler_walk(img, ox, body_color, eye_color, claw_color, false)
			2: _draw_crawler_walk(img, ox, body_color, eye_color, claw_color, true)
			3: _draw_crawler_attack(img, ox, body_color, eye_color, claw_color)
			4: _draw_crawler_hurt(img, ox, body_color, eye_color, claw_color)

	return ImageTexture.create_from_image(img)


## Generate Wraith sheet (5 frames: idle, move1, move2, attack, hurt)
static func generate_wraith_sheet() -> ImageTexture:
	var frames: int = 5
	var img: Image = Image.create(frames * FRAME_SIZE, FRAME_SIZE, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))

	var body_color: Color = Color(0.3, 0.2, 0.55, 1)     ## Purple
	var glow_color: Color = Color(0.5, 0.35, 0.8, 0.6)    ## Purple glow
	var eye_color: Color = Color(0.2, 0.9, 0.2, 1)        ## Green eyes

	for f in frames:
		var ox: int = f * FRAME_SIZE
		match f:
			0: _draw_wraith_idle(img, ox, body_color, glow_color, eye_color)
			1: _draw_wraith_move(img, ox, body_color, glow_color, eye_color, false)
			2: _draw_wraith_move(img, ox, body_color, glow_color, eye_color, true)
			3: _draw_wraith_attack(img, ox, body_color, glow_color, eye_color)
			4: _draw_wraith_hurt(img, ox, body_color, glow_color, eye_color)

	return ImageTexture.create_from_image(img)


## -- Player frame drawing functions --

static func _draw_player_idle(img: Image, ox: int, body: Color, skin: Color, eye: Color, belt: Color) -> void:
	## Body: 12x18 rectangle centered in lower half
	_draw_rect(img, ox + 10, 12, 12, 18, body)
	## Head: 10x10 circle at top
	_draw_circle(img, ox + 16, 8, 5, skin)
	## Eyes
	_draw_pixel(img, ox + 14, 7, eye)
	_draw_pixel(img, ox + 18, 7, eye)
	## Legs: two 4x10 columns
	_draw_rect(img, ox + 10, 26, 4, 6, Color(0.1, 0.15, 0.25))
	_draw_rect(img, ox + 18, 26, 4, 6, Color(0.1, 0.15, 0.25))
	## Belt
	_draw_rect(img, ox + 10, 24, 12, 2, belt)
	## Arms at sides
	_draw_rect(img, ox + 6, 16, 3, 8, body)
	_draw_rect(img, ox + 23, 16, 3, 8, body)


static func _draw_player_run(img: Image, ox: int, body: Color, skin: Color, eye: Color, belt: Color, alt: bool) -> void:
	_draw_player_idle(img, ox, body, skin, eye, belt)
	var leg_offset: int = 3 if alt else -3
	## Animate legs
	_draw_rect(img, ox + 10, 26, 4, 6, Color(0,0,0,0))  ## Clear
	_draw_rect(img, ox + 18, 26, 4, 6, Color(0,0,0,0))  ## Clear
	_draw_rect(img, ox + 10 + leg_offset, 26, 4, 6, Color(0.1, 0.15, 0.25))
	_draw_rect(img, ox + 18 - leg_offset, 26, 4, 6, Color(0.1, 0.15, 0.25))


static func _draw_player_jump(img: Image, ox: int, body: Color, skin: Color, eye: Color, belt: Color) -> void:
	_draw_rect(img, ox + 10, 10, 12, 16, body)
	_draw_circle(img, ox + 16, 6, 5, skin)
	_draw_pixel(img, ox + 14, 5, eye)
	_draw_pixel(img, ox + 18, 5, eye)
	_draw_rect(img, ox + 10, 22, 12, 2, belt)
	## Legs up
	_draw_rect(img, ox + 8, 24, 4, 5, Color(0.1, 0.15, 0.25))
	_draw_rect(img, ox + 20, 24, 4, 5, Color(0.1, 0.15, 0.25))
	## Arms up
	_draw_rect(img, ox + 4, 12, 4, 4, body)
	_draw_rect(img, ox + 24, 12, 4, 4, body)


static func _draw_player_attack(img: Image, ox: int, body: Color, skin: Color, eye: Color, belt: Color, blade: Color) -> void:
	_draw_rect(img, ox + 10, 12, 12, 18, body)
	_draw_circle(img, ox + 16, 8, 5, skin)
	_draw_pixel(img, ox + 16, 7, eye)
	_draw_pixel(img, ox + 19, 7, eye)
	_draw_rect(img, ox + 10, 24, 12, 2, belt)
	_draw_rect(img, ox + 8, 26, 4, 6, Color(0.1, 0.15, 0.25))
	_draw_rect(img, ox + 20, 26, 4, 6, Color(0.1, 0.15, 0.25))
	## Sword arm extended
	_draw_rect(img, ox + 22, 14, 3, 6, body)
	_draw_rect(img, ox + 25, 10, 2, 18, blade)


static func _draw_player_hurt(img: Image, ox: int, body: Color, skin: Color, eye: Color, belt: Color) -> void:
	_draw_rect(img, ox + 8, 12, 12, 18, Color(0.5, 0.15, 0.15))  ## Red flash body
	_draw_circle(img, ox + 14, 8, 5, skin)
	_draw_pixel(img, ox + 13, 6, Color.WHITE)
	_draw_pixel(img, ox + 17, 6, Color.WHITE)
	_draw_rect(img, ox + 8, 24, 12, 2, belt)
	_draw_rect(img, ox + 8, 26, 4, 6, Color(0.1, 0.15, 0.25))
	_draw_rect(img, ox + 16, 26, 4, 6, Color(0.1, 0.15, 0.25))


## -- Shadow Crawler frame drawing functions --

static func _draw_crawler_idle(img: Image, ox: int, body: Color, eye: Color, claw: Color) -> void:
	## Low, wide body: 22x10
	_draw_rect(img, ox + 5, 18, 22, 10, body)
	## Head: 10x8
	_draw_rect(img, ox + 2, 14, 10, 8, claw)
	## Eyes: 2 bright pixels
	_draw_pixel(img, ox + 5, 15, eye)
	_draw_pixel(img, ox + 8, 15, eye)
	## 4 legs
	_draw_rect(img, ox + 6, 28, 3, 4, claw)
	_draw_rect(img, ox + 12, 28, 3, 4, claw)
	_draw_rect(img, ox + 18, 28, 3, 4, claw)
	_draw_rect(img, ox + 24, 28, 3, 4, claw)


static func _draw_crawler_walk(img: Image, ox: int, body: Color, eye: Color, claw: Color, alt: bool) -> void:
	_draw_crawler_idle(img, ox, body, eye, claw)
	var offset1: int = 2 if alt else -1
	var offset2: int = -1 if alt else 2
	_draw_rect(img, ox + 6, 28, 3, 4, Color(0,0,0,0))
	_draw_rect(img, ox + 18, 28, 3, 4, Color(0,0,0,0))
	_draw_rect(img, ox + 6 + offset1, 28, 3, 4, claw)
	_draw_rect(img, ox + 18 + offset2, 28, 3, 4, claw)


static func _draw_crawler_attack(img: Image, ox: int, body: Color, eye: Color, claw: Color) -> void:
	_draw_crawler_idle(img, ox, body, eye, claw)
	## Open jaws
	_draw_rect(img, ox + 0, 12, 4, 5, claw)
	_draw_rect(img, ox + 6, 12, 4, 5, claw)
	_draw_pixel(img, ox + 3, 13, Color(0.8, 0.2, 0.2))
	_draw_pixel(img, ox + 7, 13, Color(0.8, 0.2, 0.2))


static func _draw_crawler_hurt(img: Image, ox: int, body: Color, eye: Color, claw: Color) -> void:
	_draw_rect(img, ox + 5, 18, 22, 10, Color(0.6, 0.2, 0.2))
	_draw_rect(img, ox + 2, 14, 10, 8, claw)
	_draw_pixel(img, ox + 5, 15, Color.WHITE)
	_draw_pixel(img, ox + 8, 15, Color.WHITE)
	_draw_rect(img, ox + 6, 28, 3, 4, claw)
	_draw_rect(img, ox + 12, 28, 3, 4, claw)
	_draw_rect(img, ox + 18, 28, 3, 4, claw)
	_draw_rect(img, ox + 24, 28, 3, 4, claw)


## -- Wraith frame drawing functions --

static func _draw_wraith_idle(img: Image, ox: int, body: Color, glow: Color, eye: Color) -> void:
	## Ethereal floating body: 14x14
	_draw_circle(img, ox + 16, 16, 7, body)
	_draw_circle(img, ox + 16, 16, 10, glow)
	## Eyes
	_draw_pixel(img, ox + 13, 14, eye)
	_draw_pixel(img, ox + 19, 14, eye)
	## Wispy bottom
	_draw_rect(img, ox + 11, 22, 3, 6, glow)
	_draw_rect(img, ox + 18, 22, 3, 6, glow)
	_draw_rect(img, ox + 14, 24, 4, 4, glow)


static func _draw_wraith_move(img: Image, ox: int, body: Color, glow: Color, eye: Color, alt: bool) -> void:
	_draw_wraith_idle(img, ox, body, glow, eye)
	var wisp_offset: int = 2 if alt else -2
	_draw_rect(img, ox + 11, 22, 3, 6, Color(0,0,0,0))
	_draw_rect(img, ox + 18, 22, 3, 6, Color(0,0,0,0))
	_draw_rect(img, ox + 11 + wisp_offset, 22, 3, 6, glow)
	_draw_rect(img, ox + 18 - wisp_offset, 22, 3, 6, glow)


static func _draw_wraith_attack(img: Image, ox: int, body: Color, glow: Color, eye: Color) -> void:
	_draw_circle(img, ox + 16, 16, 7, body)
	_draw_circle(img, ox + 16, 16, 12, Color(0.7, 0.3, 0.9, 0.5))
	_draw_pixel(img, ox + 12, 14, Color(1, 0.3, 0.3))   ## Red eyes when attacking
	_draw_pixel(img, ox + 20, 14, Color(1, 0.3, 0.3))
	_draw_rect(img, ox + 11, 22, 3, 6, glow)
	_draw_rect(img, ox + 18, 22, 3, 6, glow)


static func _draw_wraith_hurt(img: Image, ox: int, body: Color, glow: Color, eye: Color) -> void:
	_draw_circle(img, ox + 14, 14, 6, Color(0.7, 0.2, 0.2))
	_draw_circle(img, ox + 14, 14, 9, Color(0.5, 0.1, 0.1, 0.4))
	_draw_pixel(img, ox + 12, 13, Color.WHITE)
	_draw_pixel(img, ox + 16, 13, Color.WHITE)
	_draw_rect(img, ox + 10, 20, 2, 4, Color(0.4, 0.1, 0.1, 0.3))
	_draw_rect(img, ox + 16, 20, 2, 4, Color(0.4, 0.1, 0.1, 0.3))


## -- Helper drawing primitives --

static func _draw_pixel(img: Image, x: int, y: int, color: Color) -> void:
	if x >= 0 and x < img.get_width() and y >= 0 and y < img.get_height():
		img.set_pixel(x, y, color)


static func _draw_rect(img: Image, x: int, y: int, w: int, h: int, color: Color) -> void:
	for dx in w:
		for dy in h:
			_draw_pixel(img, x + dx, y + dy, color)


static func _draw_circle(img: Image, cx: int, cy: int, r: int, color: Color) -> void:
	for dx in range(-r, r + 1):
		for dy in range(-r, r + 1):
			if dx * dx + dy * dy <= r * r:
				_draw_pixel(img, cx + dx, cy + dy, color)
