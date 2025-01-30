# frozen_string_literal: true

test "default" do
	output = Difftastic::Differ.new(color: :never).diff_objects([], [1, 2, 3])

	assert_equal output, "1 []                          1 [1, 2, 3]"
end

test "side-by-side-show-both" do
	output = Difftastic::Differ.new(color: :never, display: "side-by-side-show-both").diff_objects([], [1, 2, 3])

	assert_equal output, "1 []                          1 [1, 2, 3]"
end

test "side-by-side" do
	output = Difftastic::Differ.new(color: :never, display: "side-by-side").diff_objects([], [1, 2, 3])

	assert_equal output, "1 [1, 2, 3]"
end

test "side-by-side with left side change" do
	output = Difftastic::Differ.new(color: :never, display: "side-by-side").diff_objects([3, 2, 1], [1, 2, 3])

	assert_equal output, "1 [3, 2, 1]                   1 [1, 2, 3]"
end

test "inline" do
	output = Difftastic::Differ.new(color: :never, display: "inline").diff_objects([], [1, 2, 3])

	assert_equal output, "1    []\n   1 [1, 2, 3]"
end
