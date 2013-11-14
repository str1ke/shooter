class Sound

  SOUNDS = {
    hit:   'sounds/hit.wav',
    kill:  'sounds/kill.wav',
    shoot: 'sounds/shot.wav',
    reload: 'sounds/reload.wav'
  }

  MUSIC  = 'sounds/music.ogg'

  class << self
    def music(win)
      Gosu::Sample.new(win, MUSIC).play(0.3, 1, 1)
    end

    def play(action)
      Gosu::Sample.new(Game.win, SOUNDS[action]).play
    end
  end
end