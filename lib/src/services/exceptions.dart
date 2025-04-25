class InvalidURLException implements Exception {
  String message = 'Invalid URL provided. Use only url string or URI object.';
}

class InvalidRequestMethodException implements Exception {
  String message =
      'Invalid request method. Use only GET, POST, PUT, PATCH and DELETE.';
}

class InvalidResponseException implements Exception {
  String message = 'Invalid json response.';
}

class NetworkErrorException implements Exception {
  String message = 'Network request could not be completed successfully.';
  int code = 0;

  NetworkErrorException(code) {
    this.code = code;
  }
}

class ServerErrorException implements Exception {
  String message = '';
  int code = 0;

  ServerErrorException(code, message) {
    this.code = code;
    this.message = message;
  }
}

class UnauthorizedRequestException implements Exception {
  String message = 'Request is not authorized.';
}

// Custom exceptions
class UserCanceledSignInException implements Exception {
  String message = 'User canceled the Google Sign-In process.';
}

class TokenNotFoundException implements Exception {
  String message = 'Token not found in the redirect URL.';
}

class WebAuthException implements Exception {
  String message;
  WebAuthException([this.message = 'An error occurred during authentication.']);
}
