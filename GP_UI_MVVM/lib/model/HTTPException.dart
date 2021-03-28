class HTTPException implements Exception {
  final String msg;

  HTTPException(this.msg);

  @override
  String toString() {
    return msg;
  }
}
