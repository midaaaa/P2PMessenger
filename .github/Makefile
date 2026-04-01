.PHONY: setup check_xcodegen

setup: check_xcodegen
	xcodegen generate

check_xcodegen:
	@if ! command -v xcodegen > /dev/null; then \
		echo "XcodeGen not found. Installing via Homebrew..."; \
		brew install xcodegen; \
	fi
