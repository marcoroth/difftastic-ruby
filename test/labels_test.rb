# frozen_string_literal: true

require_relative "test_helper"

class LabelsTest < Minitest::Spec
	it "labels left and right" do
		output = Difftastic::Differ.new(color: :always, tab_width: 2, left_label: "Left", right_label: "Right").diff_objects(
			"123",
			"456"
		)
		assert_equal "\e[91;1mLeft                         \e[92;1mRight\e[0m\n\e[91;1m1 \e[0m\e[91m\"123\"\e[0m                     \e[92;1m1 \e[0m\e[92m\"456\"\e[0m", output
	end

	it "labels only left" do
		output = Difftastic::Differ.new(color: :always, tab_width: 2, left_label: "Left").diff_objects(
			"123",
			"456"
		)
		assert_equal "\e[91;1mLeft                         \e[0m\n\e[91;1m1 \e[0m\e[91m\"123\"\e[0m                     \e[92;1m1 \e[0m\e[92m\"456\"\e[0m", output
	end

	it "labels only right" do
		output = Difftastic::Differ.new(color: :always, tab_width: 2, right_label: "Right").diff_objects(
			"123",
			"456"
		)
		assert_equal "                             \e[92;1mRight\e[0m\n\e[91;1m1 \e[0m\e[91m\"123\"\e[0m                     \e[92;1m1 \e[0m\e[92m\"456\"\e[0m", output
	end

	it "labels long line diff with color" do
		output = Difftastic::Differ.new(color: :always, tab_width: 2, left_label: "Left", right_label: "Right", width: 80).diff_objects(
			"this is a super long diff to demonstrate that the labels get positioned incorrectly",
			"this is a super long diff to demonstrate that the labels get positioned correctly",
		)

		assert_equal "\e[91;1mLeft                                      \e[92;1mRight\e[0m\n\e[91;1m1 \e[0m\e[91m\"this is a super long diff to demonst\e[0m \e[92;1m1 \e[0m\e[92m\"this is a super long diff to demonst\e[0m\n\e[91;1m\e[2m. \e[0m\e[0m\e[91mrate that the labels get positioned \e[0m\e[91;1;4mi\e[0m \e[92;1m\e[2m. \e[0m\e[0m\e[92mrate that the labels get positioned \e[0m\e[92;1;4mc\e[0m\n\e[91;1m\e[2m. \e[0m\e[0m\e[91;1;4mncorrectly\e[0m\e[91m\"\e[0m                           \e[92;1m\e[2m. \e[0m\e[0m\e[92;1;4morrectly\e[0m\e[92m\"\e[0m", output
	end

	it "labels long line diff width=80" do
		output = Difftastic::Differ.new(color: :never, tab_width: 2, left_label: "Left", right_label: "Right", width: 80).diff_objects(
			"this is a super long diff to demonstrate that the labels get positioned incorrectly",
			"this is a super long diff to demonstrate that the labels get positioned correctly",
		)

		assert_equal "\e[91;1mLeft                                      \e[92;1mRight\e[0m\n1 \"this is a super long diff to demonst 1 \"this is a super long diff to demonst\n. rate that the labels get positioned i . rate that the labels get positioned c\n. ncorrectly\"                           . orrectly\"", output
	end

	it "labels long line diff width=120" do
		output = Difftastic::Differ.new(color: :never, tab_width: 2, left_label: "Left", right_label: "Right", width: 120).diff_objects(
			"this is a super long diff to demonstrate that the labels get positioned incorrectly",
			"this is a super long diff to demonstrate that the labels get positioned correctly",
		)

		assert_equal "\e[91;1mLeft                                                          \e[92;1mRight\e[0m\n1 \"this is a super long diff to demonstrate that the labels 1 \"this is a super long diff to demonstrate that the labels\n.  get positioned incorrectly\"                              .  get positioned correctly\"", output
	end

	it "labels long line diff width=150" do
		output = Difftastic::Differ.new(color: :never, tab_width: 2, left_label: "Left", right_label: "Right", width: 150).diff_objects(
			"this is a super long diff to demonstrate that the labels get positioned incorrectly",
			"this is a super long diff to demonstrate that the labels get positioned correctly",
		)

		assert_equal "\e[91;1mLeft                                                                         \e[92;1mRight\e[0m\n1 \"this is a super long diff to demonstrate that the labels get positioned 1 \"this is a super long diff to demonstrate that the labels get positioned\n.  incorrectly\"                                                            .  correctly\"", output
	end

	it "labels long line diff width=180" do
		output = Difftastic::Differ.new(color: :never, tab_width: 2, left_label: "Left", right_label: "Right", width: 180).diff_objects(
			"this is a super long diff to demonstrate that the labels get positioned incorrectly",
			"this is a super long diff to demonstrate that the labels get positioned correctly",
		)

		assert_equal "\e[91;1mLeft                                                                                        \e[92;1mRight\e[0m\n1 \"this is a super long diff to demonstrate that the labels get positioned incorrectly\" 1 \"this is a super long diff to demonstrate that the labels get positioned correctly\"", output
	end

	it "labels with no tab_width" do
		output = Difftastic::Differ.new(color: :always, left_label: "Left", right_label: "Right").diff_objects(
			"Left",
			"Right"
		)

		assert_equal "\e[91;1mLeft                         \e[92;1mRight\e[0m\n\e[91;1m1 \e[0m\e[91m\"Left\"\e[0m                    \e[92;1m1 \e[0m\e[92m\"Right\"\e[0m", output
	end
end
