require 'gosu'
require 'awesome_print'
require_relative 'player'
require_relative 'game_object'
require_relative 'controls'
require_relative 'shoot'
require_relative 'queue'
require_relative 'game_logic'

class Game < Gosu::Window
  WINDOW_SIZE = [800, 600]
  #WINDOW_SIZE = [1920, 1080]
  CAPTION = 'Gosu rocks'
  IMAGES_DIR = 'images'
  BACKGROUND = 'background.jpg'

  USE_QUEUE = false

  def initialize
    super(WINDOW_SIZE[0], WINDOW_SIZE[1], true)
    #super(WINDOW_SIZE[0], WINDOW_SIZE[1], true, 33.7777)
    self.caption = CAPTION

    init_map
    init_players
    init_static_objects
    init_interactive_objects

    #init_queue_from_file 'data.csv'
  end

  def init_map
    @bg   = Gosu::Image.new self, IMAGES_DIR+'/'+BACKGROUND, true
    @font = Gosu::Font.new(self, Gosu::default_font_name, 30)
  end

  def init_interactive_objects
    InteractiveObjects.all << KolodecObject.new(self, :kolodec, 350, 300)
  end

  def init_static_objects
    StaticObject.new self, :tree, 100, 100
    StaticObject.new self, :tree, 37, 410
    StaticObject.new self, :tree, 607, 210
    StaticObject.new self, :el,   412, 510
    StaticObject.new self, :chuchelo, 250, 260
    StaticObject.new self, :old_tree, 450, 15

    40.times { StaticObject.new self, :small, Random.rand(self.width), Random.rand(self.height) }
  end

  def init_players
    @p1 = Player.new self, 220, 220, 2, 'p1'
    @p2 = Player.new self, 400, 400, 1, 'p2'
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
    Player.all.each_with_index do |player, num|
      controls = Controls[num]
      pressed = controls.find { |key, action| button_down? key }
      if pressed
        action = pressed[1]

        if USE_QUEUE
          Queue.queue[player.id] << action
        else
          player.send(action)
        end
      end
    end

    InteractiveObjects.all.each(&:action)
    Queue.process
    GameLogic.interaction

    #@i += 1
    #puts @i if @i % 50 == 0
  end

  def draw
    draw_background

    Player.all.each(&:draw)
    InteractiveObjects.all.each(&:draw)
    StaticObject.all.each(&:draw)

    @font.draw("health: #{@p1.health}", 5, 5, 2, 1.0, 1.0, 0xffffff00)
    @font.draw("health: #{@p2.health}", 440, 5, 2, 1.0, 1.0, 0xffffff00)
    @font.draw("ammo: #{@p1.ammo}", 140, 5, 2, 1.0, 1.0, 0xffffff00)
    @font.draw("ammo: #{@p2.ammo}", 580, 5, 2, 1.0, 1.0, 0xffffff00)
  end

  def draw_background
    need_to_repeat_horiz = (width / @bg.width) + 1
    need_to_repeat_vert  = (height / @bg.height) + 1

    need_to_repeat_vert.times do |v|
      top_shift = v*@bg.height
      need_to_repeat_horiz.times { |h| @bg.draw(h * @bg.width, top_shift, 0) }
    end


  end

  def button_down(id)
    case id
    when Gosu::KbQ
      close
    end

    Player.all.each_with_index do |player, num|
      controls = Controls.one_press[num]
      pressed = controls.find { |key, action| key == id }
      if pressed
        action = pressed[1]

        if USE_QUEUE
          Queue.queue[player.id] << action
        else
          player.send(action)
        end
      end
    end

  end
end

Game.new.show
