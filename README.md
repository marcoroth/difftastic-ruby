# Difftastic Ruby

A Ruby interface and wrapper for the wonderful [Difftastic](https://difftastic.wilfred.me.uk) CLI tool.

## Creating a Differ

First, create a differ with your configuration:

```ruby
MY_DIFFER = Difftastic::Differ.new(
  background: :dark,
  color: :always,
  left_label: "Expected",
  right_label: "Actual"
)
```

## Diffing Objects

You can diff objects with different configurations:

```ruby
a = { foo: 1, bar: [2, 3, 4] }
b = { foo: 1, bar: [2, 4, 3] }

puts MY_DIFFER.diff_objects(a, b)
```

## Diffing Ruby Code

You can diff Ruby code:

```ruby
a = <<~RUBY
  def hello
    puts "Hello, world!"
  end
RUBY

b = <<~RUBY
  def hello
    puts "Goodbye, world!"
  end
RUBY

puts MY_DIFFER.diff_ruby(a, b)
```

## Additional File Type Methods

You can also diff other file types using the following methods:

```ruby
a = "<html>\n\t<body>\n\t\t<h1>Hello, world!</h1>\n\t</body>\n</html>"
b = "<html>\n\t<body>\n\t\t<h1>Goodbye, world!</h1>\n\t</body>\n</html>"

puts MY_DIFFER.diff_html(a, b)

a = '{ "foo": 1, "bar": 2 }'
b = '{ "foo": 1, "bar": 3 }'

puts MY_DIFFER.diff_json(a, b)

a = "body { color: red; }"
b = "body { color: blue; }"

puts MY_DIFFER.diff_css(a, b)

a = "<note><to>Tove</to><from>Jani</from></note>"
b = "<note><to>Tove</to><from>John</from></note>"

puts MY_DIFFER.diff_xml(a, b)

a = "foo: 1\nbar: 2"
b = "foo: 1\nbar: 3"

puts MY_DIFFER.diff_yaml(a, b)
```

## Configuring Difftastic::Differ

You can configure the `Difftastic::Differ` instance with various options:

- `background`: Set the background color (`:dark` or `:light`).
- `color`: Set the color mode (`:always`, `:never`, or `:auto`).
- `syntax_highlight`: Enable or disable syntax highlighting (`:on` or `:off`).
- `context`: Set the number of context lines to display.
- `width`: Use this many columns when calculating line wrapping. If not specified, difftastic will detect the terminal width.
- `tab_width`: Set the tab width for indentation.
- `parse_error_limit`: Set the limit for parse errors.
- `underline_highlights`: Enable or disable underlining highlights (`true` or `false`).
- `left_label`: Set the label for the left side of the diff.
- `right_label`: Set the label for the right side of the diff.
- `display`: Set the display mode (`"side-by-side-show-both"`, `"side-by-side"`, or `"inline"`).

## Pretty Method

The `Difftastic` module includes a `pretty` method for formatting objects:

```ruby
object = { foo: 1, bar: [2, 3, 4] }
formatted_object = Difftastic.pretty(object)
puts formatted_object
```
