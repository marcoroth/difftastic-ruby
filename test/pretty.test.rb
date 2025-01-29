# frozen_string_literal: true

test "objects" do
	assert_equal_ruby Difftastic.pretty(Example.new), <<~RUBY.chomp
		Example(
			:@foo => 1,
			:@bar => [2, 3, 4],
		)
	RUBY
end

test "object with no properties" do
	assert_equal_ruby Difftastic.pretty(Object.new), <<~RUBY.chomp
		Object()
	RUBY
end

test "empty set" do
	assert_equal_ruby Difftastic.pretty(Set.new), "Set[]"
end

test "empty array" do
	assert_equal_ruby Difftastic.pretty([]), "[]"
end

test "empty object" do
	assert_equal_ruby Difftastic.pretty({}), "{}"
end

test "empty string" do
	assert_equal_ruby Difftastic.pretty(""), %("")
end

test "empty symbol" do
	assert_equal_ruby Difftastic.pretty(:""), %(:"")
end

test "sets are sorted" do
	object = Set[2, 3, 1]

	assert_equal_ruby Difftastic.pretty(object), <<~RUBY.chomp
		Set[1, 2, 3]
	RUBY
end

test "nested hashes" do
	object = {
		foo: {
			bar: {
				baz: 1,
			},
		},
	}

	assert_equal_ruby Difftastic.pretty(object), <<~RUBY.chomp
		{
			foo: {
				bar: {
					baz: 1,
				},
			},
		}
	RUBY
end

test "nested arrays" do
	object = [[1, 2], [3, 4]]

	assert_equal_ruby Difftastic.pretty(object), <<~RUBY.chomp
		[[1, 2], [3, 4]]
	RUBY
end

test "long arrays" do
	object = [
		"One",
		"Two",
		"Three",
		"Four",
		"Five",
		"Six",
		"Seven",
		"Eight",
		"Nine",
		"Ten",
		"Eleven",
		"Twelve",
		"Thirteen",
		"Fourteen",
		"Fifteen",
		"Sixteen",
		"Seventeen",
		"Eighteen",
		"Nineteen",
		"Twenty",
		["A", "B", "C"],
		{
			:a => [1, 2, 3],
			:b => {
				"c" => 1.3232332,
				[1, 2, 3] => Set[4, 3, 2, 1],
			},
		},
		[
			"One",
			"Two",
			"Three",
			"Four",
			"Five",
			"Six",
			"Seven",
			"Eight",
			"Nine",
			"Ten",
			"Eleven",
			"Twelve",
			"Thirteen",
			"Fourteen",
			"Fifteen",
			"Sixteen",
			"Seventeen",
			"Eighteen",
			"Nineteen",
			"Twenty",
		],
	]

	assert_equal_ruby Difftastic.pretty(object), <<-RUBY.chomp
[
	"One",
	"Two",
	"Three",
	"Four",
	"Five",
	"Six",
	"Seven",
	"Eight",
	"Nine",
	"Ten",
	"Eleven",
	"Twelve",
	"Thirteen",
	"Fourteen",
	"Fifteen",
	"Sixteen",
	"Seventeen",
	"Eighteen",
	"Nineteen",
	"Twenty",
	["A", "B", "C"],
	{
		a: [1, 2, 3],
		b: {
			"c" => 1.3232332,
			[1, 2, 3] => Set[1, 2, 3, 4],
		},
	},
	[
		"One",
		"Two",
		"Three",
		"Four",
		"Five",
		"Six",
		"Seven",
		"Eight",
		"Nine",
		"Ten",
		"Eleven",
		"Twelve",
		"Thirteen",
		"Fourteen",
		"Fifteen",
		"Sixteen",
		"Seventeen",
		"Eighteen",
		"Nineteen",
		"Twenty",
	],
]
	RUBY
end

test "module and class" do
	assert_equal_ruby Difftastic.pretty([Difftastic, Integer]), <<~RUBY.chomp
		[Difftastic, Integer]
	RUBY
end

test "pathname" do
	assert_equal_ruby Difftastic.pretty(Pathname.new("")), <<~RUBY.chomp
		Pathname("")
	RUBY

	assert_equal_ruby Difftastic.pretty(Pathname.new("/")), <<~RUBY.chomp
		Pathname("/")
	RUBY

	assert_equal_ruby Difftastic.pretty(Pathname.new("/path/to/somewhere.txt")), <<~RUBY.chomp
		Pathname("/path/to/somewhere.txt")
	RUBY
end

test "self-referencing" do
	array = [1, 2, 3]

	object = {
		id: 1,
		array:,
	}

	sibling = {
		id: 2,
		array: array.reverse,
		previous_sibling: object,
	}

	parent = {
		object:,
		self_twice: [object, object]
	}

	object[:parent] = parent
	object[:next_sibling] = sibling

	parent[:children] = [
		object,
		sibling,
	]

	assert_equal_ruby Difftastic.pretty(object), <<~RUBY.chomp
		{
			id: 1,
			array: [1, 2, 3],
			parent: {
				object: self,
				self_twice: [self, self],
				children: [
					self,
					{
						id: 2,
						array: [3, 2, 1],
						previous_sibling: self,
					},
				],
			},
			next_sibling: {
				id: 2,
				array: [3, 2, 1],
				previous_sibling: self,
			},
		}
	RUBY
end

test "max_instance_variables" do
	object = Object.new

	1.upto(30) do |i|
		object.instance_variable_set(:"@variable_#{i}", i)
	end

	assert_equal_ruby Difftastic.pretty(object), <<~RUBY.chomp
		Object(
			:@variable_1 => 1,
			:@variable_2 => 2,
			:@variable_3 => 3,
			:@variable_4 => 4,
			:@variable_5 => 5,
			:@variable_6 => 6,
			:@variable_7 => 7,
			:@variable_8 => 8,
			:@variable_9 => 9,
			:@variable_10 => 10,
			...
		)
	RUBY
end

test "max_depth" do
	max_depth = Class.new do
		def self.name
			"MaxDepth"
		end

		def initialize(value)
			@value = value
		end
	end

	level4 = max_depth.new(["level4"])
	level3 = max_depth.new(["level3", level4])
	level2 = max_depth.new(["level2", level3])
	level1 = max_depth.new(["level1", level2])
	object = max_depth.new(["object", level1])

	assert_equal_ruby Difftastic.pretty(object, max_width: 300), <<~RUBY.chomp
		MaxDepth(
			:@value => [
				"object",
				MaxDepth(
					:@value => [
						"level1",
						MaxDepth(
							...
						),
					],
				),
			],
		)
	RUBY
end
