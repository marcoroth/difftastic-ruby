# frozen_string_literal: true

test "left and right" do
	output = Difftastic::Differ.new(color: :always, tab_width: 2, left_label: "Left", right_label: "Right").diff_objects(
		"123",
		"456"
	)
	assert_equal output, "\e[91;1mLeft                          \e[92;1mRight\e[0m\n\e[91;1m1 \e[0m\e[91m\"123\"\e[0m                       \e[92;1m1 \e[0m\e[92m\"456\"\e[0m"
end

test "only left" do
	output = Difftastic::Differ.new(color: :always, tab_width: 2, left_label: "Left").diff_objects(
		"123",
		"456"
	)
	assert_equal output, "\e[91;1mLeft                          \e[0m\n\e[91;1m1 \e[0m\e[91m\"123\"\e[0m                       \e[92;1m1 \e[0m\e[92m\"456\"\e[0m"
end

test "only right" do
	output = Difftastic::Differ.new(color: :always, tab_width: 2, right_label: "Right").diff_objects(
		"123",
		"456"
	)
	assert_equal output, "                              \e[92;1mRight\e[0m\n\e[91;1m1 \e[0m\e[91m\"123\"\e[0m                       \e[92;1m1 \e[0m\e[92m\"456\"\e[0m"
end

test "super wide diff" do
	output = Difftastic::Differ.new(color: :always, tab_width: 2, left_label: "Left", right_label: "Right").diff_objects(
		"this is a super long diff to demonstrate that the labels get positioned incorrectly",
		"this is a super long diff to demonstrate that the labels get positioned correctly",
	)

	assert_equal output, "\e[91;1mLeft                                                                                      \e[92;1mRight\e[0m\n\e[91;1m1 \e[0m\e[91m\"\e[0m\e[91mthis\e[0m\e[91m \e[0m\e[91mis\e[0m\e[91m \e[0m\e[91ma\e[0m\e[91m \e[0m\e[91msuper\e[0m\e[91m \e[0m\e[91mlong\e[0m\e[91m \e[0m\e[91mdiff\e[0m\e[91m \e[0m\e[91mto\e[0m\e[91m \e[0m\e[91mdemonstrate\e[0m\e[91m \e[0m\e[91mthat\e[0m\e[91m \e[0m\e[91mthe\e[0m\e[91m \e[0m\e[91mlabels\e[0m\e[91m \e[0m\e[91mget\e[0m\e[91m \e[0m\e[91mpositioned\e[0m\e[91m \e[0m\e[91;1;4mincorrectly\e[0m\e[91m\"\e[0m   \e[92;1m1 \e[0m\e[92m\"\e[0m\e[92mthis\e[0m\e[92m \e[0m\e[92mis\e[0m\e[92m \e[0m\e[92ma\e[0m\e[92m \e[0m\e[92msuper\e[0m\e[92m \e[0m\e[92mlong\e[0m\e[92m \e[0m\e[92mdiff\e[0m\e[92m \e[0m\e[92mto\e[0m\e[92m \e[0m\e[92mdemonstrate\e[0m\e[92m \e[0m\e[92mthat\e[0m\e[92m \e[0m\e[92mthe\e[0m\e[92m \e[0m\e[92mlabels\e[0m\e[92m \e[0m\e[92mget\e[0m\e[92m \e[0m\e[92mpositioned\e[0m\e[92m \e[0m\e[92;1;4mcorrectly\e[0m\e[92m\"\e[0m"
end
