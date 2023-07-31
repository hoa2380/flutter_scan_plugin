import 'package:cuervo_document_scanner/cuervo_document_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import 'flutter_scan_plugin_platform_interface.dart';
enum Type { CAMERA, GALLERY }

class FlutterScanPlugin {

  Future<String?> getPlatformVersion() {
    return FlutterScanPluginPlatform.instance.getPlatformVersion();
  }

  static Future<List<String>?> start(Type type) async {
    if (type == Type.CAMERA) {
      return _getPicturesFromCamera();
    } else {
      return _getPicturesFromGallery();
    }
  }

  static Future<List<String>?> _getPicturesFromCamera() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
    ].request();
    if (statuses.containsValue(PermissionStatus.denied)) {
      throw Exception("Permission not granted");
    }
    return CuervoDocumentScanner.getPictures(Source.CAMERA);
  }

  static Future<List<String>?> _getPicturesFromGallery() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.photos,
    ].request();
    if (statuses.containsValue(PermissionStatus.denied)) {
      throw Exception("Permission not granted");
    }

    return CuervoDocumentScanner.getPictures(Source.GALLERY);
  }
}

