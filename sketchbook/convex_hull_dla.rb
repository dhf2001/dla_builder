require_relative "../app/dla.rb"
require_relative "../app/convex_hull.rb"
require_relative "./renderer.rb"

def setup
  size 800, 600
  background 0

  @convex_hull = nil

  @dla = Dla.new do |particle|
    if @convex_hull
      @convex_hull.add_point(particle.center)
    else
      @convex_hull = ConvexHull.new(particle.center)
    end

    Renderer.new(self, particle).render

    beginShape
    @convex_hull.points.each { |point| vertex(x(point.x), y(point.y)) }
    endShape(CLOSE)
  end
end

def draw
  @dla.grow
end

def x(x_)
  width / 2 + x_
end

def y(y_)
  height / 2 + y_
end
