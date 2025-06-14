@tool
extends Node
class_name ProceduralGeneration

var GenerationThread: Thread

@export_tool_button("Generate")
var call: Callable = func():
	call_deferred("generate")
	delete()
@export_category("grass")
@export var grass_enable: bool
@export var grass_min: float = 0
@export var grass_max: float = 0

@export_category("rock")
@export var rock_enable: bool
@export var rock_min: float = 0
@export var rock_max: float = 0

@export_category("water")
@export var water_enable: bool
@export var water_min: float = 0
@export var water_max: float = 0

@export_category("snow")
@export var snow_enable: bool
@export var snow_min: float = 0
@export var snow_max: float = 0

@export_category("gried")
@export var hex_model: PackedScene = null
@export var hex_radius: float = 1
@export var hex_height: float = 1
@export var hex_height_variant: float = 0.5
@export var rows: float = 5
@export var cols: float = 5

@export_category("noise")
@export var height_scale: float = 1
var noise: Noise
@export var loaded_cells: Dictionary = {}
@export_enum("FastNoiseLite.TYPE_PERLIN", "FastNoiseLite.TYPE_SIMPLEX", "FastNoiseLite.TYPE_VALUE_CUBIC", "FastNoiseLite.TYPE_SIMPLEX_SMOOTH") var noise_typed

func _ready() -> void:
	GenerationThread = Thread.new()

func generate():
		noise = FastNoiseLite.new()
		noise.seed = randi()
		noise.fractal_gain = 10
		noise.fractal_octaves = 5
		noise.fractal_weighted_strength = 4.5
		noise.noise_type = noise_typed
		for row in range(rows):
			for col in range(cols):
				var x = col * (hex_radius * 1.5)
				var z = row * hex_height + (col % 2) * (hex_height * 0.5)
				#var y = randf_range(-hex_height_variant, hex_height_variant)
				var y = noise.get_noise_2d(col * height_scale, row * height_scale)
				var cells = Vector3(x, y, z)
				if not loaded_cells.has(cells):
					var instance = hex_model.instantiate()
					instance.transform.origin = Vector3(x, y, z)
					call_deferred("add_child", instance)
					loaded_cells[cells] = instance

#rock___________________
					if y > rock_min and y < rock_max and rock_enable and snow_enable and grass_enable and water_enable:
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Rock/rock.tres"))
					elif y > rock_min and rock_enable and water_enable and grass_enable and !snow_enable:
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Rock/rock.tres"))
					elif y > grass_min and rock_enable and water_enable and !snow_enable and !grass_enable :
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Rock/rock.tres"))
					elif rock_enable and !grass_enable and !water_enable and !snow_enable:
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Rock/rock.tres"))
					elif y > rock_min and y < rock_max and rock_enable and snow_enable and grass_enable and !water_enable:
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Rock/rock.tres"))
					elif y < snow_min and y < rock_max and rock_enable and snow_enable and !grass_enable and !water_enable:
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Rock/rock.tres"))
					elif y > rock_min and rock_enable and grass_enable and !water_enable and !snow_enable:
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Rock/rock.tres"))
#water__________________
					if y < water_max and water_enable and rock_enable and grass_enable and snow_enable:
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Water/water.tres"))
					elif y < water_max and water_enable and rock_enable and !grass_enable and snow_enable:
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Water/water.tres"))
					elif y < water_max and water_enable and rock_enable and !grass_enable and !snow_enable:
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Water/water.tres"))
					elif y < water_max and water_enable and !rock_enable and !grass_enable and snow_enable:
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Water/water.tres"))
					elif y < water_max and water_enable and !rock_enable and grass_enable and !snow_enable:
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Water/water.tres"))
					elif y < water_max and water_enable and rock_enable and grass_enable and !snow_enable:
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Water/water.tres"))
					elif y < water_max and water_enable and !rock_enable and grass_enable and snow_enable:
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Water/water.tres"))
					elif !grass_enable and !rock_enable and water_enable and !snow_enable:
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Water/water.tres"))
#snow___________________
					if y >= snow_min and y <= snow_max and rock_enable and snow_enable and water_enable and grass_enable:
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Snow/snow.tres"))
					elif y >= snow_min and y <= snow_max and rock_enable and snow_enable and water_enable and !grass_enable:
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Snow/snow.tres"))
					elif y >= snow_min and y <= snow_max and rock_enable and snow_enable and !water_enable and !grass_enable:
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Snow/snow.tres"))
					elif y <= snow_max and !rock_enable and snow_enable and !water_enable and !grass_enable:
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Snow/snow.tres"))
					elif y >= snow_min and y <= snow_max and rock_enable and snow_enable and !water_enable and grass_enable:
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Snow/snow.tres"))
					elif y >= snow_min and y <= snow_max and !rock_enable and snow_enable and !water_enable and grass_enable:
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Snow/snow.tres"))
					elif y >= snow_min and y <= snow_max and !rock_enable and snow_enable and !water_enable and grass_enable:
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Snow/snow.tres"))
					elif !rock_enable and snow_enable and !water_enable and !grass_enable:
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Snow/snow.tres"))
#grass__________________
					if y >= grass_min and y <= grass_max and rock_enable and grass_enable and water_enable and snow_enable:
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Grass/grass.tres"))
					elif y <= grass_max and rock_enable and grass_enable and snow_enable and !water_enable:
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Grass/grass.tres"))
					elif y >= grass_min and water_enable and grass_enable and !rock_enable and !snow_enable:
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Grass/grass.tres"))
					elif y < grass_min and grass_enable and rock_enable and snow_enable and !water_enable:
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Grass/grass.tres"))
					elif y < grass_max and grass_enable and rock_enable and !snow_enable and !water_enable:
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Grass/grass.tres"))
					elif y >= grass_min and y < grass_max and grass_enable and rock_enable and !snow_enable and water_enable:
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Grass/grass.tres"))
					elif y >= grass_min and y < snow_min and grass_enable and !rock_enable and snow_enable and water_enable:
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Grass/grass.tres"))
					elif y <= rock_max and y < snow_min and grass_enable and !rock_enable and snow_enable and !water_enable:
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Grass/grass.tres"))
					elif grass_enable and !rock_enable and !water_enable and !snow_enable:
						instance.get_child(0).set_surface_override_material(1, load("res://Material/Grass/grass.tres"))

func delete():
	for cells in loaded_cells.keys():
		var cell = loaded_cells[cells]
		cell.queue_free()
		loaded_cells.erase(cells)
