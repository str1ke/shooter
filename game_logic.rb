class GameLogic
  class << self
    def interaction
      Player.all.each do |player|
        InteractiveObjects.all.each do |object|
          if hit?(player.x, player.y, player.size, object.x, object.y, object.size)

            if object.type == :spell
              player.hit
              InteractiveObjects.all.delete(object)
            elsif object.type == :kolodec
              player.reload
            end

          end
        end
      end

      InteractiveObjects.all.each do |object|
        StaticObject.walls.each do |wall|
          if object.type == :spell
            if hit?(object.x, object.y, object.size, wall.x, wall.y, wall.size)
              InteractiveObjects.all.delete(object)
            end
          end
        end
      end
    end

    def hit? (x1, y1, size1, x2, y2, size2)
      r1_left   = x1
      r1_right  = x1 + size1/2
      r1_top    = y1
      r1_bottom = y1 + size1/2

      r2_left   = x2
      r2_right  = x2 + size2/2
      r2_top    = y2
      r2_bottom = y2 + size2/2
      return true if (r1_left <= r2_right and r2_left <= r1_right and r1_top <= r2_bottom and r2_top <= r1_bottom)

      false
    end
  end
end