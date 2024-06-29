import 'dart:io';
import 'dart:developer' as developer;

import 'package:path_provider/path_provider.dart';

class FileService {
  final String filePath;

  FileService(this.filePath);

  factory FileService.exercises() => FileService("exercises.json");
  factory FileService.routines() => FileService("routines.json");

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    File file = File('$path/$filePath');
    return file;
  }

  Future<File> writeFile(String data) async {
    final file = await _localFile;

    return await file.writeAsString(data);
  }

  Future<String?> readFile() async {
    try {
      final file = await _localFile;

      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteFile() async {
    try {
      final file = await _localFile;

      await file.delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
