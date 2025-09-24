class AppFailure {
  final String message;
  AppFailure([this.message = 'SORRY! An Unexpteced Error Occured']);
  @override
  String toString() => 'AppFailure(message: $message)';
}
