require "raylib-cr"
require "chipmunk"

# Constants
W, H         = Raylib.GetScreenWidth(), Raylib.GetScreenHeight()
JUMP_FORCE   = CP::Vect.new(0, -250.0)
GRAVITY      = CP::Vect.new(0,  250.0)
BIRD_RADIUS  = 20.0
FPS_POSITION = CP::Vect.new(W - 120, 10)

# Initialization
Raylib.InitWindow(W, H, "Super Bird Jumper 2")
Raylib.SetTargetFPS(60)
Raylib.InitAudioDevice()
music = Raylib.LoadMusicStream("assets/audio/audio.ogg")
Raylib.PlayMusicStream(music)

# Physics
space = CP::Space.new
space.gravity = GRAVITY

# Bird setup
texture        = Raylib.LoadTexture("assets/images/bird.png")
body           = CP::Body.new(1.0, CP::INFINITY)
body.position  = CP::Vect.new(W/3, H/2)
shape          = CP::Shape::Circle.new(body, BIRD_RADIUS, CP::Vect.zero)
space.add body, shape

def jump(body)
  body.apply_impulse_at_world_point(JUMP_FORCE, body.position)
end

until Raylib.WindowShouldClose()
  dt = Raylib.GetFrameTime()
  space.step(dt)
  Raylib.UpdateMusicStream(music)

  # Input
  if Raylib.IsKeyPressed(Raylib::KEY_SPACE) ||
    Raylib.IsKeyPressed(Raylib::KEY_W)     ||
    Raylib.IsKeyPressed(Raylib::KEY_UP)
    jump(body)
  end

  Raylib.IsKeyPressed(Raylib::KEY_S) && body.apply_impulse_at_world_point(GRAVITY, body.position)

  if Raylib.IsKeyPressed(Raylib::KEY_Q) || Raylib.IsKeyPressed(Raylib::KEY_ESCAPE)
    break
  end

  # Draw
  Raylib.BeginDrawing()
  Raylib.ClearBackground(Raylib::Color::SKYBLUE)

  fps = "#{Raylib.GetFPS()} FPS"
  Raylib.DrawText(fps, FPS_POSITION.x.to_i, FPS_POSITION.y.to_i, 20, Raylib::Color::BLACK)

  x = (body.position.x - texture.width/2).to_i
  y = (body.position.y - texture.height/2).to_i
  Raylib.DrawTexture(texture, x, y, Raylib::Color::WHITE)

  Raylib.EndDrawing()
end

Raylib.UnloadMusicStream(music)
Raylib.CloseAudioDevice()
Raylib.CloseWindow()