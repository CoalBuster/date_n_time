class UnsupportedTemporalTypeError extends Error implements UnsupportedError {
  final String? message;

  UnsupportedTemporalTypeError([this.message]);

  @override
  String toString() {
    var message = this.message;
    return (message != null)
        ? "UnsupportedTemporalTypeError: $message"
        : "UnsupportedTemporalTypeError";
  }
}
