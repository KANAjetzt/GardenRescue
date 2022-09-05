extends CanvasModulate

const NIGHT_COLOR = Color("#344e52")
const DAY_COLOR = Color("#ffffff")

onready var GameWorld = get_node("/root/GameWorld")

func _ready():
	pass # Replace with function body.

func _process(delta):
	color = NIGHT_COLOR.linear_interpolate(DAY_COLOR, GameWorld.gameStore.current_time)
