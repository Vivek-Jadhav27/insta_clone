import 'package:permission_handler/permission_handler.dart';

class PermissionsService {

   Future<Map<Permission, PermissionStatus>> requestAllPermissions() async {
    final statuses = await [
      Permission.location,
      Permission.camera,
      Permission.storage,
    ].request();
    return statuses;
  }

  /// Check if all required permissions are granted.
  Future<bool> areAllPermissionsGranted() async {
    final statuses = await requestAllPermissions();
    return statuses[Permission.location] == PermissionStatus.granted &&
           statuses[Permission.camera] == PermissionStatus.granted &&
           statuses[Permission.storage] == PermissionStatus.granted;
  }
  
  Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.request();
    return status == PermissionStatus.granted;
  }

  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.request();
    return status == PermissionStatus.granted;
  }

  Future<bool> requestCameraAndStoragePermissions() async {
    var statuses = await [
      Permission.camera,
      Permission.storage,
    ].request();
    return statuses[Permission.camera] == PermissionStatus.granted &&
           statuses[Permission.storage] == PermissionStatus.granted;
  }

  Future<bool> requestGalleryPermission() async {
    return requestStoragePermission();
  }

  Future<bool> isCameraPermissionGranted() async {
    return await Permission.camera.isGranted;
  }

  Future<bool> isStoragePermissionGranted() async {
    return await Permission.storage.isGranted;
  }
}
