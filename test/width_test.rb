# frozen_string_literal: true

require_relative "test_helper"

class WidthTest < Minitest::Spec
	it "width=20" do
		output = Difftastic::Differ.new(color: :never, width: 20).diff_strings("123 456", "123 456 789")

		assert_equal "1 123 456 1 123 456\n.         .  789", output
	end

	it "width=27" do
		output = Difftastic::Differ.new(color: :never, width: 27).diff_strings("123 456", "123 456 789")

		assert_equal "1 123 456     1 123 456 789", output
	end

	it "no width" do
		output = Difftastic::Differ.new(color: :never).diff_strings("123 456", "123 456 789")

		assert_equal "1 123 456                   1 123 456 789", output
	end
end
