abstract class APIError {}

class InvalidKey implements Exception, APIError {
  final String message;

  InvalidKey(this.message);

  @override
  String toString() {
    return "InvalidKey: $message";
  }
}

class NoInternet implements Exception, APIError {
  final String message;

  NoInternet(this.message);

  @override
  String toString() {
    return "NoInternet: $message";
  }
}

class FoodNotFound implements Exception, APIError {
  final String message;

  FoodNotFound(this.message);

  @override
  String toString() {
    return "FoodNotFound: $message";
  }
}
