extends CharacterBody2D
class_name Player

@export var move_right: String
@export var move_left: String
@export var jump: String

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed(jump) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis(move_left, move_right)
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	var collision= move_and_collide(velocity * delta, true)
	if collision and collision.get_collider() is Player:
		var other_player: Player= collision.get_collider()
		other_player.velocity.x= velocity.x
		other_player.move_and_slide()

		PhysicsServer2D.body_set_mode(other_player.get_rid(), PhysicsServer2D.BODY_MODE_STATIC)
		other_player.force_update_transform()
		PhysicsServer2D.body_set_mode(other_player.get_rid(), PhysicsServer2D.BODY_MODE_KINEMATIC)

	move_and_slide()
