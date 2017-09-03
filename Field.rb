class Field
      WIDTH = 10
      HEIGHT = 18
      FINISH_COUNT = 40
      STATUS = { none: 0, wall: 1, active: 2, fix: 3}

      attr_reader :point, :field

      def initialize()
            @field = init_field
            @point  = 0
      end
      def clear()
            @field.each_with_index do |line, y|
                  line.each_with_index do |l, x|
                        @field[y][x] = STATUS[:none] if l == STATUS[:active]
                  end
            end
      end

      def line_clear()
            @field.each_with_index do |line, y|
                  if line == [
                              STATUS[:wall],
                              STATUS[:fix],
                              STATUS[:fix],
                              STATUS[:fix],
                              STATUS[:fix],
                              STATUS[:fix],
                              STATUS[:fix],
                              STATUS[:fix],
                              STATUS[:fix],
                              STATUS[:wall]
                  ]
                        @point += 1
                        @field.delete_at(y)
                        @field.insert(0, [
                              STATUS[:wall],
                              STATUS[:none],
                              STATUS[:none],
                              STATUS[:none],
                              STATUS[:none],
                              STATUS[:none],
                              STATUS[:none],
                              STATUS[:none],
                              STATUS[:none],
                              STATUS[:wall]])
                  end
            end
      end

      def game_finish?()
            @point >= 40
      end

      def are_block?(next_pos)
            result = false
            next_pos.each do |pos|
                  if is_block?(pos[0], pos[1])
                        result = true
                  end
            end
            result
      end

      def fix(now_pos)
            now_pos.each do |pos|
                  @field[pos[1]][pos[0]] = STATUS[:fix]
            end
      end

      def pre_fix(now_pos)
            now_pos.each do |pos|
                  @field[pos[1]][pos[0]] = STATUS[:active]
            end
      end

      private
      def is_block?(x, y)
            @field[y][x] == STATUS[:wall] || @field[y][x] == STATUS[:fix]
      end

      def init_field
            f = []
            HEIGHT.times do |i|
                  line = []
                  WIDTH.times do |j|
                        line[j] = (j == 0 || j == WIDTH - 1 || i == HEIGHT - 1) ? STATUS[:wall] : STATUS[:none]
                  end
                  f[i] = line
            end
            f
      end
end
