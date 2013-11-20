require 'gosu'
require 'awesome_print'
require_relative 'player'
require_relative 'sound'
require_relative 'game_object'
require_relative 'controls'
require_relative 'shoot'
require_relative 'queue'
require_relative 'game_logic'
require_relative 'thread'

if ARGV[0]
  $mode = :client
else
  $mode = :server
end


class Game < Gosu::Window
  WINDOW_SIZE = [800, 600]
  #WINDOW_SIZE = [1920, 1080]
  CAPTION = 'Gosu rocks'
  IMAGES_DIR = 'images'
  BACKGROUND = 'background.jpg'

  USE_QUEUE = false

  def initialize
    #super(WINDOW_SIZE[0], WINDOW_SIZE[1], false)
    super(WINDOW_SIZE[0], WINDOW_SIZE[1], false, 33.7777)
    self.caption = CAPTION

    Sound.music self

    init_map
    init_players
    init_static_objects
    init_interactive_objects
    self.class.win = self

    Tt.connect 'localhost', 20002, $mode

    #init_queue_from_file 'data.csv'
  end

  class << self
    attr_accessor :win
  end

  def init_map
    @bg   = Gosu::Image.new self, IMAGES_DIR+'/'+BACKGROUND, true
    @font = Gosu::Font.new  self, Gosu::default_font_name, 30
  end

  def init_interactive_objects
    InteractiveObjects.all << KolodecObject.new(self, :kolodec, self.width/2-50, self.height/2)
  end

  def init_static_objects
    walls = [:tree, :el, :chuchelo, :old_tree]
    #StaticObject.new self, :tree, 100, 100
    #StaticObject.new self, :tree, 37, 410
    #StaticObject.new self, :tree, 607, 210
    #StaticObject.new self, :el,   412, 510
    #StaticObject.new self, :chuchelo, 250, 260
    #StaticObject.new self, :old_tree, 450, 15

    #30.times { StaticObject.new self, walls.sample, Random.rand(self.width), Random.rand(self.height) }
    #40.times { StaticObject.new self, :small, Random.rand(self.width), Random.rand(self.height) }
  end

  def init_players
    #@p1 = Player.new self, self.width*0.2, self.height*0.5, 2, 'p1'
    #@p2 = Player.new self, self.width*0.8, self.height*0.5, 1, 'p2'
    if $mode == :server
      @p1 = Player.new self, 200, 200, 2, 'p1'
      @p2 = Player.new self, 600, 200, 1, 'p2'
    else
      @p2 = Player.new self, 200, 200, 2, 'p2'
      @p1 = Player.new self, 600, 200, 1, 'p1'
    end
    
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
        Tt.send(action) if player.id == 'p1'

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
        Tt.send(action) if player.id == 'p1'

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
