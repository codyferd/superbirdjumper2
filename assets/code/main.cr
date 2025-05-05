# Libraries
require "chipmunk"
require "cray"

# Window & Physics Constants
W = 1920
H = 1080
JUMP_FORCE   = CP::Vect.new(0, -250.0)
GRAVITY      = CP::Vect.new(0, 250.0)
BIRD_RADIUS  = 20.0
game_over    = 0

# AppImage stuff
if Dir.current == "/home/luca/superbirdjumper2"
  asset_path = "/home/luca/superbirdjumper2"
else
  asset_path = ENV["ASSET_PATH"]?
end

# Init LibRay window
LibRay.init_window(W, H, "Super Bird Jumper 2")
LibRay.set_target_fps(50)
LibRay.toggle_fullscreen()

# Sound
LibRay.init_audio_device()
# audio = LibRay.load_music_stream("#{asset_path}/assets/audio/audio.ogg".to_unsafe)
# LibRay.play_music_stream(audio)

# Set up Chipmunk space
space = CP::Space.new
space.gravity = GRAVITY

# Bird
bird_texture = LibRay.load_texture("#{asset_path}/assets/images/bird.png")
bird_body  = CP::Body.new(1.0, 1.0)
bird_body.position = CP::Vect.new(W * 0.25, H * 0.5)
bird_shape = CP::Shape::Circle.new(bird_body, BIRD_RADIUS, CP::Vect.new(0, 0))
space.add bird_body, bird_shape
backround_texture = LibRay.load_texture("#{asset_path}/assets/images/backround.jpg")

# Main Loop
until LibRay.window_should_close?
  # Step physics
  space.step(1.0/50.0)

  key = LibRay.get_key_pressed()

  if key == 87 || key == 65 || key == 68
      bird_body.apply_impulse_at_world_point(JUMP_FORCE, bird_body.position)
  end
  
  if key == 83
    bird_body.apply_impulse_at_world_point(GRAVITY, bird_body.position)
  end

  if bird_body.position.y >= H || bird_body.position.y <= 0
    Process.exec(Process.executable_path.not_nil!)
  end
  
#  if key == 69
#    # Inventory/shop
#  end
#  if key == 81
#   # Use power-up
#  end

  # Get and display FPS
  fps = LibRay.get_fps()
  LibRay.draw_text("#{fps} FPS", 1800, 10, 20, LibRay::BLACK)

  # Draw
  LibRay.begin_drawing
  LibRay.draw_texture(backround_texture, 0, 0, LibRay::SKYBLUE)

  # Draw bird
  LibRay.draw_texture(
    bird_texture,
    bird_body.position.x.to_i - bird_texture.width // 2,
    bird_body.position.y.to_i - bird_texture.height // 2,
    LibRay::WHITE
  )

  LibRay.end_drawing
end

LibRay.close_audio_device()
LibRay.close_window()