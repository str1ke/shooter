require_relative 'shoot'

class Player
  attr_accessor :images, :z_index, :x, :y, :ammo, :health, :id, :size

  @@all = []

  SPRITES = 3
  SPRITE_SIZE = 32
  STEP = 3
  ACTIONS = { move_down: 0, move_left: 1, move_right: 2, move_up: 3 }

  DX = {
    left:  -1,
    right:  1,
    up:     0,
    down:   0
  }

  DY = {
    left:   0,
    right:  0,
    up:    -1,
    down:   1
  }

  class << self
    def all
      @@all
    end
  end

  def initialize(window, x = 0, y = 0, hero = 3, id = 'p1')
    @win = window
    @z_index = 2
    @x = x
    @y = y
    @hero    = hero
    @state   = ACTIONS[:move_down]
    @animate = false
    @ammo   = 10
    @health = 3
    @id = id
    @size = 32

    load_hero_from_sprites

    Queue.init(self)
    @@all << self
  end

  def load_hero_from_sprites
    sprites = Gosu::Image::load_tiles(@win, 'images/heroes.png', SPRITE_SIZE, SPRITE_SIZE, false)
    @images = []
    @dead_image = GameObject.image_for @win, :krest1

    4.times do |action|
      SPRITES.times { |sprite_index| @images << sprites[@hero * SPRITES + action * 12 + sprite_index] }
    end
  end

  def go_up
    return unless can_go? :up

    @state = ACTIONS[:move_up]
    start_moving
    self.y = (self.y - STEP) % @win.height
  end

  def go_left
    return unless can_go? :left

    @state = ACTIONS[:move_left]
    start_moving
    self.x = (self.x - STEP) % @win.width
  end

  def go_right
    return unless can_go? :right

    @state = ACTIONS[:move_right]
    start_moving
    self.x = (self.x + STEP) % @win.width
  end

  def go_down
    return unless can_go? :down

    @state = ACTIONS[:move_down]
    start_moving
    self.y = (self.y + STEP) % @win.height
  end

  def can_go?(dir)
    return false if dead?

    StaticObject.walls.none? { |wall| GameLogic.hit? wall.x, wall.y, wall.size, x + DX[dir]*STEP, y + DY[dir]*STEP, size }
  end

  def shoot
    return unless can_shoot?

    Sound.play(:shoot)
    self.ammo -= 1
    Fireball.new(@win, @state, x, y, self)
  end

  def reload
    return unless can_reload?

    self.ammo = 10
    Sound.play :reload
  end

  def can_reload?
    ammo < 10
  end

  def can_shoot?
    ammo > 0
  end

  def hit
    return if dead?
    self.health -= 1
    Sound.play(:hit)

    Sound.play(:kill) if dead?
  end

  def dead?
    health < 0
  end

  def start_moving
    @animate = true
  end

  def stop_moving
    @animate = false
  end

  def draw
    if dead?
      @dead_image.draw(x, y, z_index)
    else
      frame = SPRITES * @state
      frame += Gosu::milliseconds / 100 % SPRITES if @animate

      @images[frame].draw(x, y, z_index)
      stop_moving
    end
  end
end