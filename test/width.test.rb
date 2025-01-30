# frozen_string_literal: true

test "width=20" do
	output = Difftastic::Differ.new(color: :never, width: 20).diff_strings("123 456", "123 456 789")

	assert_equal output, "1 123 456 1 123 456\n.         .  789"
end

test "width=27" do
	output = Difftastic::Differ.new(color: :never, width: 27).diff_strings("123 456", "123 456 789")

	assert_equal output, "1 123 456     1 123 456 789"
end

test "no width" do
	output = Difftastic::Differ.new(color: :never).diff_strings("123 456", "123 456 789")

	assert_equal output, "1 123 456                     1 123 456 789"
end
