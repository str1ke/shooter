require 'gosu'
require 'awesome_print'
require_relative 'player'
require_relative 'shoot'
require_relative 'queue'

class Game < Gosu::Window
  WINDOW_SIZE = [800, 600]
  CAPTION = 'Gosu rocks'
  IMAGES_DIR = 'images'
  BACKGROUND = 'background.jpg'

  USE_QUEUE = true

  def initialize
    super(WINDOW_SIZE[0], WINDOW_SIZE[1], false, 33.7777)
    self.caption = CAPTION

    @bg = Gosu::Image.new self, IMAGES_DIR+'/'+BACKGROUND, true
    @p1 = Player.new self, 0, 0, 2, 'p1'
    @p2 = Player.new self, 200, 200, 1, 'p2'

    Queue.init(@p1)
    Queue.init(@p2)

    @i1 = Gosu::Image.new self, IMAGES_DIR+'/'+'t1.png', true
    @i2 = Gosu::Image.new self, IMAGES_DIR+'/'+'t2.png', true

    @font = Gosu::Font.new(self, Gosu::default_font_name, 30)

    #50.times { Queue.queue[@p1.id] << 'go_left' }
    #50.times { Queue.queue[@p1.id] << 'go_down' }
    #Queue.queue[@p1.id] << 'shoot'
    #50.times { Queue.queue[@p1.id] << 'go_right' }
    #Queue.queue[@p1.id] << 'stop_moving'
    #
    #30.times { Queue.queue[@p2.id] << 'go_down' }
    #50.times { Queue.queue[@p2.id] << 'go_left' }
    #Queue.queue[@p2.id] << 'shoot'
    #70.times { Queue.queue[@p2.id] << 'go_up'}
    #Queue.queue[@p2.id] << 'stop_moving'

    #init_queue_from_file 'data.csv'
  end

  def init_queue_from_file file
    commands = File.new(file).readlines
    commands.each do |command|
      count, action = command.strip.split(',')
      count.to_i.times { Queue.queue[@p1.id] << "go_#{action}" }
      count.to_i.times { Queue.queue[@p2.id] << "go_#{action}" }
    end
  end

  def update
    if button_down? Gosu::KbLeft
      if USE_QUEUE
        Queue.queue[@p1.id] << 'go_left'
      else
        @p1.go_left
      end
    elsif button_down? Gosu::KbRight
      if USE_QUEUE
        Queue.queue[@p1.id] << 'go_right'
      else
        @p1.go_right
      end
    elsif button_down? Gosu::KbUp
      if USE_QUEUE
        Queue.queue[@p1.id] << 'go_up'
      else
        @p1.go_up
      end
    elsif button_down? Gosu::KbDown
      if USE_QUEUE
        Queue.queue[@p1.id] << 'go_down'
      else
        @p1.go_down
      end
    else
      if USE_QUEUE
        #Queue.queue[@p1.id] << 'stop_moving'
      else
        #@p1.stop_moving
      end
    end

    Queue.process

    @p1.shoots.each(&:action)
    @p2.shoots.each(&:action)

    #@i += 1
    #puts @i if @i % 50 == 0
  end

  def draw
    draw_background
    @p1.draw
    @p2.draw

    @font.draw("health: #{@p1.health}", 5, 5, 2, 1.0, 1.0, 0xffffff00)
    @font.draw("ammo: #{@p1.ammo}", 200, 5, 2, 1.0, 1.0, 0xffffff00)
  end

  def draw_background
    need_to_repeat_horiz = (width / @bg.width) + 1
    need_to_repeat_vert  = (height / @bg.height) + 1

    need_to_repeat_vert.times do |v|
      top_shift = v*@bg.height
      need_to_repeat_horiz.times { |h| @bg.draw(h * @bg.width, top_shift, 0) }
    end

    @i1.draw(100, 150, 2)
    @i1.draw(700, 350, 2)
    @i2.draw(300, 735, 2)
    @i2.draw(800, 73, 2)
  end

  def button_down(id)
    case id
    when Gosu::KbQ
      close
    when Gosu::KbSpace
      Queue.queue[@p1.id] << 'shoot'
      #@p1.shoot
    end
  end

end

Game.new.show
