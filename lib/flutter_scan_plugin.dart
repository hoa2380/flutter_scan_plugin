import 'package:cuervo_document_scanner/cuervo_document_scanner.dart';

import 'flutter_scan_plugin_platform_interface.dart';
enum Type { CAMERA, GALLERY }

class FlutterScanPlugin {

  Future<String?> getPlatformVersion() {
    return FlutterScanPluginPlatform.instance.getPlatformVersion();
  }

  static Future<List<String>?> start(Type type) async {
    if (type == Type.CAMERA) {
      return CuervoDocumentScanner.getPictures(Source.CAMERA);
    } else {
      return CuervoDocumentScanner.getPictures(Source.GALLERY);
    }
  }
}

