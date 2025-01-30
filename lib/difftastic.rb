# frozen_string_literal: true

require "difftastic/version"
require "tempfile"

module Difftastic
	autoload :ANSI, "difftastic/ansi"
	autoload :Differ, "difftastic/differ"
	autoload :Upstream, "difftastic/upstream"

	GEM_NAME = "difftastic"
	DEFAULT_DIR = File.expand_path(File.join(__dir__, "..", "exe"))

	class ExecutableNotFoundException < StandardError
	end

	def self.execute(command)
		`#{executable} #{command}`
	end

	def self.platform
		[:cpu, :os].map { |m| Gem::Platform.local.__send__(m) }.join("-")
	end

	def self.executable(exe_path: DEFAULT_DIR)
		difftastic_install_dir = ENV["DIFFTASTIC_INSTALL_DIR"]

		if difftastic_install_dir
			if File.directory?(difftastic_install_dir)
				warn "NOTE: using DIFFTASTIC_INSTALL_DIR to find difftastic executable: #{difftastic_install_dir}"
				exe_path = difftastic_install_dir
				exe_file = File.expand_path(File.join(difftastic_install_dir, "difft"))
			else
				raise DirectoryNotFoundException.new(<<~MESSAGE)
					DIFFTASTIC_INSTALL_DIR is set to #{difftastic_install_dir}, but that directory does not exist.
				MESSAGE
			end
		else
			if Difftastic::Upstream::NATIVE_PLATFORMS.keys.none? { |p| Gem::Platform.match_gem?(Gem::Platform.new(p), GEM_NAME) }
				raise UnsupportedPlatformException.new(<<~MESSAGE)
					difftastic-ruby does not support the #{platform} platform
					Please install difftastic following instructions at https://difftastic.io/install
				MESSAGE
			end

			exe_file = Dir.glob(File.expand_path(File.join(exe_path, "**", "difft"))).find do |f|
				Gem::Platform.match_gem?(Gem::Platform.new(File.basename(File.dirname(f))), GEM_NAME)
			end
		end

		if exe_file.nil? || !File.exist?(exe_file)
			raise ExecutableNotFoundException.new(<<~MESSAGE)
				Cannot find the difftastic executable for #{platform} in #{exe_path}

				If you're using bundler, please make sure you're on the latest bundler version:

				    gem install bundler
				    bundle update --bundler

				Then make sure your lock file includes this platform by running:

				    bundle lock --add-platform #{platform}
				    bundle install

				See `bundle lock --help` output for details.

				If you're still seeing this message after taking those steps, try running
				`bundle config` and ensure `force_ruby_platform` isn't set to `true`.
			MESSAGE
		end

		exe_file
	end

	def self.pretty(object, indent: 0, tab_width: 2, max_width: 60, max_depth: 5, max_instance_variables: 10, original_object: nil)
		return "self" if object && object == original_object

		original_object ||= object

		case object
		when Hash
			return "{}" if object.empty?

			buffer = +"{\n"
			indent += 1
			object.each do |key, value|
				buffer << ("\t" * indent)
				case key
				when Symbol
					buffer << "#{key.name}: "
				else
					buffer << pretty(key, indent:, original_object:)
					buffer << " => "
				end
				buffer << pretty(value, indent:, original_object:)
				buffer << ",\n"
			end
			indent -= 1
			buffer << ("\t" * indent)
			buffer << "}"
		when Array
			new_lines = false
			length = 0
			items = object.map do |item|
				pretty_item = pretty(item, indent: indent + 1, original_object:)
				new_lines = true if pretty_item.include?("\n")
				length += pretty_item.bytesize
				pretty_item
			end

			if new_lines || length > max_width - (indent * tab_width)
				"[\n#{"\t" * (indent + 1)}#{items.join(",\n#{"\t" * (indent + 1)}")},\n#{"\t" * indent}]"
			else
				"[#{items.join(', ')}]"
			end
		when Set
			new_lines = false
			length = 0
			items = object.to_a.sort!.map do |item|
				pretty_item = pretty(item, indent: indent + 1, original_object:)
				new_lines = true if pretty_item.include?("\n")
				length += pretty_item.bytesize
				pretty_item
			end

			if new_lines || length > max_width - (indent * tab_width)
				"Set[\n#{"\t" * (indent + 1)}#{items.join(",\n#{"\t" * (indent + 1)}")},\n#{"\t" * indent}]"
			else
				"Set[#{items.join(', ')}]"
			end
		when Module
			object.name
		when Pathname
			%(Pathname("#{object.to_path}"))
		when Symbol, String, Integer, Float, Regexp, Range, Rational, Complex, true, false, nil
			object.inspect
		else
			buffer = +""
			instance_variables = object.instance_variables
			if instance_variables.length > 0 && indent < max_depth
				buffer << "#{object.class.name}(\n"
				indent += 1

				if indent < max_depth
					object.instance_variables.take(max_instance_variables).each do |name|
						buffer << ("\t" * indent)
						buffer << name.name
						buffer << " = "

						buffer << pretty(object.instance_variable_get(name), indent:, original_object:)
						buffer << ",\n"
					end

					if object.instance_variables.count > max_instance_variables
						buffer << ("\t" * indent)
						buffer << "...\n"
					end
				else
					buffer << ("\t" * indent)
					buffer << "...\n"
				end

				indent -= 1
				buffer << ("\t" * indent)
				buffer << ")"
			elsif indent >= max_depth
				buffer << "#{object.class.name}(...)"
			else
				buffer << "#{object.class.name}()"
			end
		end
	end
end
