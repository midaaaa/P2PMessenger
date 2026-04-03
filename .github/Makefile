.PHONY: setup check_xcodegen

setup: check_xcodegen
	@if [ ! -f local.yml ]; then printf "options:\n  bundleIdPrefix: dev.p2pTeam\n" > local.yml; fi
	xcodegen generate

check_xcodegen:
	@if ! command -v xcodegen > /dev/null; then \
		echo "XcodeGen not found. Installing via Homebrew..."; \
		brew install xcodegen; \
	fi
