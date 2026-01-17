# frozen_string_literal: true

require_relative "test_helper"

class DiffObjectsAdaptiveTest < Minitest::Spec
	# Use smaller values than the gem's defaults to keep tests fast.
	# The adaptive logic works the same regardless of the actual values.
	TEST_MAX_DEPTH = 3
	TEST_MAX_ITEMS = 5
	TEST_INCREMENT = 1

	def differ(**options)
		Difftastic::Differ.new(
			color: :never,
			max_depth: TEST_MAX_DEPTH,
			max_items: TEST_MAX_ITEMS,
			max_depth_increment: TEST_INCREMENT,
			max_items_increment: TEST_INCREMENT,
			**options # overrides defaults when provided
		)
	end

	# Example:
	#   nested_hash(4, "x")
	#   # => { l1: { l2: { l3: { l4: "x" } } } }
	def nested_hash(depth, leaf_value)
		(1..depth).reverse_each.reduce(leaf_value) { |inner, i| { "l#{i}": inner } }
	end

	# Example:
	#   array_with_diff_at(4, "x")
	#   # => [1, 2, 3, "x"]
	def array_with_diff_at(position, value)
		(1...position).to_a + [value]
	end

	describe "adaptive max_depth" do
		it "shows diff at exactly TEST_MAX_DEPTH" do
			old = nested_hash(TEST_MAX_DEPTH, "old")
			new = nested_hash(TEST_MAX_DEPTH, "new")

			output = differ.diff_objects(old, new)

			refute_includes output, "No changes"
			assert_includes output, "old"
			assert_includes output, "new"
		end

		it "shows diff at TEST_MAX_DEPTH + 1 (requires adaptation)" do
			depth = TEST_MAX_DEPTH + 1
			old = nested_hash(depth, "old")
			new = nested_hash(depth, "new")

			output = differ.diff_objects(old, new)

			refute_includes output, "No changes"
			assert_includes output, "old"
			assert_includes output, "new"
		end

		it "shows diff at 2 * TEST_MAX_DEPTH (requires multiple adaptations)" do
			depth = 2 * TEST_MAX_DEPTH
			old = nested_hash(depth, "old")
			new = nested_hash(depth, "new")

			output = differ.diff_objects(old, new)

			refute_includes output, "No changes"
			assert_includes output, "old"
			assert_includes output, "new"
		end
	end

	describe "adaptive max_items" do
		it "shows diff at exactly TEST_MAX_ITEMS" do
			old = array_with_diff_at(TEST_MAX_ITEMS, "old")
			new = array_with_diff_at(TEST_MAX_ITEMS, "new")

			output = differ.diff_objects(old, new)

			refute_includes output, "No changes"
			assert_includes output, "old"
			assert_includes output, "new"
		end

		it "shows diff at TEST_MAX_ITEMS + 1 (requires adaptation)" do
			position = TEST_MAX_ITEMS + 1
			old = array_with_diff_at(position, "old")
			new = array_with_diff_at(position, "new")

			output = differ.diff_objects(old, new)

			refute_includes output, "No changes"
			assert_includes output, "old"
			assert_includes output, "new"
		end

		it "shows diff at 2 * TEST_MAX_ITEMS (requires multiple adaptations)" do
			position = 2 * TEST_MAX_ITEMS
			old = array_with_diff_at(position, "old")
			new = array_with_diff_at(position, "new")

			output = differ.diff_objects(old, new)

			refute_includes output, "No changes"
			assert_includes output, "old"
			assert_includes output, "new"
		end
	end

	describe "configurable starting values" do
		it "respects custom max_depth" do
			depth = TEST_MAX_DEPTH - 2
			old = nested_hash(depth, "old")
			new = nested_hash(depth, "new")

			output = differ(max_depth: 1).diff_objects(old, new)

			refute_includes output, "No changes"
			assert_includes output, "old"
			assert_includes output, "new"
		end

		it "respects custom max_items" do
			position = TEST_MAX_ITEMS - 2
			old = array_with_diff_at(position, "old")
			new = array_with_diff_at(position, "new")

			output = differ(max_items: 1).diff_objects(old, new)

			refute_includes output, "No changes"
			assert_includes output, "old"
			assert_includes output, "new"
		end
	end

	describe "configurable caps" do
		it "respects custom max_depth_cap" do
			depth = TEST_MAX_DEPTH + 3
			old = nested_hash(depth, "old")
			new = nested_hash(depth, "new")

			output = differ(max_depth_cap: depth + 1).diff_objects(old, new)

			refute_includes output, "No changes"
			assert_includes output, "old"
			assert_includes output, "new"
		end

		it "respects custom max_items_cap" do
			position = TEST_MAX_ITEMS + 5
			old = array_with_diff_at(position, "old")
			new = array_with_diff_at(position, "new")

			output = differ(max_items_cap: position + 1).diff_objects(old, new)

			refute_includes output, "No changes"
			assert_includes output, "old"
			assert_includes output, "new"
		end
	end

	describe "loop termination at caps" do
		it "returns unavailable message when depth exceeds max_depth_cap" do
			cap = TEST_MAX_DEPTH + 2
			depth = cap + 1
			old = nested_hash(depth, "old")
			new = nested_hash(depth, "new")

			output = differ(max_depth_cap: cap).diff_objects(old, new)

			assert_includes output, Difftastic::Differ::DIFF_UNAVAILABLE_MESSAGE
		end

		it "returns unavailable message when position exceeds max_items_cap" do
			cap = TEST_MAX_ITEMS + 5
			position = cap + 1
			old = array_with_diff_at(position, "old")
			new = array_with_diff_at(position, "new")

			output = differ(max_items_cap: cap).diff_objects(old, new)

			assert_includes output, Difftastic::Differ::DIFF_UNAVAILABLE_MESSAGE
		end
	end
end
