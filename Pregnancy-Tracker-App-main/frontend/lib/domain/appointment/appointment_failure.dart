class AppointmentFailure {
  const AppointmentFailure._();

  factory AppointmentFailure.serverError() = ServerError;
  factory AppointmentFailure.networkError() = NetworkError;
  factory AppointmentFailure.unauthorized() = Unauthorized;
  factory AppointmentFailure.notFound() = NotFound;
  factory AppointmentFailure.permissionDenied() = PermissionDenied;
  factory AppointmentFailure.forbidden() = Forbidden;
  factory AppointmentFailure.emptyTitleError() = EmptyTitleError;
  factory AppointmentFailure.emptyDescriptionError() = EmptyDescriptionError;
  factory AppointmentFailure.emptyDateError() = EmptyDateError;
  factory AppointmentFailure.emptyTimeError() = EmptyTimeError;
  factory AppointmentFailure.validationError(String message) = ValidationError;
  factory AppointmentFailure.customError(String message) = CustomError;

  @override
  String toString() {
    return this is ValidationError || this is CustomError
        ? (this as dynamic).message
        : 'Unknown error';
  }
}

class ServerError extends AppointmentFailure {
  const ServerError() : super._();

  @override
  String toString() => 'ServerError: Server error occurred';
}

class NetworkError extends AppointmentFailure {
  const NetworkError() : super._();

  @override
  String toString() => 'NetworkError: Network error occurred';
}

class Unauthorized extends AppointmentFailure {
  const Unauthorized() : super._();

  @override
  String toString() => 'Unauthorized: Unauthorized access';
}

class NotFound extends AppointmentFailure {
  const NotFound() : super._();

  @override
  String toString() => 'NotFound: Resource not found';
}

class PermissionDenied extends AppointmentFailure {
  const PermissionDenied() : super._();

  @override
  String toString() => 'PermissionDenied: Permission denied';
}

class Forbidden extends AppointmentFailure {
  const Forbidden() : super._();

  @override
  String toString() => 'Forbidden: Forbidden access';
}

class EmptyTitleError extends AppointmentFailure {
  const EmptyTitleError() : super._();

  @override
  String toString() => 'EmptyTitleError: Title cannot be empty';
}

class EmptyDescriptionError extends AppointmentFailure {
  const EmptyDescriptionError() : super._();

  @override
  String toString() => 'EmptyDescriptionError: Description cannot be empty';
}

class EmptyDateError extends AppointmentFailure {
  const EmptyDateError() : super._();

  @override
  String toString() => 'EmptyDateError: Date cannot be empty';
}

class EmptyTimeError extends AppointmentFailure {
  const EmptyTimeError() : super._();

  @override
  String toString() => 'EmptyTimeError: Time cannot be empty';
}

class ValidationError extends AppointmentFailure {
  final String message;

  const ValidationError(this.message) : super._();

  @override
  String toString() => 'ValidationError: $message';
}

class CustomError extends AppointmentFailure {
  final String message;

  const CustomError(this.message) : super._();

  @override
  String toString() => 'CustomError: $message';
}
