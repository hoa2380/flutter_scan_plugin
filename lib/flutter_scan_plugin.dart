import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:cuervo_document_scanner/cuervo_document_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scan_plugin/painters/text_recognizer_painter.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:opencv_3/factory/pathfrom.dart';
import 'package:opencv_3/opencv_3.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

import 'flutter_scan_plugin_platform_interface.dart';
import 'package:pdf/widgets.dart' as pw;

enum Type { CAMERA, GALLERY }

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

class FlutterScanPlugin {
  static final _textRecognizer = TextRecognizer();

  static final ScreenshotController screenshotController = ScreenshotController();

  static Random _rnd = Random();

  static String _getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

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
    if (path == null) return null;
    Uint8List? _byte = await Cv2.cvtColor(
      pathFrom: CVPathFrom.GALLERY_CAMERA,
      pathString: path[0],
      outputType: Cv2.COLOR_BGR2GRAY,
    );
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/image.png').create();
    file.writeAsBytesSync(_byte!);
    List<String>? _path = [];
    _path = await _showResult(context, file.path, true);
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
    if (path == null) return null;
    Uint8List? _byte = await Cv2.cvtColor(
      pathFrom: CVPathFrom.GALLERY_CAMERA,
      pathString: path[0],
      outputType: Cv2.COLOR_BGR2GRAY,
    );
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/image.png').create();
    file.writeAsBytesSync(_byte!);
    List<String>? _path = [];
    _path = await _showResult(context, file.path, true);
    return _path;
  }

  static Future<List<String>?> _showResult(BuildContext context, String path, bool isGallery) async {
    final inputImage = InputImage.fromFile(File(path));
    var decodedImage = await decodeImageFromList(File(path).readAsBytesSync());
    final recognizedText = await _textRecognizer.processImage(inputImage);
    final file2 = File(inputImage.filePath!);
    var decodedImage2 = await decodeImageFromList(file2.readAsBytesSync());
    var widgetScreen = Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: CustomPaint(
          painter: TextRecognizerPainter(
            imageSize: isGallery
                ? Size(decodedImage.width.toDouble(), decodedImage.height.toDouble())
                : Size(decodedImage2.width.toDouble(), decodedImage2.height.toDouble()),
            recognizedText: recognizedText,
            cameraLensDirection: CameraLensDirection.back,
            rotation: InputImageRotation.rotation0deg,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          )),
    );
    Uint8List capturedImage = await screenshotController
        .captureFromWidget(InheritedTheme.captureAll(context, Material(child: widgetScreen)),
            delay: Duration(seconds: 1));
    List<String>? _path = await _screenToPdf(capturedImage);
    if(path.isNotEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Save to download folder success'),
        ),
      );
    }
    return _path;
  }

  static Future<List<String>?> _screenToPdf(Uint8List screenShot) async {
    await Permission.storage.request();
    List<String>? _path = [];
    if (await Permission.storage.isDenied) return null;
    try {
      Directory? directory;
      pw.Document pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Expanded(
              child: pw.Image(pw.MemoryImage(screenShot), fit: pw.BoxFit.contain),
            );
          },
        ),
      );
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) directory = await getExternalStorageDirectory();
      }
      File pdfFile = await File('${directory?.path}/${'file${_getRandomString(5)}'}.pdf').create();
      pdfFile.writeAsBytesSync(await pdf.save());
      _path.add(pdfFile.path);
    } catch (e) {
      print(e);
    }
    return _path;
  }
}
