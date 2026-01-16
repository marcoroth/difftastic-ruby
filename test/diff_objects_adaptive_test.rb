# frozen_string_literal: true

require_relative "test_helper"

class DiffObjectsAdaptiveTest < Minitest::Spec
	DEFAULT_MAX_DEPTH = Difftastic::Differ::DEFAULT_MAX_DEPTH
	DEFAULT_MAX_ITEMS = Difftastic::Differ::DEFAULT_MAX_ITEMS

	def nested_hash(depth, leaf_value)
		(1..depth).reverse_each.reduce(leaf_value) { |inner, i| { "l#{i}": inner } }
	end

	def array_with_diff_at(position, value)
		(1...position).to_a + [value]
	end

	describe "adaptive max_depth" do
		it "shows diff at exactly DEFAULT_MAX_DEPTH" do
			old = nested_hash(DEFAULT_MAX_DEPTH, "old")
			new = nested_hash(DEFAULT_MAX_DEPTH, "new")

			output = Difftastic::Differ.new(color: :never).diff_objects(old, new)

			refute_includes output, "No changes"
			assert_includes output, "old"
			assert_includes output, "new"
		end

		it "shows diff at DEFAULT_MAX_DEPTH + 1 (requires adaptation)" do
			depth = DEFAULT_MAX_DEPTH + 1
			old = nested_hash(depth, "old")
			new = nested_hash(depth, "new")

			output = Difftastic::Differ.new(color: :never).diff_objects(old, new)

			refute_includes output, "No changes"
			assert_includes output, "old"
			assert_includes output, "new"
		end

		it "shows diff at 2 * DEFAULT_MAX_DEPTH (requires multiple adaptations)" do
			depth = 2 * DEFAULT_MAX_DEPTH
			old = nested_hash(depth, "old")
			new = nested_hash(depth, "new")

			output = Difftastic::Differ.new(color: :never).diff_objects(old, new)

			refute_includes output, "No changes"
			assert_includes output, "old"
			assert_includes output, "new"
		end
	end

	describe "adaptive max_items" do
		it "shows diff at exactly DEFAULT_MAX_ITEMS" do
			old = array_with_diff_at(DEFAULT_MAX_ITEMS, "old")
			new = array_with_diff_at(DEFAULT_MAX_ITEMS, "new")

			output = Difftastic::Differ.new(color: :never).diff_objects(old, new)

			refute_includes output, "No changes"
			assert_includes output, "old"
			assert_includes output, "new"
		end

		it "shows diff at DEFAULT_MAX_ITEMS + 1 (requires adaptation)" do
			position = DEFAULT_MAX_ITEMS + 1
			old = array_with_diff_at(position, "old")
			new = array_with_diff_at(position, "new")

			output = Difftastic::Differ.new(color: :never).diff_objects(old, new)

			refute_includes output, "No changes"
			assert_includes output, "old"
			assert_includes output, "new"
		end

		it "shows diff at 2 * DEFAULT_MAX_ITEMS (requires multiple adaptations)" do
			position = 2 * DEFAULT_MAX_ITEMS
			old = array_with_diff_at(position, "old")
			new = array_with_diff_at(position, "new")

			output = Difftastic::Differ.new(color: :never).diff_objects(old, new)

			refute_includes output, "No changes"
			assert_includes output, "old"
			assert_includes output, "new"
		end
	end

	describe "configurable starting values" do
		it "respects custom max_depth" do
			depth = DEFAULT_MAX_DEPTH - 2
			old = nested_hash(depth, "old")
			new = nested_hash(depth, "new")

			output = Difftastic::Differ.new(color: :never, max_depth: 1).diff_objects(old, new)

			refute_includes output, "No changes"
		end

		it "respects custom max_items" do
			position = DEFAULT_MAX_ITEMS - 5
			old = array_with_diff_at(position, "old")
			new = array_with_diff_at(position, "new")

			output = Difftastic::Differ.new(color: :never, max_items: 2).diff_objects(old, new)

			refute_includes output, "No changes"
		end
	end

	describe "configurable caps" do
		it "respects custom max_depth_cap" do
			depth = DEFAULT_MAX_DEPTH + 3
			old = nested_hash(depth, "old")
			new = nested_hash(depth, "new")

			output = Difftastic::Differ.new(color: :never, max_depth_cap: depth + 1).diff_objects(old, new)

			refute_includes output, "No changes"
		end

		it "respects custom max_items_cap" do
			position = DEFAULT_MAX_ITEMS + 5
			old = array_with_diff_at(position, "old")
			new = array_with_diff_at(position, "new")

			output = Difftastic::Differ.new(color: :never, max_items_cap: position + 1).diff_objects(old, new)

			refute_includes output, "No changes"
		end
	end

	describe "real-world structures" do
		it "handles typical API request body" do
			old = {
				type: "Request",
				positions: [{
					address: {
						sender: { postalCode: "41564", city: "Kaarst" }
					}
				}]
			}
			new = {
				type: "Request",
				positions: [{
					address: {
						sender: { postalCode: "99999", city: "Berlin" }
					}
				}]
			}

			output = Difftastic::Differ.new(color: :never).diff_objects(old, new)

			refute_includes output, "No changes"
			assert_includes output, "41564"
			assert_includes output, "99999"
		end
	end
end
