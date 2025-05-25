# Flutter State Management Examples

This project demonstrates different state management approaches in Flutter, focusing on:

1. **setState** - The simplest form of state management
2. **BLoC Pattern** - Business Logic Component pattern for more complex state management

## Examples Included

### 1. setState Counter Example

A basic counter implementation using Flutter's built-in `setState` method. This approach is suitable for:
- Simple widgets with minimal state
- Small applications
- Prototyping

**Key Concepts:**
- State is managed within a StatefulWidget
- UI is rebuilt when setState is called
- Simple to implement but doesn't scale well for complex applications

### 2. BLoC Counter Example

The same counter functionality implemented using the BLoC pattern. This demonstrates:
- Separation of UI and business logic
- Unidirectional data flow
- Event-driven architecture

**Key Concepts:**
- Events trigger state changes
- State is emitted from the BLoC
- UI rebuilds in response to state changes
- Better testability and maintainability

### 3. BLoC API Example

A more complex example showing how to use BLoC for API calls, fetching posts from JSONPlaceholder API. This demonstrates:
- Handling asynchronous operations
- Loading, success, and error states
- Repository pattern for data access

**Key Concepts:**
- Using BLoC for network requests
- Handling different states (loading, success, error)
- Separating data layer (repository) from business logic (BLoC)

## BLoC Pattern Explained

The BLoC (Business Logic Component) pattern is a state management solution that helps separate business logic from UI. It consists of three main components:

1. **Events**: Actions that trigger state changes (user interactions, API responses, etc.)
2. **BLoC**: Processes events and converts them into states
3. **States**: Representations of the UI at a given moment

### Advantages of BLoC

- **Separation of Concerns**: UI is separated from business logic
- **Testability**: Business logic can be tested independently
- **Reusability**: BLoCs can be reused across different widgets
- **Maintainability**: Easier to maintain and debug complex applications

### When to Use BLoC

BLoC is particularly useful for:
- Medium to large applications
- Applications with complex business logic
- Applications requiring real-time updates
- Teams working on the same codebase

## Getting Started

To run this project:

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the application

## Dependencies

- flutter_bloc: For implementing the BLoC pattern
- equatable: For comparing objects
- http: For making API requests
