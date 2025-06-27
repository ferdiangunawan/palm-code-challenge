# Flutter Palm Code Challenge Makefile

.PHONY: help install-make install build clean test format lint run-android run-ios run-web get-packages build-runner watch-build

# Default target
help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "If you don't have Make installed, run: make install-make"

install-make: ## Install Make on your system
	@echo "Installing Make..."
	@if command -v brew >/dev/null 2>&1; then \
		echo "Installing Make via Homebrew..."; \
		brew install make; \
	elif command -v apt-get >/dev/null 2>&1; then \
		echo "Installing Make via apt-get..."; \
		sudo apt-get update && sudo apt-get install -y make; \
	elif command -v yum >/dev/null 2>&1; then \
		echo "Installing Make via yum..."; \
		sudo yum install -y make; \
	elif command -v pacman >/dev/null 2>&1; then \
		echo "Installing Make via pacman..."; \
		sudo pacman -S make; \
	else \
		echo "❌ Could not detect package manager."; \
		echo "Please install Make manually:"; \
		echo "  - macOS: brew install make"; \
		echo "  - Ubuntu/Debian: sudo apt-get install make"; \
		echo "  - CentOS/RHEL: sudo yum install make"; \
		echo "  - Arch: sudo pacman -S make"; \
		echo "  - Windows: Install via Chocolatey (choco install make) or use WSL"; \
	fi

# Package management
get: ## Get Flutter packages
	flutter pub get

install: get ## Install dependencies (alias for get)

clean: ## Clean the project
	flutter clean
	flutter pub get

# Code generation
build: ## Generate code (json_serializable, hive adapters)
	dart run build_runner build --delete-conflicting-outputs

watch: ## Watch for changes and generate code automatically
	dart run build_runner watch --delete-conflicting-outputs

# Running the app
run: ## Run the app on connected device
	flutter run

run-android: ## Run the app on Android device/emulator
	flutter run -d android

run-ios: ## Run the app on iOS device/simulator
	flutter run -d ios

run-web: ## Run the app on web browser
	flutter run -d web-server --web-port 8080

# Development
dev: get build ## Setup development environment (get packages + generate code)

hot-restart: ## Perform hot restart
	flutter run --hot

# Code quality
format: ## Format all Dart files
	dart format .

lint: ## Run linter
	flutter analyze

fix: ## Fix linting issues automatically
	dart fix --apply

# Testing
test: ## Run all tests
	flutter test

test-unit: ## Run unit tests only
	flutter test test/unit/

test-widget: ## Run widget tests only
	flutter test test/widget/

test-coverage: ## Run tests with coverage
	flutter test --coverage
	genhtml coverage/lcov.info -o coverage/html

# Build for release
build-android: ## Build APK for Android
	flutter build apk --release

build-android-bundle: ## Build App Bundle for Android
	flutter build appbundle --release

build-ios: ## Build for iOS
	flutter build ios --release

build-web: ## Build for web
	flutter build web --release

# Debugging
debug-android: ## Debug on Android
	flutter run --debug -d android

debug-ios: ## Debug on iOS
	flutter run --debug -d ios

# Clean and rebuild
rebuild: clean dev ## Clean project and rebuild everything

# Flutter doctor
doctor: ## Run flutter doctor
	flutter doctor

# Dependencies update
upgrade: ## Upgrade Flutter packages
	flutter pub upgrade

# Git hooks (if you want to add pre-commit hooks)
pre-commit: format lint test ## Run format, lint, and test (good for git hooks)
