require_relative "vertex"
require_relative "edge"
require_relative "face"

module DCEL; end

class DCEL::PolygonBuilder
  def self.polygon(vertex_values, &block)
    new(vertex_values).polygon(&block)
  end

  def initialize(vertex_values)
    @vertex_values = vertex_values
  end

  def polygon(&block)
    faces = [inner_face, outer_face]
    edges = inner_edges

    yield(faces, edges, vertices) if block_given?

    inner_face
  end

  private
  attr_reader :vertex_values

  def vertices
    @vertices ||= vertex_values.map { |value| DCEL::Vertex.new(value) }
  end

  def inner_face
    @inner_face ||= DCEL::Face.from_disjoint_edges(inner_edges)
  end

  def outer_face
    @outer_face ||= DCEL::Face.from_disjoint_edges(outer_edges)
  end

  def inner_edges
    @inner_edges ||= vertices.map { |vertex| new_edge_from_vertex(vertex) }
  end

  def outer_edges
    @outer_edges ||= inner_edges.map { |edge| new_edge_from_opposite_edge(edge) }.reverse
  end

  def new_edge_from_vertex(vertex)
    DCEL::Edge.new(origin_vertex: vertex).tap { |edge| vertex.edge = edge }
  end

  def new_edge_from_opposite_edge(edge)
    DCEL::Edge.new(origin_vertex: edge.destination_vertex).tap do |opposite_edge|
      DCEL::Edge.link_opposites(edge, opposite_edge)
    end
  end
end
