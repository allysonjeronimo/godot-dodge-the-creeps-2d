extends Node

# referencia ao mob_scene para que possa ser instanciado 
@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()

func game_over():
	# stop mob and score timers
	$ScoreTimer.stop()
	$MobTimer.stop()
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
func _on_mob_timer_timeout():
	# Cria uma nova instancia do Mob scene
	# Porém, só é adicionada na cena com add_child()
	var mob = mob_scene.instantiate()
	
	# Escolhe uma localização randomica no Path2D:
	# Obtem o node filho de MobPath - MobSpawnLocation
	var mob_spawn_location = $MobPath/MobSpawnLocation
	# Define a progressão ao longo do path através de um número aleatório entre o range 0.0 e 1.0
	# É possível utilizar progress pra especificar uma progressão contínua em pixels
	mob_spawn_location.progress_ratio = randf()
	
	# Define a direção perpendicular ao path direction (90° ou PI/2 do path direction)
	# Ex: Path direction (direita) -> (baixo)
	var direction = mob_spawn_location.rotation + PI / 2
	
	# Define a posição do mob para a localização aleatória
	mob.position = mob_spawn_location.position
	# Adiciona algumas aleatoriedades na direção (-45°, 45º)
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Velocidade do mob
	# porque x e não y? os sprites estão rotacionados
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	# linear_velocity = propriedade do RigidBody2D (pixels/s)
	mob.linear_velocity = velocity.rotated(direction)
	# Adiciona mob na Main scene
	add_child(mob)
	
func _on_score_timer_timeout():
	score += 1

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
