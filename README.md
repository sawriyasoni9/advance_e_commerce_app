# Advance E-Commerce App

A modern, feature-rich e-commerce mobile application built with Flutter, following clean
architecture principles and best practices. This app demonstrates a complete shopping experience
with product browsing, cart management, and detailed product views.

## 📱 Overview

This e-commerce application provides users with an intuitive interface to:

- Browse products from an online store
- View detailed product information including images, descriptions, ratings, and prices
- Manage a shopping cart with add/remove/quantity management
- Monitor internet connectivity status
- Persist cart data across app restarts

## ✨ Features

### Core Functionality

- **Product Catalog**: Browse products in a grid layout with images and basic information
- **Product Details**: View comprehensive product information including:
    - High-quality product images
    - Detailed descriptions
    - Price information
    - Customer ratings and reviews
    - Category classification
- **Shopping Cart Management**:
    - Add/remove products from cart
    - Adjust product quantities
    - Real-time total price calculation
    - Cart persistence across app sessions
- **Internet Connectivity Monitoring**: Real-time network status detection with visual indicators
- **Image Caching**: Efficient network image loading with caching for better performance
- **Smooth Navigation**: Custom animated transitions between screens
- **Error Handling**: Comprehensive error states with retry mechanisms
- **Loading States**: Visual feedback during data fetching operations

## 🏗️ Architecture & Design Patterns

### Architecture Pattern

The application follows **Clean Architecture** principles with clear separation of concerns:

### Design Patterns Used

1. **BLoC (Business Logic Component) Pattern**
    - State management using `flutter_bloc` and `hydrated_bloc`
    - Separation of business logic from UI
    - Predictable state transitions

2. **Repository Pattern**
    - Abstraction layer between data sources and business logic
    - Easily switchable data sources (API, local storage, etc.)
    - Centralized data access logic

3. **Dependency Injection**
    - Constructor-based dependency injection
    - Loose coupling between components

4. **Observer Pattern**
    - Used by BLoC for state changes
    - Reactive UI updates

## 📦 Dependencies & Their Purposes

### State Management

#### `flutter_bloc: ^9.1.1`

- **Purpose**: Core state management library implementing the BLoC pattern
- **Why**: Provides predictable state management, separation of business logic from UI, and
  excellent testing capabilities
- **Usage**: Managing application state for products, cart, and product details

#### `hydrated_bloc: ^10.1.1`

- **Purpose**: Extension of flutter_bloc that automatically persists and restores BLoC states
- **Why**: Enables cart persistence across app restarts without additional database setup
- **Usage**: Persisting cart data and product list state to local storage

### Networking

#### `dio: ^5.9.0`

- **Purpose**: Powerful HTTP client for making network requests
- **Why**: Provides interceptors, request/response transformation, error handling, and better
  performance than `http` package
- **Usage**: Making API calls to fetch products and product details

#### `retrofit: ^4.6.0`

- **Purpose**: Type-safe HTTP client generator for Dart
- **Why**: Simplifies API client creation with annotations, automatic serialization/deserialization,
  and compile-time safety
- **Usage**: Defining API endpoints with `@GET`, `@POST` annotations in `api_client.dart`

#### `connectivity_plus: ^7.0.0`

- **Purpose**: Plugin for discovering and configuring network connectivity
- **Why**: Provides real-time network status monitoring (WiFi, mobile data, offline)
- **Usage**: Detecting internet connectivity status and displaying connection banners

### UI & User Experience

#### `fluttertoast: ^8.2.1`

- **Purpose**: Toast notification library for showing brief messages
- **Why**: Non-intrusive user feedback for actions like "Added to cart", "Removed from cart"
- **Usage**: Displaying success/error messages to users

#### `loading_indicator: ^3.1.1`

- **Purpose**: Customizable loading indicators
- **Why**: Enhanced visual feedback during async operations
- **Usage**: Showing loading states during data fetching

#### `flutter_overlay_loader: ^2.0.0`

- **Purpose**: Overlay loader for showing full-screen loading indicators
- **Why**: Prevents user interaction during critical operations
- **Usage**: Displaying loading overlay during API calls

#### `keyboard_actions: ^4.2.0`

- **Purpose**: Keyboard actions bar for better input handling
- **Why**: Improves UX when dealing with text inputs and keyboards
- **Usage**: Enhanced keyboard interaction management

### Image Management

#### `cached_network_image: ^3.2.3`

- **Purpose**: Widget to display network images with caching
- **Why**: Efficiently loads and caches product images, reducing bandwidth and improving performance
- **Usage**: Displaying product images from URLs with automatic caching

#### `flutter_cache_manager: ^3.4.1`

- **Purpose**: Cache manager for Flutter that stores files on disk
- **Why**: Works with cached_network_image to manage image cache storage and eviction policies
- **Usage**: Managing cached product images on device storage

### Utilities

#### `path_provider: ^2.1.5`

- **Purpose**: Provides platform-specific paths for storing files
- **Why**: Required by hydrated_bloc to store persisted state data in temporary directory
- **Usage**: Getting file system paths for HydratedBloc storage

#### `cupertino_icons: ^1.0.8`

- **Purpose**: iOS-style icon pack
- **Why**: Provides platform-specific icons for better iOS appearance
- **Usage**: Using iOS-style icons throughout the app

### Development Dependencies

#### `flutter_lints: ^5.0.0`

- **Purpose**: Official lint rules for Dart and Flutter
- **Why**: Ensures code quality, consistency, and catches potential bugs
- **Usage**: Enforced through `analysis_options.yaml`

#### `retrofit_generator`

- **Purpose**: Code generator for Retrofit annotations
- **Why**: Automatically generates API client implementation from annotations
- **Usage**: Generating `api_client.g.dart` from `api_client.dart`

#### `build_runner`

- **Purpose**: Code generation tool for Dart
- **Why**: Runs code generators like retrofit_generator
- **Usage**: Executing code generation with `flutter pub run build_runner build`

#### `built_value_generator`

- **Purpose**: Generator for immutable value classes
- **Why**: Creates immutable, serializable data classes with less boilerplate

### Installation Steps

1. **Clone the repository**
   git clone <repository-url>
   cd advance_e_commerce_app
   ```

2. **Install dependencies**
   flutter pub get
   ```

3. **Generate code** (for Retrofit API client)
   flutter pub run build_runner build
   ```

4. **Run the application**
   flutter run
   ```
