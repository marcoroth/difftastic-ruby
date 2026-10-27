# frozen_string_literal: true

require_relative "test_helper"
require "tmpdir"

class ShellTest < Minitest::Spec
	it "diff_files with spaces, quotes and command substitution in paths" do
		Dir.mktmpdir do |dir|
			Dir.chdir(dir) do
				File.write("a $(touch injected).txt", "A")
				File.write("b 'quoted\".txt", "B")

				output = Difftastic::Differ.new(color: :never, tab_width: 2).diff_files("a $(touch injected).txt", "b 'quoted\".txt")

				assert_equal "1 A                         1 B", output
			end
		end
	end

	it "diff_files does not run command substitution in paths" do
		Dir.mktmpdir do |dir|
			Dir.chdir(dir) do
				File.write("a $(touch injected).txt", "A")
				File.write("b.txt", "B")

				Difftastic::Differ.new(color: :never, tab_width: 2).diff_files("a $(touch injected).txt", "b.txt")

				refute File.exist?("injected")
			end
		end
	end

	it "diff_strings with a temporary directory containing a space" do
		original_tmpdir = ENV["TMPDIR"]

		Dir.mktmpdir do |parent|
			dir = File.join(parent, "with space")
			Dir.mkdir(dir, 0o700)
			ENV["TMPDIR"] = dir

			output = Difftastic::Differ.new(color: :never, tab_width: 2).diff_strings("A", "B")

			assert_equal "1 A                         1 B", output
		ensure
			ENV["TMPDIR"] = original_tmpdir
		end
	end

	it "diff_strings with every option set" do
		differ = Difftastic::Differ.new(color: :never, context: 3, background: :dark, syntax_highlight: :off, tab_width: 2, width: 80)

		assert_equal "1 A                         1 B", differ.diff_strings("A", "B")
	end
end
