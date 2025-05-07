# Libraries
require "chipmunk"
require "cray"

# Window & Physics Constants
W = 1920
H = 1080
JUMP_FORCE   = CP::Vect.new(0, -200.0)
GRAVITY      = CP::Vect.new(0, 250.0)
BIRD_RADIUS  = 20.0
game_over    = false

# AppImage Asset Path
if Dir.current == "/home/luca/superbirdjumper2"
  asset_path = "/home/luca/superbirdjumper2"
else
  asset_path = ENV["ASSET_PATH"]?
end

# Init LibRay Window and Audio
LibRay.init_window(W, H, "Super Bird Jumper 2")
LibRay.set_target_fps(0)  # Unlimited FPS
LibRay.toggle_fullscreen()
LibRay.init_audio_device()

# Chipmunk Physics Setup
space = CP::Space.new
space.gravity = GRAVITY

# Load Assets
bird_texture = LibRay.load_texture("#{asset_path}/assets/images/bird.png")
background_texture = LibRay.load_texture("#{asset_path}/assets/images/backround.jpg")

# Bird Physics Setup
bird_body = CP::Body.new(1.0, 1.0)
bird_body.position = CP::Vect.new(W * 0.25, H * 0.5)
bird_shape = CP::Shape::Circle.new(bird_body, BIRD_RADIUS, CP::Vect.new(0, 0))
space.add bird_body, bird_shape

# Main Game Loop
until LibRay.window_should_close?
  LibRay.begin_drawing

  # Dynamic Framerate Update
  s = LibRay.get_fps()
  s = 50.0 if s <= 0  # Fallback
  dt = 1.0 / s        # Delta time for physics

  # Step Physics
  space.step(dt)

  # Draw Background
  LibRay.clear_background(LibRay::BLACK)
  LibRay.draw_texture(background_texture, 0, 0, LibRay::SKYBLUE)

  if game_over
    LibRay.clear_background(LibRay::BLACK)
    LibRay.draw_text("GAME OVER", W//2 - 350, H//2 - 80, 120, LibRay::RED)
    LibRay.draw_text("Press W to Restart", W//2 - 350, H//2 + 30, 60, LibRay::RED)
    key = LibRay.get_key_pressed()
    if key == 87
      bird_body.position = CP::Vect.new(W * 0.25, H * 0.5)
      bird_body.velocity = CP::Vect.new(0, 0)
      game_over = false
    end
    LibRay.end_drawing
    next
  end

  # Controls
  key = LibRay.get_key_pressed()
  if key == 87 || key == 65 || key == 68
    bird_body.apply_impulse_at_world_point(JUMP_FORCE, bird_body.position)
  end
  if key == 83
    bird_body.apply_impulse_at_world_point(JUMP_FORCE * -1, bird_body.position)
  end

  # Check Death Conditions
  if bird_body.position.y >= H || bird_body.position.y <= 0
    game_over = true
  end

  # Draw Bird
  LibRay.draw_texture(
    bird_texture,
    bird_body.position.x.to_i - bird_texture.width // 2,
    bird_body.position.y.to_i - bird_texture.height // 2,
    LibRay::WHITE
  )

  # Display FPS
  LibRay.draw_text("#{s.to_i} FPS", W - 150, 10, 20, LibRay::BLACK)

  LibRay.end_drawing
end

# Cleanup
LibRay.close_audio_device()
LibRay.close_window()