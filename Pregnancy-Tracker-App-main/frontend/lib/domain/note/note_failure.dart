class NoteFailure {
  const NoteFailure._();
  String get message => throw UnimplementedError();

  factory NoteFailure.serverError() = ServerError;
  factory NoteFailure.networkError() = NetworkError;
  factory NoteFailure.unauthorized() = Unauthorized;
  factory NoteFailure.notFound() = NotFound;
  factory NoteFailure.permissionDenied() = PermissionDenied;
  factory NoteFailure.forbidden() = Forbidden;
  factory NoteFailure.emptyTitleError() = EmptyTitleError;
  factory NoteFailure.emptyDescriptionError() = EmptyDescriptionError;
  factory NoteFailure.validationError(String message) = ValidationError;
  factory NoteFailure.customError(String message) = CustomError;

  @override
  String toString() {
    return "Unknown error";
  }
}

class ServerError extends NoteFailure {
  const ServerError() : super._();

  @override
  String toString() => "Server error: Something went wrong on the server side.";
}

class NetworkError extends NoteFailure {
  const NetworkError() : super._();

  @override
  String toString() => "Network error: Unable to connect to the internet.";
}

class Unauthorized extends NoteFailure {
  const Unauthorized() : super._();

  @override
  String toString() => "Unauthorized: You do not have the necessary permissions.";
}

class NotFound extends NoteFailure {
  const NotFound() : super._();

  @override
  String toString() => "Not found: The requested resource could not be found.";
}

class PermissionDenied extends NoteFailure {
  const PermissionDenied() : super._();

  @override
  String toString() => "Permission denied: You do not have the right access.";
}

class Forbidden extends NoteFailure {
  const Forbidden() : super._();

  @override
  String toString() => "Forbidden: Access is not allowed.";
}

class EmptyTitleError extends NoteFailure {
  const EmptyTitleError() : super._();

  @override
  String toString() => "Title error: The title cannot be empty.";
}

class EmptyDescriptionError extends NoteFailure {
  const EmptyDescriptionError() : super._();

  @override
  String toString() => "Description error: The description cannot be empty.";
}

class ValidationError extends NoteFailure {
  final String message;
  const ValidationError(this.message) : super._();

  @override
  String toString() => "Validation error: $message";
}

class CustomError extends NoteFailure {
  final String message;
  const CustomError(this.message) : super._();

  @override
  String toString() => "Custom error: $message";
}
