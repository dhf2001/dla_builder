require_relative "../test_helper.rb"
require_relative "../../app/quadtree.rb"
require_relative "../../app/particle.rb"
require_relative "../../app/axis_aligned_bounding_box.rb"

require 'set'

describe Quadtree do

  describe "#initialize" do
    it "starts off with zero particles" do
      quadtree = Quadtree.new(AxisAlignedBoundingBox.new(0...1, 0...1))
      quadtree.size.must_equal 0
    end

    it "start off with zero depth" do
      quadtree = Quadtree.new(AxisAlignedBoundingBox.new(0...1, 0...1))
      quadtree.depth.must_equal 0
    end
  end

  describe "#<<" do
    let(:quadtree) { Quadtree.new(AxisAlignedBoundingBox.new(0...1, 0...1), max_depth: 3) }

    it "adds a particle" do
      quadtree << test_particle(0.5, 0.5)
      quadtree.size.must_equal 1
    end

    it "doesn't add a particle if it is outside the tree's bounds" do
      quadtree << test_particle(2, 2)
      quadtree.size.must_equal 0
    end

    it "subdivides to the maximum depth upon adding the first particle" do
      quadtree << test_particle(0.5, 0.5)
      quadtree.depth.must_equal 3
    end
  end

  describe "#covers?" do
    let(:quadtree) { Quadtree.new(AxisAlignedBoundingBox.new(0...1, 0...1)) }

    it "returns true if the quadtree covers the particle" do
      quadtree.covers?(test_particle(0, 0)).must_equal true
      quadtree.covers?(test_particle(0.5, 0.5)).must_equal true
      quadtree.covers?(test_particle(0.999, 0.999)).must_equal true

      quadtree.covers?(test_particle(1, 0)).must_equal false
      quadtree.covers?(test_particle(0, 1)).must_equal false
      quadtree.covers?(test_particle(0.5, 2)).must_equal false
      quadtree.covers?(test_particle(2, 0.5)).must_equal false
      quadtree.covers?(test_particle(10, 10)).must_equal false
    end
  end

  describe "Enumerable" do
    let(:particles) { 4.times.map { test_particle } }
    let(:quadtree) { Quadtree.new(AxisAlignedBoundingBox.new(0...10, 0...10)) }
    before { particles.each { |particle| quadtree << particle } }

    it "visits all the particles" do
      Set.new(quadtree.to_a).must_equal Set.new(particles)
    end
  end

  describe "#within" do
    describe "finding particles" do
      let(:quadtree) { Quadtree.new(AxisAlignedBoundingBox.new(0...10, 0...10)) }

      let(:inside_particles) do
        [test_particle(2, 2), test_particle(3, 3), test_particle(2.5, 2.5)]
      end

      let(:outside_particles) do
        [test_particle(1, 1), test_particle(2, 3.1), test_particle(3, 0.5)]
      end

      before do
        inside_particles.each { |particle| quadtree << particle }
        outside_particles.each { |particle| quadtree << particle }
      end

      it "returns all particles within the given bounds" do
        Set.new(quadtree.within(AxisAlignedBoundingBox.new(2..3, 2..3))).must_equal Set.new(inside_particles)
      end
    end
  end

  private

  require 'ostruct'

  def test_particle(x = 1, y = 1)
    Particle.new(x: x, y: y)
  end

end
