# A two dimensional array stored as a one-dimensional array

struct Array2D(T)
  getter width : Int32
  getter height : Int32
  getter array : Array(T)

  def initialize(*, @width, @height, default : T)
    @array = Array(T).new(width*height, default)
  end

  def [](x, y) : T
    @array[y*width + x]
  rescue e : IndexError
    check_bounds x, y
    raise e
  end

  def []=(x, y, v : T)
    @array[y*width + x] = v
  rescue e : IndexError
    check_bounds x, y
    raise e
  end

  private def check_bounds(x, y)
    if x < 0 || y < 0
      raise IndexError.new "{#{x},#{y}}: x and y must be non-negative"
    elsif x > width - 1 || y > height - 1
      raise IndexError.new "{#{x},#{y}}: x must be in 0...width and y in 0...height"
    end
  end
end
