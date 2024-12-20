/// The operation was not allowed by the temporal.
class UnsupportedTemporalTypeError extends Error implements UnsupportedError {
  final String? message;

  /// Constructs a new [UnsupportedTemporalTypeError].
  UnsupportedTemporalTypeError([this.message]);

  @override
  String toString() {
    var message = this.message;
    return (message != null)
        ? "UnsupportedTemporalTypeError: $message"
        : "UnsupportedTemporalTypeError";
  }
}
