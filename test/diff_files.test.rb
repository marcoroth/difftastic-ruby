# frozen_string_literal: true

differ = output = Difftastic::Differ.new(color: :never, tab_width: 2)

test "nil" do
	output = differ.diff_files(nil, nil)

	assert_equal output, nil
end

test "String" do
	a_path = "a_path_#{rand(10000)}.txt"
	b_path = "b_path_#{rand(10000)}.txt"

	File.write(a_path, "A")
	File.write(b_path, "B")

	output = differ.diff_files(a_path, b_path)

	begin
		assert_equal output, "1 A                           1 B"
	ensure
		FileUtils.rm(a_path)
		FileUtils.rm(b_path)
	end
end

test "Pathname" do
	a_path = "a_path_#{rand(10000)}.txt"
	b_path = "b_path_#{rand(10000)}.txt"

	a = Pathname.new(a_path)
	b = Pathname.new(b_path)

	a.write("A")
	b.write("B")

	output = differ.diff_files(a, b)

	begin
		assert_equal output, "1 A                           1 B"
	ensure
		FileUtils.rm(a_path)
		FileUtils.rm(b_path)
	end
end

test "File" do
	a_path = "a_path_#{rand(10000)}.txt"
	b_path = "b_path_#{rand(10000)}.txt"

	a = File.new(a_path, "w")
	b = File.new(b_path, "w")

	a.write("A")
	b.write("B")

	a.rewind
	b.rewind

	output = differ.diff_files(a, b)

	begin
		assert_equal output, "1 A                           1 B"
	ensure
		a.close
		b.close

		FileUtils.rm(a_path)
		FileUtils.rm(b_path)
	end
end

test "Tempfile" do
	a = Tempfile.new("a.txt")
	b = Tempfile.new("b.txt")

	a.write("A")
	a.rewind

	b.write("B")
	b.rewind

	output = differ.diff_files(a, b)

	begin
		assert_equal output, "1 A                           1 B"
	ensure
		a.unlink
		b.unlink
	end
end
