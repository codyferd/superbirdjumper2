require "chipmunk"
require "raylib-cr"

# Window & Physics Constants
W = Raylib.get_screen_width()
H = Raylib.get_screen_height()
JUMP_FORCE   = CP::Vect.new(0, -500.0)
GRAVITY      = CP::Vect.new(0, 400.0)
BIRD_RADIUS  = 20.0

# Init Raylib window
Raylib.init_window(W, H, "Chipmunk + Raylib-cr")
Raylib.set_target_fps(50)
Raylib.toggle_fullscreen()

# Set up Chipmunk space
space = CP::Space.new
space.gravity = GRAVITY

# Bird (dynamic circle)
bird_texture = Raylib.load_texture("assets/images/bird.png")
bird_body  = CP::Body.new(1.0, 1.0)
bird_body.position = CP::Vect.new(500, H * 0.5)
bird_shape = CP::Shape::Circle.new(bird_body, BIRD_RADIUS, CP::Vect.new(0, 0))
bird_shape.friction   = 0.7
bird_shape.elasticity = 0.5
space.add bird_body, bird_shape

# Main Loop
until Raylib.close_window?
  # Step physics
  space.step(1.0/50.0)

  key = Raylib.get_key_pressed()

  if key == 87 || key == 65 || key == 68
    bird_body.apply_impulse_at_world_point(JUMP_FORCE, bird_body.position)
  end
  
  # Get and display FPS
  fps = Raylib.get_fps()
  Raylib.draw_text("#{fps} FPS", 1800, 10, 20, Raylib::BLACK)

  # Draw
  Raylib.begin_drawing
  Raylib.clear_background(Raylib::SKYBLUE)

  # Draw bird
  Raylib.draw_texture(
    bird_texture,
    bird_body.position.x.to_i - bird_texture.width // 2,
    bird_body.position.y.to_i - bird_texture.height // 2,
    Raylib::WHITE
  )
  Raylib.end_drawing
end

# Cleanup
Raylib.close_window