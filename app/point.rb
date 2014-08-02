require 'matrix'
require 'forwardable'
require_relative 'vector2d'

class Point

  extend Forwardable

  def self.[](*coordinates)
    new(coordinates)
  end

  def self.random(radius)
    new(Vector2D.random(radius))
  end

  def initialize(coordinates)
    @vector = Vector2D[*coordinates]
  end

  def x
    vector[0]
  end

  def y
    vector[1]
  end

  def_delegators :vector, :[], :magnitude, :to_a

  def +(point)
    Point.new(vector + point.vector)
  end

  def -(point)
    Point.new(vector - point.vector)
  end

  def ==(point)
    vector == point.vector
  end

  def map(&block)
    Point.new(vector.map(&block))
  end

  def distance(point)
    (self - point).magnitude
  end

  def extent
    Point.new(vector.map(&:abs))
  end

  def max(point)
    Point[[x, point.x].max, [y, point.y].max]
  end

  def rotate(theta)
    Point.new(vector.rotate(theta))
  end

  def determinant(v1)
    vector.determinant(v1.vector)
  end

  def inspect
    "Point[#{x}, #{y}]"
  end

  def to_v
    vector
  end

  protected

    attr_reader :vector

end
