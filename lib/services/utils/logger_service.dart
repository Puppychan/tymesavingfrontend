import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LoggerService {
  static Future<File> _getLogFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/app_logs.txt');
  }

  static Future<void> writeLog(String log) async {
    final file = await _getLogFile();
    await file.writeAsString('$log\n', mode: FileMode.append);
  }

  static Future<String> readLogs() async {
    try {
      final file = await _getLogFile();
      return await file.readAsString();
    } catch (e) {
      return 'Error reading logs: $e';
    }
  }
}
