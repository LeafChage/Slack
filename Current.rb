class Current
      BLOCKS = [
            [ [0, 1, 0, 0], [1, 1, 1, 0], [0, 0, 0, 0], [0, 0, 0, 0] ],
            [ [0, 1, 1, 0], [1, 1, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0] ],
            [ [1, 1, 0, 0], [0, 1, 1, 0], [0, 0, 0, 0], [0, 0, 0, 0] ],
            [ [1, 1, 1, 1], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0] ],
            [ [1, 1, 0, 0], [1, 1, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0] ],
            [ [1, 0, 0, 0], [1, 1, 1, 0], [0, 0, 0, 0], [0, 0, 0, 0] ],
            [ [0, 0, 1, 0], [1, 1, 1, 0], [0, 0, 0, 0], [0, 0, 0, 0] ]
      ]

      def initialize(x, y, current = new_block)
            @x = x
            @y = y
            @current = current
      end

      def move_position()
            count = 0
            block_position = Array.new(4)
            @current.each_with_index do |block, y|
                  block.each_with_index do |b, x|
                        if b == 1
                              block_position[count] = [ @x + x, @y + y ]
                              count += 1
                        end
                  end
            end
            block_position
      end

      def right()
            Current.new(@x + 1, @y, @current)
      end

      def left()
            Current.new(@x - 1, @y, @current)
      end

      def fall()
            Current.new(@x, @y + 1, @current)
      end

      def rotation()
            tmp = Array.new(4){ Array.new(4, 0)}
            @current.each_with_index do |line, y|
                  line.each_with_index do |l, x|
                        tmp[x][y] = l
                  end
            end
            tmp.each_with_index do |line, i|
                  tmp[i] = line.reverse
            end
            Current.new(@x, @y, tmp)
      end

      def new_block()
            rnd = rand(BLOCKS.length)
            block = BLOCKS[rnd]

            current = Array.new(4){ Array.new(4, 0)}
            block.each_with_index do |line, i|
                  line.each_with_index do |l, j|
                        if l == 1
                              current[i][j] = 1
                        end
                  end
            end
            current
      end
end
