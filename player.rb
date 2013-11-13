require_relative 'shoot'

class Player
  attr_accessor :images, :z_index, :x, :y, :ammo, :health, :shoots, :id

  SPRITES = 3
  SPRITE_SIZE = 32
  STEP = 3
  ACTIONS = { move_down: 0, move_left: 1, move_right: 2, move_up: 3 }

  def initialize(window, x = 0, y = 0, hero = 3, id = 'p1')
    @win = window
    @z_index = 1
    @x = x
    @y = y
    @hero    = hero
    @state   = ACTIONS[:move_down]
    @animate = false
    @ammo   = 10
    @health = 3
    @id = id
    @shoots = []

    load_hero_from_sprites
  end

  def load_hero_from_sprites
    sprites = Gosu::Image::load_tiles(@win, 'images/heroes.png', 32, 32, false)
    @images = []

    4.times do |action|
      SPRITES.times { |sprite_index| @images << sprites[@hero * SPRITES + action * 12 + sprite_index] }
    end
  end

  def go_up
    @state = ACTIONS[:move_up]
    start_moving
    self.y -= STEP
  end

  def go_left
    @state = ACTIONS[:move_left]
    start_moving
    self.x -= STEP
  end

  def go_right
    @state = ACTIONS[:move_right]
    start_moving
    self.x += STEP
  end

  def go_down
    @state = ACTIONS[:move_down]
    start_moving
    self.y += STEP
  end

  def shoot
    return unless can_shoot?

    self.ammo -= 1
    @shoots << Fireball.new(@win, @state, x, y)
  end

  def can_shoot?
    ammo > 0
  end

  def hit
    self.health -= 1
  end

  def start_moving
    @animate = true
  end

  def stop_moving
    @animate = false
  end

  def draw
    frame = SPRITES * @state
    frame += Gosu::milliseconds / 100 % SPRITES if @animate

    @images[frame].draw(x, y, 1)
    stop_moving

    @shoots.each { |s| s.draw }
  end

end