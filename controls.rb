class Controls
  class << self
    def [](player_num)
      case player_num
        when 0
          {
            Gosu::KbLeft  => 'go_left',
            Gosu::KbRight => 'go_right',
            Gosu::KbUp    => 'go_up',
            Gosu::KbDown  => 'go_down',
          }
        when 1
          {
            Gosu::KbA => 'go_left',
            Gosu::KbD => 'go_right',
            Gosu::KbW => 'go_up',
            Gosu::KbS => 'go_down',
          }
      end
    end

    def one_press
      [
        {
          Gosu::KbL => 'shoot'
        },
        {
          Gosu::KbLeftControl => 'shoot'
        }
      ]
    end
  end
end