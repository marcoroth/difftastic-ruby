# frozen_string_literal: true

test do
	output = Difftastic::Differ.new(color: :always, tab_width: 2).diff_objects(
		[1, 2, 3],
		[3, 2, 1]
	)

	assert_equal output, "\e[2m1 \e[0m[                           \e[2m1 \e[0m[\n\e[91;1;4m2 \e[0m  \e[91;4m1\e[0m,                        \e[92;1;4m2 \e[0m  \e[92;4m3\e[0m,\n\e[2m3 \e[0m  2,                        \e[2m3 \e[0m  2,\n\e[91;1;4m4 \e[0m  \e[91;4m3\e[0m,                        \e[92;1;4m4 \e[0m  \e[92;4m1\e[0m,\n\e[2m5 \e[0m]                           \e[2m5 \e[0m]\n\n"
end

test "html" do
	a = "<html>\n\t<body>\n\t\t<h1>Hello, world!</h1>\n\t</body>\n</html>"
	b = "<html>\n\t<body>\n\t\t<h1>Goodbye, world!</h1>\n\t</body>\n</html>"

	output = Difftastic::Differ.new(color: :always, tab_width: 2).diff_html(a, b)

	assert_equal output, "\e[2m1 \e[0m<\e[1mhtml\e[0m>                       \e[2m1 \e[0m<\e[1mhtml\e[0m>\n\e[2m2 \e[0m  <\e[1mbody\e[0m>                     \e[2m2 \e[0m  <\e[1mbody\e[0m>\n\e[91;1;4m3 \e[0m    <\e[1mh1\e[0m>\e[91;1;4;4mHello\e[0m\e[91;4m,\e[0m\e[91;4m \e[0m\e[91;4mworld\e[0m\e[91;4m!\e[0m</\e[1mh1\e[0m>   \e[92;1;4m3 \e[0m    <\e[1mh1\e[0m>\e[92;1;4;4mGoodbye\e[0m\e[92;4m,\e[0m\e[92;4m \e[0m\e[92;4mworld\e[0m\e[92;4m!\e[0m</\e[1mh1\e[0m>\n\e[2m4 \e[0m  </\e[1mbody\e[0m>                    \e[2m4 \e[0m  </\e[1mbody\e[0m>\n\e[2m5 \e[0m</\e[1mhtml\e[0m>                      \e[2m5 \e[0m</\e[1mhtml\e[0m>\n\n"
end
