require "chipmunk"
require "raylib-cr"

# Window & Physics Constants
W = 1920
H = 1000
JUMP_FORCE   = CP::Vect.new(0, 300.0)
GRAVITY      = CP::Vect.new(0, -980.0)  # pixels/sec²
BIRD_RADIUS  = 20.0

# Init Raylib window
Raylib.init_window(W, H, "Chipmunk + Raylib-cr")
Raylib.set_target_fps(50)

# Set up Chipmunk space
space = CP::Space.new
space.gravity = GRAVITY

# Bird (dynamic circle)
bird_body  = CP::Body.new(1.0, 1.0)
bird_body.position = CP::Vect.new(W/4, H/2)
bird_shape = CP::Shape::Circle.new(bird_body, BIRD_RADIUS, CP::Vect.new(0, 0))
bird_shape.friction   = 0.7
bird_shape.elasticity = 0.5
space.add bird_body, bird_shape

# Main Loop
until Raylib.close_window?
  # Step physics
  space.step(1.0/50.0)

  key = Raylib.get_key_pressed

  if key == Raylib::KeyboardKey::W ||
    key == Raylib::KeyboardKey::A ||
    key == Raylib::KeyboardKey::D
  
    bird_body.apply_impulse_at_world_point(JUMP_FORCE, bird_body.position)
  end
  
  # Quit if Q or ESC pressed
  if key == Raylib::KeyboardKey::Q || key == Raylib::KeyboardKey::Escape
    break
  end

  # Draw
  Raylib.begin_drawing
  Raylib.clear_background(Raylib::SKYBLUE)

  # Draw bird
  Raylib.draw_circle(
    bird_body.position.x.to_i,
    bird_body.position.y.to_i,
    BIRD_RADIUS,
    Raylib::RED
  )

  Raylib.end_drawing
end

# Cleanup
Raylib.close_window