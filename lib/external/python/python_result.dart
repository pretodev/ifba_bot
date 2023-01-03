import 'dart:convert';

enum PythonResultStatus {
  success,
  error,
}

class PythonResult {
  final dynamic data;
  final PythonResultStatus status;
  final String code;

  PythonResult({
    required this.data,
    required this.status,
    required this.code,
  });

  @override
  String toString() =>
      'PythonResult(data: $data, status: $status, code: $code)';

  bool get isSuccess => status == PythonResultStatus.success;

  bool get isError => status == PythonResultStatus.error;

  factory PythonResult.fromJson(String json) {
    final data = jsonDecode(json);
    return PythonResult(
      data: data['data'],
      status: data['status'] == 'success'
          ? PythonResultStatus.success
          : PythonResultStatus.error,
      code: data['code'],
    );
  }
}
