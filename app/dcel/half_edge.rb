module DCEL
  def self.cyclical_each_pair(enumerable, &block) # TODO: find a better place for this helper code
    enumerable.cycle.each_cons(2).take(enumerable.size).each(&block)
  end
end

class DCEL::HalfEdge

  @@instance_count = 0

  def initialize(options = {})
    @origin = options.fetch(:origin)
    @previous_half_edge = options.fetch(:previous_half_edge, nil)
    @next_half_edge = options.fetch(:next_half_edge, nil)
    @twin_half_edge = options.fetch(:twin_half_edge, nil)

    @id = (@@instance_count += 1)
  end

  def inspect
    "#<#{self.class.name}:#{id} origin=#{origin.to_s} #{inspect_links}>"
  end

  attr_reader :origin
  attr_accessor :previous_half_edge, :next_half_edge, :twin_half_edge

  def self.triangle(vertices)
    Builder.new.triangle(vertices)
  end

  def next_vertex
    return unless next_half_edge
    next_half_edge.origin
  end

  def face_edges
    next_enumerator.to_a
  end

  def subdivide_triangle(inner_vertex)
    triangle_edges = face_edges

    triangle_edges.each do |face_edge|
      inward_edge = DCEL::HalfEdge.new(origin: face_edge.next_vertex)
      outward_edge = DCEL::HalfEdge.new(origin: inner_vertex)

      Builder.new.cyclically_link([face_edge, inward_edge, outward_edge])
    end

    DCEL.cyclical_each_pair(triangle_edges) do |previous_half_edge, next_half_edge|
      inward_edge = previous_half_edge.next_half_edge
      outward_edge = next_half_edge.previous_half_edge

      Builder.new.link_twin(inward_edge, outward_edge)
    end
  end

  protected

  # attr_writer :origin
  attr_reader :id # utility

  private

  def next_enumerator
    Enumerator.new do |y|
      self.tap do |current_half_edge|
        loop do
          y.yield(current_half_edge)
          current_half_edge = current_half_edge.next_half_edge
          break if current_half_edge.nil? || current_half_edge == self
        end
      end
    end
  end

  def inspect_links
    [:previous_half_edge, :next_half_edge, :twin_half_edge].map do |m|
      "#{m}=#{send(m).id if send(m)}"
    end.join(", ")
  end

  class Builder
    def triangle(vertices)
      raise ArgumentError unless vertices.size == 3

      half_edges = vertices.map { |vertex| new_half_edge(vertex) }
      cyclically_link(half_edges)

      twin_half_edges = half_edges.map { |half_edge| new_half_edge(half_edge.next_vertex) }
      cyclically_link(twin_half_edges.reverse)

      link_twins(half_edges, twin_half_edges)

      half_edges.first
    end

    def cyclically_link(half_edges)
      DCEL.cyclical_each_pair(half_edges) do |previous_half_edge, next_half_edge|
        link_sequentially(previous_half_edge, next_half_edge)
      end
    end

    def link_twins(half_edges, twin_half_edges)
      half_edges.zip(twin_half_edges).each do |half_edge, twin_half_edge|
        link_twin(half_edge, twin_half_edge)
      end
    end

    def link_sequentially(previous_half_edge, next_half_edge)
      previous_half_edge.next_half_edge = next_half_edge
      next_half_edge.previous_half_edge = previous_half_edge
    end

    def link_twin(half_edge, twin_half_edge)
      half_edge.twin_half_edge = twin_half_edge
      twin_half_edge.twin_half_edge = half_edge
    end

    private

    def new_half_edge(vertex)
      DCEL::HalfEdge.new(origin: vertex)
    end
  end

end
