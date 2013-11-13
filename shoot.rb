class InteractiveObjects
  @@all_objects = []

  class << self
    def all
      @@all_objects
    end
  end
end

class Fireball < InteractiveObjects
  attr_accessor :x, :y, :size, :z_index, :type

  N = 1 << 0
  E = 1 << 1
  S = 1 << 2
  W = 1 << 3

  SPEED = 6
  SIZE  = 16

  DX = { E => 1, W => -1, N =>  0, S => 0 }
  DY = { E => 0, W =>  0, N => -1, S => 1 }

  ACTIONS    = { move_down: 0, move_left: 1, move_right: 2, move_up: 3 }
  DIRECTIONS = { ACTIONS[:move_down] => S, ACTIONS[:move_left] => W, ACTIONS[:move_right] => E, ACTIONS[:move_up] => N }

  def initialize(win, action, x, y, player)
    @win = win
    @size = SIZE
    @direction = DIRECTIONS[action]
    @z_index = 3
    @type = :spell

    @x = x + DX[@direction]*player.size + 1
    @y = y + DY[@direction]*player.size + 1

    @tileset = Gosu::Image.load_tiles(@win, 'images/fireball.png', SIZE, SIZE, false)

    @sprites = {
      S => @tileset.first(2),
      E => @tileset[2..3],
      W => @tileset[4..5],
      N => @tileset.last(2)
    }

    @@all_objects << self
  end

  def action
    @x = (@x + DX[@direction] * SPEED) % @win.width
    @y = (@y + DY[@direction] * SPEED) % @win.width
  end

  def draw
    @sprites[@direction][rand(2)].draw(@x, @y, z_index, 1)
  end

end