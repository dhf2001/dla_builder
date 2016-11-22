require_relative "vector2d"
require 'forwardable'

class Particle

  extend Forwardable
  attr_reader :center, :radius, :children

  def initialize(options = {})
    coordinates = options.fetch(:center) do
      [options.fetch(:x, 0), options.fetch(:y, 0)]
    end.to_a

    @center = Vector2D.new(coordinates)
    @radius = options.fetch(:radius, 1)
    @children = []
  end

  def_delegators :center, :x, :y, :magnitude, :to_v, :[]

  def extent
    Vector2D.new(center.extent + Vector2D[radius, radius])
  end

  def distance(particle)
    center.distance(particle.center) - (radius + particle.radius)
  end

  def within_radius?(test_radius)
    extent.magnitude < test_radius
  end

  def add_child(particle)
    children.push(particle)
  end

  def depth
    return 0 if leaf?
    children.map { |child| child.depth + 1 }.max
  end

  def step(distance)
    Particle.new(center: center + Vector2D.random(distance), radius: radius)
  end

  def rotate(theta)
    Particle.new(center: center.rotate(theta), radius: radius)
  end

  def inspect
    {x: x, y: y, radius: radius}.inspect
  end

  def +(offset)
    Particle.new(center: center + offset, radius: radius)
  end

  def -(offset)
    Particle.new(center: center - offset, radius: radius)
  end

  def *(transformation)
    Particle.new(center: center.transform(transformation), radius: radius)
  end

  protected
  attr_writer :center

  def leaf?
    children.empty?
  end

end
