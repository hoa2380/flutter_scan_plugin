import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_scan_plugin/flutter_scan_plugin.dart';
import 'package:flutter_scan_plugin/flutter_scan_plugin_platform_interface.dart';
import 'package:flutter_scan_plugin/flutter_scan_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterScanPluginPlatform
    with MockPlatformInterfaceMixin
    implements FlutterScanPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterScanPluginPlatform initialPlatform = FlutterScanPluginPlatform.instance;

  test('$MethodChannelFlutterScanPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterScanPlugin>());
  });

  test('getPlatformVersion', () async {
    FlutterScanPlugin flutterScanPlugin = FlutterScanPlugin();
    MockFlutterScanPluginPlatform fakePlatform = MockFlutterScanPluginPlatform();
    FlutterScanPluginPlatform.instance = fakePlatform;
  });
}
