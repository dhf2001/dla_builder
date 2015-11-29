require_relative "../../test_helper.rb"
require_relative "../../../app/dcel/half_edge"

def test_vertex
  Object.new
end

def test_half_edge
  DCEL::HalfEdge.new(origin: test_vertex)
end

def test_triangle
  DCEL::HalfEdge.singleton(origin: test_vertex).tap do |half_edge|
    half_edge.link_vertex(test_vertex)
    half_edge.next_half_edge.link_vertex(test_vertex)
  end
end

describe DCEL::HalfEdge do

  describe "#next_half_edge/#previous_half_edge/#twin_half_edge/#origin" do
    it "has readers for connected components" do
      origin_vertex = test_vertex
      previous_half_edge = test_half_edge
      next_half_edge = test_half_edge
      twin_half_edge = test_half_edge

      half_edge = DCEL::HalfEdge.new(
        origin: origin_vertex,
        previous_half_edge: previous_half_edge,
        next_half_edge: next_half_edge,
        twin_half_edge: twin_half_edge
      )

      half_edge.origin.must_equal(origin_vertex)
      half_edge.previous_half_edge.must_equal(previous_half_edge)
      half_edge.next_half_edge.must_equal(next_half_edge)
      half_edge.twin_half_edge.must_equal(twin_half_edge)
    end
  end

  describe ".singleton" do
    it "creates a half-edge that is it's own twin, next and previous edge" do
      origin = Object.new

      half_edge = DCEL::HalfEdge.singleton(origin: origin)
      half_edge.twin_half_edge.must_equal(half_edge)
      half_edge.next_half_edge.must_equal(half_edge)
      half_edge.previous_half_edge.must_equal(half_edge)
    end
  end

  describe "#link_vertex" do
    it "links a singleton half-edge to a new vertex by creating a new half edge" do
      vertex_0 = Object.new
      vertex_1 = Object.new

      half_edge_0 = DCEL::HalfEdge.singleton(origin: vertex_0)

      half_edge_0.link_vertex(vertex_1)
      half_edge_1 = half_edge_0.twin_half_edge

      half_edge_1.wont_equal(half_edge_0)
      half_edge_1.origin.must_equal(vertex_1)

      half_edge_0.previous_half_edge.must_equal(half_edge_1)
      half_edge_0.next_half_edge.must_equal(half_edge_1)
      half_edge_0.twin_half_edge.must_equal(half_edge_1)

      half_edge_1.previous_half_edge.must_equal(half_edge_0)
      half_edge_1.next_half_edge.must_equal(half_edge_0)
      half_edge_1.twin_half_edge.must_equal(half_edge_0)
    end
  end

  #   it "links a connected half-edge by connecting a new triangle" do
  #     half_edge_0 = DCEL::HalfEdge.singleton(origin: Object.new)
  #     half_edge_0.link_vertex(Object.new)
  #
  #     half_edge = half_edge_0.next_half_edge
  #     next_vertex = Object.new
  #
  #     half_edge.link_vertex(next_vertex)
  #
  #     half_edge.next_half_edge.wont_equal(nil)
  #     half_edge.next_half_edge.origin.must_equal(next_vertex)
  #     half_edge.twin_half_edge.origin.must_equal(next_vertex)
  #
  #     half_edge.next_half_edge.twin_half_edge.wont_equal(nil)
  #     half_edge.next_half_edge.twin_half_edge.origin.must_equal(half_edge_0.origin) # triangle
  #   end
  # end
  #
  # describe "#triangle?" do
  #   it "returns true when an edge is part of a closed triangle" do
  #     test_triangle.triangle?.must_equal(true)
  #   end
  # end

end
