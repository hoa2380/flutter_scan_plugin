import 'dart:io';
import 'dart:typed_data';

import 'package:cuervo_document_scanner/cuervo_document_scanner.dart';
import 'package:flutter/material.dart';
import 'package:opencv_3/factory/pathfrom.dart';
import 'package:opencv_3/opencv_3.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'flutter_scan_plugin_platform_interface.dart';
enum Type { CAMERA, GALLERY }

class FlutterScanPlugin {

  Future<String?> getPlatformVersion() {
    return FlutterScanPluginPlatform.instance.getPlatformVersion();
  }

  static Future<List<String>?> start(Type type, BuildContext context) async {
    if (type == Type.CAMERA) {
      return _getPicturesFromCamera(context);
    } else {
      return _getPicturesFromGallery(context);
    }
  }

  static Future<List<String>?> _getPicturesFromCamera(BuildContext context) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
    ].request();
    if (statuses.containsValue(PermissionStatus.denied)) {
      throw Exception("Permission not granted");
    }
    List<String>? path = await CuervoDocumentScanner.getPictures(Source.CAMERA);
    if(path == null) return null;
    Uint8List? _byte = await Cv2.cvtColor(
      pathFrom: CVPathFrom.GALLERY_CAMERA,
      pathString: path[0],
      outputType: Cv2.COLOR_BGR2GRAY,
    );
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/image.png').create();
    file.writeAsBytesSync(_byte!);
    List<String>?  _path = [];
    _path.add(file.path);
    _showDialogResult(context, file.path);
    return _path;
  }

  static Future<List<String>?> _getPicturesFromGallery(BuildContext context) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.photos,
    ].request();
    if (statuses.containsValue(PermissionStatus.denied)) {
      throw Exception("Permission not granted");
    }

    List<String>? path = await CuervoDocumentScanner.getPictures(Source.GALLERY);
    if(path == null) return null;
    Uint8List? _byte = await Cv2.cvtColor(
      pathFrom: CVPathFrom.GALLERY_CAMERA,
      pathString: path[0],
      outputType: Cv2.COLOR_BGR2GRAY,
    );
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/image.png').create();
    file.writeAsBytesSync(_byte!);
    List<String>?  _path = [];
    _path.add(file.path);
    _showDialogResult(context, file.path);
    return _path;
  }

  static Future<void> _showDialogResult(BuildContext context, String path) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Result'),
        content: Text('Result'),
        actions: [
          Container(
            child: Image.file(File(path)),
          )
        ],
      ),
    );
  }
}

