import 'dart:io';

import 'python_result.dart';

class PythonRun {
  Future<PythonResult> call(String scriptPath, List<String> args) async {
    final result = await Process.run('python3', [scriptPath, ...args]);
    return PythonResult.fromJson(result.stdout.toString().trim());
  }
}
