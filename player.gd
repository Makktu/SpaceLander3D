extends CharacterBody3D

const SPEED = 10.0
const THRUST_VELOCITY = 4.5

var thrust_is_pressed = false


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera: Camera3D = $Camera3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$wind_effect.play()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * .005)
		camera.rotate_x(-event.relative.y * .005)
		camera.rotation.x = clamp(camera.rotation.x, -PI/4, PI/4)
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Thrust
	if Input.is_action_pressed("ui_accept"):
		if $Exhaust.visible == false:
			$Exhaust.visible = true
		velocity.y = THRUST_VELOCITY
		if !thrust_is_pressed:
			thrust_is_pressed = true
			$Exhaust/AudioStreamPlayer3D.play()
	
	if Input.is_action_just_released("ui_accept"):
		thrust_is_pressed = false
		$Exhaust.visible = false
		$Exhaust/AudioStreamPlayer3D.stop()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _on_audio_stream_player_3d_finished():
	$Exhaust/AudioStreamPlayer3D.play()


func _on_wind_effect_finished():
	$wind_effect2.play()


func _on_wind_effect_2_finished():
	$wind_effect3.play() # Replace with function body.


func _on_wind_effect_3_finished():
	$wind_effect.play() # Replace with function body.
