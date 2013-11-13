class Fireball
  N = 1 << 0
  E = 1 << 1
  S = 1 << 2
  W = 1 << 3

  SPEED = 6

  DX = { E => SPEED, W => -SPEED, N => 0, S => 0 }
  DY = { E => 0, W =>  0, N => -SPEED, S => SPEED }

  ACTIONS    = { move_down: 0, move_left: 1, move_right: 2, move_up: 3 }
  DIRECTIONS = { ACTIONS[:move_down] => S, ACTIONS[:move_left] => W, ACTIONS[:move_right] => E, ACTIONS[:move_up] => N }

  def initialize(win, action, x, y)
    @x = x
    @y = y
    @direction = DIRECTIONS[action]

    @tileset = Gosu::Image.load_tiles(win, 'images/fireball.png', 16, 16, false)

    @sprites = {
      S => @tileset.first(2),
      E => @tileset[2..3],
      W => @tileset[4..5],
      N => @tileset.last(2)
    }
  end

  def action
    @x += DX[@direction]
    @y += DY[@direction]
  end

  def draw
    @sprites[@direction][rand(2)].draw(@x, @y, 2, 1)
  end

end