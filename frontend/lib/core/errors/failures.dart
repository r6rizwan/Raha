sealed class Failure implements Exception {
  const Failure(this.message);
  final String message;
  @override
  String toString() => message;
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class RateLimitFailure extends Failure {
  const RateLimitFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}

UnknownFailure unexpectedFailure(String action) =>
    UnknownFailure('We could not $action right now. Please try again.');

String friendlyMessageForError(
  Object error, {
  String fallback = 'Something went wrong. Please try again.',
}) {
  if (error is Failure) return error.message;
  final text = error.toString().trim();
  if (text.startsWith('Exception: ')) {
    return text.substring('Exception: '.length).trim();
  }
  return text.isEmpty ? fallback : text;
}
