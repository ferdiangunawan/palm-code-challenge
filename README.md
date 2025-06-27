# Palm Code Challenge - Gutenberg Books App

A Flutter application that fetches and displays books from the Gutenberg API with search functionality, infinite scroll pagination, and the ability to like/unlike books.

## Features

- 📚 **Home Screen**: Browse books from the Gutendex API with infinite scroll
- 🔍 **Search Functionality**: Real-time search with debounced queries
- ❤️ **Like/Unlike Books**: Save favorite books locally using Hive
- 📖 **Book Details**: Detailed view with Hero animations and comprehensive book information
- 🗂️ **Liked Books**: Dedicated screen for viewing saved books
- 🎨 **Modern UI**: Material 3 design with smooth animations

## Architecture

This project follows Clean Architecture principles with:

- **Presentation Layer**: Cubits for state management, Screens & Widgets
- **Domain Layer**: Repositories (interfaces)
- **Data Layer**: Repository implementations, Data sources, Models
- **Core**: Dependency injection, Network client, Storage, Routing

### Key Technologies

- **State Management**: `flutter_bloc` with Cubits
- **Navigation**: `go_router`
- **HTTP Client**: `dio`
- **Local Storage**: `hive` for liked books
- **Infinite Scroll**: `very_good_infinite_list`
- **Image Caching**: `cached_network_image`
- **Dependency Injection**: `get_it`

## Prerequisites

- Flutter SDK (>=3.7.2)
- Dart SDK (>=3.7.2)
- Make (for using Makefile commands)

### Installing Make (if you don't have it)

If you don't have Make installed on your system, you can install it using:

**Automatic installation:**
```bash
make install-make
```

**Manual installation:**

- **macOS:** 
  ```bash
  brew install make
  ```

- **Ubuntu/Debian:**
  ```bash
  sudo apt-get install make
  ```

- **CentOS/RHEL:**
  ```bash
  sudo yum install make
  ```

- **Arch Linux:**
  ```bash
  sudo pacman -S make
  ```

- **Windows:**
  - Install via Chocolatey: `choco install make`
  - Or use Windows Subsystem for Linux (WSL)
  - Or install Git Bash which includes Make

## Quick Start

### Using Makefile (Recommended)

1. **Setup development environment:**
   ```bash
   make dev
   ```
   This will get packages and generate necessary code.

2. **Run the app:**
   ```bash
   make run
   ```

3. **For specific platforms:**
   ```bash
   make run-android    # Run on Android
   make run-ios        # Run on iOS  
   make run-web        # Run on web browser
   ```

### Manual Setup

1. **Get dependencies:**
   ```bash
   flutter pub get
   ```

2. **Generate code:**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## Available Make Commands

| Command | Description |
|---------|-------------|
| `make help` | Show all available commands |
| `make install-make` | Install Make on your system (if not already installed) |
| `make dev` | Setup development environment |
| `make get` | Get Flutter packages |
| `make build` | Generate code (JSON serializable, Hive adapters) |
| `make watch` | Watch for changes and generate code automatically |
| `make run` | Run the app on connected device |
| `make run-android` | Run on Android device/emulator |
| `make run-ios` | Run on iOS device/simulator |
| `make run-web` | Run on web browser |
| `make format` | Format all Dart files |
| `make lint` | Run linter |
| `make test` | Run all tests |
| `make clean` | Clean the project |
| `make rebuild` | Clean and rebuild everything |
| `make doctor` | Run flutter doctor |

## Project Structure

```
lib/
├── app.dart                          # Main app widget
├── main.dart                         # Entry point
├── common/                           # Shared utilities
│   ├── constants/                    # App constants
│   └── utils/                        # Utility classes (ViewData, etc.)
├── core/                             # Core functionality
│   ├── di/                          # Dependency injection
│   ├── network/                     # Network client
│   ├── router/                      # App routing
│   └── storage/                     # Storage service
├── data/                            # Data layer
│   ├── datasources/                 # Remote & local data sources
│   ├── models/                      # Data models
│   └── repositories/                # Repository implementations
├── domain/                          # Domain layer
│   ├── entities/                    # Domain entities
│   └── repositories/                # Repository interfaces
└── presentation/                    # Presentation layer
    ├── book_detail/                 # Book detail feature
    ├── home/                        # Home feature
    ├── liked_books/                 # Liked books feature
    └── shared/                      # Shared widgets
```

## Development Workflow

1. **Start development:**
   ```bash
   make dev
   ```

2. **Run with hot reload:**
   ```bash
   make run
   ```

3. **Watch for code generation changes:**
   ```bash
   make watch
   ```

4. **Before committing:**
   ```bash
   make pre-commit
   ```

## API Reference

This app uses the [Gutendex API](https://gutendx.com/) - a free API for Project Gutenberg books.

### Base URL
```
https://gutendx.com
```

### Endpoints Used
- `GET /books` - Get books with pagination and search
- `GET /books/{id}` - Get specific book details

## Testing

Run tests using:
```bash
make test              # All tests
make test-unit         # Unit tests only
make test-widget       # Widget tests only
make test-coverage     # Tests with coverage
```

## Building for Release

### Android
```bash
make build-android         # Build APK
make build-android-bundle  # Build App Bundle
```

### iOS
```bash
make build-ios
```

### Web
```bash
make build-web
```

## Troubleshooting

### Common Issues

1. **Make command not found:**
   ```bash
   make install-make
   # Or install manually based on your OS (see Prerequisites section)
   ```

2. **Build runner issues:**
   ```bash
   make clean
   make build
   ```

3. **Package conflicts:**
   ```bash
   make clean
   make get
   ```

4. **Generated files missing:**
   ```bash
   make build
   ```

5. **Check Flutter installation:**
   ```bash
   make doctor
   ```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Run `make pre-commit` before committing
4. Submit a pull request

## License

This project is created for Palm Code Challenge purposes.
