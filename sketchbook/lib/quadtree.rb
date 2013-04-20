class Quadtree

  def initialize(x_range, y_range)
    raise ArgumentError, "invalid range" unless valid_ranges?(x_range, y_range)

    @x_range = x_range
    @y_range = y_range
    @particles = []
  end

  def size
    particles.size
  end

  def add(particle)
    particles.push(particle) if cover?(particle)
  end

  def cover?(particle)
    x_range.cover?(particle.x) && y_range.cover?(particle.y)
  end

  private

  attr_reader :x_range, :y_range, :particles

  def valid_ranges?(*args)
   ranges?(*args) && open_ended?(*args)
  end

  def ranges?(*args)
    args.all? { |arg| arg.is_a?(Range) }
  end

  def open_ended?(*args)
    args.all?(&:exclude_end?)
  end

end
