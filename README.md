# flutter_scan_plugin

A Flutter plugin scan text from image.

## Getting Started

#### Setup android
```android
 <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
 <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
 <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
```
Change minSdkVersion in android/app/build.gradle
```android
android {                                                                                     
   defaultConfig {                                                                             
     minSdkVersion 21                                                                         
   }                                                                                           
 }   
```
#### Setup ios

```podfile
 platform :ios, '13.0'
```
Add info.plist
```
<key>NSCameraUsageDescription</key>
<string>Camera Permission Description</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Gallery Permission Description</string>
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
final pathFilePdf = await FlutterScanPlugin.start(Type.CAMERA, context);
```
#### With Gallery

```dart
final pathFilePdf = await FlutterScanPlugin.start(Type.GALLERY, context);
```
## Location pathFilePdf
```dart
if (Platform.isIOS) {
  directory = await getApplicationDocumentsDirectory();
} else {
  directory = Directory('/storage/emulated/0/Download');
  if (!await directory.exists()) directory = await getExternalStorageDirectory();
}
```


