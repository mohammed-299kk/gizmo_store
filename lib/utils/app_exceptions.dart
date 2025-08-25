class AppException implements Exception {
  final String message;
  final String? prefix;

  AppException([this.message = "An unknown error occurred.", this.prefix]);

  @override
  String toString() {
    return "$prefix$message";
  }
}

class FirestoreException extends AppException {
  FirestoreException([String message = "Firestore operation failed."])
      : super(message, "Firestore Error: ");
}

class NetworkException extends AppException {
  NetworkException([String message = "Network connection failed."])
      : super(message, "Network Error: ");
}

class AuthException extends AppException {
  AuthException([String message = "Authentication failed."])
      : super(message, "Auth Error: ");
}

// Add more custom exceptions as needed