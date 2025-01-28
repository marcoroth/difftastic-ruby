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

test "sets are sorted" do
	object = Set[2, 3, 1]

	assert_equal_ruby Difftastic.pretty(object), <<~RUBY.chomp
		Set: {1, 2, 3}
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
			[1, 2, 3] => Set: {1, 2, 3, 4},
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
