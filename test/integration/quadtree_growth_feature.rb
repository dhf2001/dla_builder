require 'rubygems'
gem 'minitest'
require 'minitest/mock'
require 'minitest/autorun'

require_relative '../../sketchbook/lib/dla.rb'

describe "Quadtree DLA Growth" do

  let(:seed) { Particle.new(0, 0, 2) }
  let(:particles) { QuadtreeParticleCollection.new }

  let(:dla) do
  	Dla.new :particles => particles, :seeds => seed, :radius => 2.0, :overlap => 0.5
  end

  it "does not blow up after growing several particles" do
    -> { 10.times { dla.grow } }.must_be_silent
    dla.size.must_equal 11
  end

end