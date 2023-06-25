import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class AppUtil {
  static Future<List<FileSystemEntity>> readBooks() async {
    var dir = await getApplicationSupportDirectory();
    final pathFile = Directory(dir.path);
    final List<FileSystemEntity> entities = await pathFile.list().toList();
    final Iterable<Directory> files = entities.whereType<Directory>();
    // files.forEach(print);
    return entities;
  }

  static Future<List<FileSystemEntity>> readFilesDir(String folderName) async {
    var dir = await getApplicationSupportDirectory();
    final pathFile = Directory('${dir.path}/$folderName');
    final List<FileSystemEntity> entities = await pathFile.list().toList();
    // final Iterable<Directory> files = entities.whereType<Directory>();
    entities.forEach(print);
    return entities;
  }

  static Future<String> createFolderInAppSupDir(String folderName) async {
    final Directory appDir = await getApplicationSupportDirectory();
    // const folderName = 'SampleBook';
    final Directory appDirFolder = Directory("${appDir.path}/$folderName/");
    if (await appDirFolder.exists()) {
      //if folder already exists return path
      return appDirFolder.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory appDocDirNewFolder =
          await appDirFolder.create(recursive: true);
      return appDocDirNewFolder.path;
    }
  }

  static Future<String> downloadPdFiles(
      String url, String filename, String bookName) async {
    var fldr = await createFolderInAppSupDir(bookName);
    if (fldr.isNotEmpty) {
      var savePath = '$fldr/$filename';
      // print(savePath);
      var dio = Dio();
      dio.interceptors.add(LogInterceptor());
      try {
        var response = await dio.get(
          url,
          //Received data with List<int>
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: const Duration(seconds: 60),
          ),
        );
        var file = File(savePath);
        var raf = file.openSync(mode: FileMode.write);
        // response.data is List<int> type
        raf.writeFromSync(response.data);
        await raf.close();
        return "success";
      } catch (e) {
        debugPrint(e.toString());
        return "failed";
      }
    }
    return "failed";
  }

  String splitPath(url) {
    File file = File(url);
    String filename = file.path.split(Platform.pathSeparator).last;
    return filename;
  }
}
