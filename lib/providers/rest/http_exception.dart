class RestApiException implements Exception {
  final String message;
  final int errorCode;

  RestApiException(this.message, this.errorCode);

  String toString() {
    return 'RestAPIException: $message. Error code: $errorCode';
  }
}
