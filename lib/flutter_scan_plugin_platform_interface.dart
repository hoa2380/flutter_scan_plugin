import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_scan_plugin_method_channel.dart';

abstract class FlutterScanPluginPlatform extends PlatformInterface {
  /// Constructs a FlutterScanPluginPlatform.
  FlutterScanPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterScanPluginPlatform _instance = MethodChannelFlutterScanPlugin();

  /// The default instance of [FlutterScanPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterScanPlugin].
  static FlutterScanPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterScanPluginPlatform] when
  /// they register themselves.
  static set instance(FlutterScanPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
