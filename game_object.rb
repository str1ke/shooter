class GameObject
  attr_accessor :x, :y, :size, :image, :z_index, :type

  SPRITES_PATH = 'images/objects.png'
  SPRITES_COORD = {
    kolodec:     [10,  376, 48, 48],
    vert_lavka:  [0,   423, 32, 88],
    vert_brevno: [64,  416, 32, 66],
    chuchelo:    [32,  425, 32, 57],
    krest1:      [192, 286, 32, 36],
    krest2:      [224, 286, 32, 36],
    tree:        [191, 128, 64, 64],
    tree_c:      [192, 192, 64, 64],
    el_c:        [64,  256, 64, 64],
    el:          [0,   288, 64, 64],
    old_tree:    [0,   224, 64, 64],
    small_0:     [193, 449, 13, 12],
    small_1:     [209, 449, 14, 14],
    small_2:     [225, 449, 15, 14],
    small_3:     [240, 448, 16, 14],
    small_4:     [192, 480, 14, 14],
    small_5:     [192, 494, 14, 14]
  }

  WALLS = [
    :vert_lavka,
    :vert_brevno,
    :krest1,
    :krest2,
    :tree,
    :tree_c,
    :el_c,
    :el,
    :old_tree
  ]

  class << self
    def image_for(win, object)
      object = "small_#{Random.rand(6)}".to_sym if object == :small
      coord = SPRITES_COORD[object]
      Gosu::Image.new win, SPRITES_PATH, true, *coord
    end
  end

  def initialize(win, type, x = 0, y = 0, size = nil, z_index = 1)
    @x = x
    @y = y
    @z_index = z_index

    #fixme
    @size = 0
    if type =~ /tree/
      @size = 100
    end

    @type = type

    @image = self.class.image_for win, type
  end

  def action
  end

  def draw
    @image.draw(x, y, z_index)
  end

  def wall?
    WALLS.include? type
  end
end

class StaticObject < GameObject
  @all = []

  class << self
    attr_accessor :all

    def walls
      @all.select(&:wall?)
    end
  end

  def initialize(win, type, x = 0, y = 0, size = 0, z_index = 1)
    super
    self.class.all << self
  end
end

class KolodecObject < GameObject
  attr_accessor :type

  def initialize(win, type, x = 0, y = 0, size = nil, z_index = 1)
    self.type = :kolodec
    type = :kolodec

    super
  end
end