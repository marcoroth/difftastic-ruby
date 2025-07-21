# frozen_string_literal: true

module Difftastic
	module Upstream
		VERSION = "0.62.0"

		NATIVE_PLATFORMS = {
			"arm64-darwin" => "difft-aarch64-apple-darwin.tar.gz",
			"arm64-linux" => "difft-aarch64-unknown-linux-gnu.tar.gz",
			"aarch64-linux" => "difft-aarch64-unknown-linux-gnu.tar.gz",
			"x86_64-darwin" => "difft-x86_64-apple-darwin.tar.gz",
			"x86_64-linux" => "difft-x86_64-unknown-linux-gnu.tar.gz",
		}.freeze
	end
end
