require "chipmunk"

window_width = 800
window_height = 600
jump_height = 120.0
falling = -6.0

space = CP::Space.new

ground_body = CP::Body.new_static
ground_shape = CP::Shape::Segment.new(ground_body, CP::Vect.new(0, window_height - 50), CP::Vect.new(window_width, window_height - 50), 0)
ground_shape.friction = 1.0
space.add(ground_shape)

CONST = 99999999999999999999999999999999999999999999999999999999.9

ceiling_body = CP::Body.new_static
bird_body = CP::Body.new(1.0, CONST)  # mass 1, infinite moment of inertia
bird_body.position = CP::Vect.new(window_width / 4, window_height / 2)

bird_shape = CP::Shape::Circle.new(bird_body, 20.0, CP::Vect.new(0.0, 0.0))  # Circle with a radius of 20 for the bird
bird_shape.friction = 0.7
bird_shape.elasticity = 0.5
space.add(bird_shape)

bird_jump = CP::Vect.new(0, jump_height)
loop do
space.step(1.0 / 60.0)
bird_body.apply_force_at_world_point(CP::Vect.new(0.0, falling), bird_body.position)

if bird_body.position.y <= 0
puts "Game Over: Bird hit the ground!"
break
end

puts "Press Enter to make the bird jump"
input = STDIN.gets.to_s.strip
if input == "Enter"
bird_body.apply_force_at_world_point(bird_jump, bird_body.center_of_gravity)
end

puts "Bird Position: #{bird_body.position.x}, #{bird_body.position.y}"
sleep(0.02)  # 50 FPS simulation
end