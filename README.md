# flutter_scan_plugin

A Flutter plugin scan text from image.

## Getting Started

#### Setup android
```android
 <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
 <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
 <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
```
#### Setup ios

```podfile
 platform :ios, '13.0'
```

#### Installing

```yaml
  flutter_scan_plugin:
    git:
      url: https://github.com/hoa2380/flutter_scan_plugin
      ref: main
```
#### With Camera

```dart
FlutterScanPlugin.start(Type.CAMERA, context);
```
#### With Gallery

```dart
FlutterScanPlugin.start(Type.GALLERY, context);
```

