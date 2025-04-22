# Libraries
import arcade

# Constants
window_width = 1920
window_height = 1000
window_title = "Super Bird Jumper 2"
bird_speed = 10
jump_height = 120
falling = -6

class GameView(arcade.View):
    def __init__(self, music=None):
        super().__init__()
        # Music
        if music is None:
            self.music = music or arcade.Sound("superbirdjumper2/assets/audio/audio.opus", streaming=True)
            self.music_player = self.music.play(loop=True)
        else:
            # Terminate
            self.music = music
        # Sprites
        self.bird_img = arcade.load_texture("superbirdjumper2/assets/images/bird.png")
        self.bird_sprite = arcade.Sprite(self.bird_img)
        self.bird_sprite.center_x = 400
        self.bird_sprite.center_y = 900
        # Sprite List
        self.game_list = arcade.SpriteList()
        self.game_list.append(self.bird_sprite)
        # Physics Engine
        self.physics_engine = arcade.PhysicsEngineSimple(
            self.bird_sprite, self.game_list
        )
        # CSS Color
        self.background_color = arcade.csscolor.CORNFLOWER_BLUE
    def on_draw(self):
        self.clear()
        self.game_list.draw()
    def on_update(self, delta_time):
        self.physics_engine.update()
        self.bird_sprite.change_y = falling
        if self.bird_sprite.center_y < 0 or self.bird_sprite.center_y > window_height:
            self.window.show_view(GameOverView(self.music))
    def on_key_press(self, key, modifiers):
        if key in (arcade.key.W, arcade.key.A, arcade.key.D):
            self.bird_sprite.change_y = jump_height
        if key == arcade.key.Q:
            arcade.close_window()
    def on_key_release(self, key, modifiers):
        if key in (arcade.key.SPACE, arcade.key.W, arcade.key.UP):
            self.bird_sprite.change_y = 0

class GameOverView(arcade.View):
    def __init__(self, music):
        super().__init__()
        self.music = music
    def on_draw(self):
        self.clear()
        arcade.draw_text("GAME OVER", 960, 500, arcade.color.RED, 60, anchor_x="center")
        arcade.draw_text("Press E to Restart", window_width / 2, window_height / 2 - 60, arcade.color.WHITE, 30, anchor_x="center")
    def on_key_press(self, key, modifiers):
        if key == arcade.key.E:
            game = GameView(self.music)
            self.window.show_view(game)

def main():
    window = arcade.Window(window_width, window_height, window_title)
    start_view = GameView()
    window.show_view(start_view)
    arcade.run()

if __name__ == "__main__":
    main()