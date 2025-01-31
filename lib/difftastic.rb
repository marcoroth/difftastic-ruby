# frozen_string_literal: true

require "difftastic/version"
require "tempfile"
require "sumi"

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
		Sumi.inspect(object, indent:, tab_width:, max_width:, max_depth:, max_instance_variables:, original_object:)
	end
end
