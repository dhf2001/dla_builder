require_relative "../test_helper.rb"
require_relative "../../app/transformation.rb"

describe Transformation do
  describe "#initialize" do
    it "does not blow up" do
      -> { Transformation.new }.must_be_silent
    end
  end

  describe "#==" do
    it "is true if the transformations are equal" do
      t_1 = Transformation.new(rotation: Math::PI/2, translation: Vector2D[3, 5])
      t_2 = Transformation.new(rotation: Math::PI/2, translation: Vector2D[3, 5])

      t_1.must_equal t_2
    end

    it "is false if they are not" do
      t_1 = Transformation.new(rotation: Math::PI/2, translation: Vector2D[3, 5])
      t_2 = Transformation.new(rotation: -Math::PI/2, translation: Vector2D[3, 5])

      t_1.wont_equal t_2
    end
  end

  describe "#apply" do
    describe "rotation" do
      it "applies the rotation to the given vector" do
        transformation = Transformation.new(rotation: Math::PI/2)

        vector = Vector2D[1, 0]
        result = transformation.apply(vector)

        result[0].must_be_close_to 0, 1e-10
        result[1].must_be_close_to 1, 1e-10
      end
    end

    describe "translation" do
      it "applies the translation to the given vector" do
        transformation = Transformation.new(translation: Vector2D[3, 5])
        vector = Vector2D[1, 2]
        result = transformation.apply(vector)

        result[0].must_be_close_to 4, 1e-10
        result[1].must_be_close_to 7, 1e-10
      end
    end

    describe "mixed" do
      it "applies the composed transformation, rotation first" do
        transformation = Transformation.new(rotation: Math::PI/2, translation: Vector2D[1, 1] )
        vector = Vector2D[1, 0]
        result = transformation.apply(vector)

        result[0].must_be_close_to 1, 1e-10
        result[1].must_be_close_to 2, 1e-10
      end
    end
  end

  describe "#inverse" do
    it "returns the inverse of the specified transformation" do
      transformation = Transformation.new(rotation: Math::PI/2, translation: Vector2D[1, 1] )
      inverse_transformation = transformation.inverse
      vector = Vector2D[1, 0]

      result = inverse_transformation.apply(vector)

      # first takes (1, 0) to (0, -1) then rotates ccw 1/4 turn... (-1, 0)

      result[0].must_be_close_to -1, 1e-10
      result[1].must_be_close_to 0, 1e-10
    end
  end
end
