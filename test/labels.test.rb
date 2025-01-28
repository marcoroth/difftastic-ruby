# frozen_string_literal: true

test "left and right" do
	output = Difftastic::Differ.new(color: :always, tab_width: 2, left_label: "Left", right_label: "Right").diff_objects(
		"123",
		"456"
	)
	assert_equal output, "\n\e[91;1mLeft                          \e[92;1mRight\e[0m\n\e[91;1m1 \e[0m\e[91m\"123\"\e[0m                       \e[92;1m1 \e[0m\e[92m\"456\"\e[0m\n\n"
end

test "only left" do
	output = Difftastic::Differ.new(color: :always, tab_width: 2, left_label: "Left").diff_objects(
		"123",
		"456"
	)
	assert_equal output, "\n\e[91;1mLeft                          \e[0m\n\e[91;1m1 \e[0m\e[91m\"123\"\e[0m                       \e[92;1m1 \e[0m\e[92m\"456\"\e[0m\n\n"
end

test "only right" do
	output = Difftastic::Differ.new(color: :always, tab_width: 2, right_label: "Right").diff_objects(
		"123",
		"456"
	)
	assert_equal output, "\n                              \e[92;1mRight\e[0m\n\e[91;1m1 \e[0m\e[91m\"123\"\e[0m                       \e[92;1m1 \e[0m\e[92m\"456\"\e[0m\n\n"
end

test "long line diff with color" do
	output = Difftastic::Differ.new(color: :always, tab_width: 2, left_label: "Left", right_label: "Right", width: 80).diff_objects(
		"this is a super long diff to demonstrate that the labels get positioned incorrectly",
		"this is a super long diff to demonstrate that the labels get positioned correctly",
	)

	assert_equal output, "\n\e[91;1mLeft                                      \e[92;1mRight\e[0m\n\e[91;1m1 \e[0m\e[91m\"\e[0m\e[91mthis\e[0m\e[91m \e[0m\e[91mis\e[0m\e[91m \e[0m\e[91ma\e[0m\e[91m \e[0m\e[91msuper\e[0m\e[91m \e[0m\e[91mlong\e[0m\e[91m \e[0m\e[91mdiff\e[0m\e[91m \e[0m\e[91mto\e[0m\e[91m \e[0m\e[91mdemonst\e[0m \e[92;1m1 \e[0m\e[92m\"\e[0m\e[92mthis\e[0m\e[92m \e[0m\e[92mis\e[0m\e[92m \e[0m\e[92ma\e[0m\e[92m \e[0m\e[92msuper\e[0m\e[92m \e[0m\e[92mlong\e[0m\e[92m \e[0m\e[92mdiff\e[0m\e[92m \e[0m\e[92mto\e[0m\e[92m \e[0m\e[92mdemonst\e[0m\n\e[91;1m\e[2m. \e[0m\e[0m\e[91mrate\e[0m\e[91m \e[0m\e[91mthat\e[0m\e[91m \e[0m\e[91mthe\e[0m\e[91m \e[0m\e[91mlabels\e[0m\e[91m \e[0m\e[91mget\e[0m\e[91m \e[0m\e[91mpositioned\e[0m\e[91m \e[0m\e[91;1;4mi\e[0m \e[92;1m\e[2m. \e[0m\e[0m\e[92mrate\e[0m\e[92m \e[0m\e[92mthat\e[0m\e[92m \e[0m\e[92mthe\e[0m\e[92m \e[0m\e[92mlabels\e[0m\e[92m \e[0m\e[92mget\e[0m\e[92m \e[0m\e[92mpositioned\e[0m\e[92m \e[0m\e[92;1;4mc\e[0m\n\e[91;1m\e[2m. \e[0m\e[0m\e[91;1;4mncorrectly\e[0m\e[91m\"\e[0m                           \e[92;1m\e[2m. \e[0m\e[0m\e[92;1;4morrectly\e[0m\e[92m\"\e[0m\n\n"
end

test "long line diff width=80" do
	output = Difftastic::Differ.new(color: :never, tab_width: 2, left_label: "Left", right_label: "Right", width: 80).diff_objects(
		"this is a super long diff to demonstrate that the labels get positioned incorrectly",
		"this is a super long diff to demonstrate that the labels get positioned correctly",
	)

	assert_equal output, "\n\e[91;1mLeft                                      \e[92;1mRight\e[0m\n1 \"this is a super long diff to demonst 1 \"this is a super long diff to demonst\n. rate that the labels get positioned i . rate that the labels get positioned c\n. ncorrectly\"                           . orrectly\"\n\n"
end

test "long line diff width=120" do
	output = Difftastic::Differ.new(color: :never, tab_width: 2, left_label: "Left", right_label: "Right", width: 120).diff_objects(
		"this is a super long diff to demonstrate that the labels get positioned incorrectly",
		"this is a super long diff to demonstrate that the labels get positioned correctly",
	)

	assert_equal output, "\n\e[91;1mLeft                                                          \e[92;1mRight\e[0m\n1 \"this is a super long diff to demonstrate that the labels 1 \"this is a super long diff to demonstrate that the labels\n.  get positioned incorrectly\"                              .  get positioned correctly\"\n\n"
end

test "long line diff width=150" do
	output = Difftastic::Differ.new(color: :never, tab_width: 2, left_label: "Left", right_label: "Right", width: 150).diff_objects(
		"this is a super long diff to demonstrate that the labels get positioned incorrectly",
		"this is a super long diff to demonstrate that the labels get positioned correctly",
	)

	assert_equal output, "\n\e[91;1mLeft                                                                         \e[92;1mRight\e[0m\n1 \"this is a super long diff to demonstrate that the labels get positioned 1 \"this is a super long diff to demonstrate that the labels get positioned\n.  incorrectly\"                                                            .  correctly\"\n\n"
end

test "long line diff width=180" do
	output = Difftastic::Differ.new(color: :never, tab_width: 2, left_label: "Left", right_label: "Right", width: 180).diff_objects(
		"this is a super long diff to demonstrate that the labels get positioned incorrectly",
		"this is a super long diff to demonstrate that the labels get positioned correctly",
	)

	assert_equal output, "\n\e[91;1mLeft                                                                                      \e[92;1mRight\e[0m\n1 \"this is a super long diff to demonstrate that the labels get positioned incorrectly\"   1 \"this is a super long diff to demonstrate that the labels get positioned correctly\"\n\n"
end

test "with no tab_width" do
	output = Difftastic::Differ.new(color: :always, left_label: "Left", right_label: "Right").diff_objects(
		"Left",
		"Right"
	)

	assert_equal output, "\n\e[91;1mLeft                          \e[92;1mRight\e[0m\n\e[91;1m1 \e[0m\e[91m\"Left\"\e[0m                      \e[92;1m1 \e[0m\e[92m\"Right\"\e[0m\n\n"
end
