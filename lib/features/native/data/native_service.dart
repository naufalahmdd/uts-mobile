import 'package:flutter/services.dart';

class NativeService {
  // Nama channel WAJIB sama persis dengan yang di Kotlin
  static const _channel = MethodChannel('com.example.uts_mobile/native');

  // Memanggil method Kotlin: getBatteryLevel
  Future<int> getBatteryLevel() async {
    try {
      final int level = await _channel.invokeMethod('getBatteryLevel');
      return level;
    } on PlatformException catch (e) {
      throw Exception('Gagal membaca baterai: ${e.message}');
    }
  }

  // Memanggil method Kotlin: showToast (Native Android Toast)
  Future<void> showNativeToast(String message) async {
    try {
      await _channel.invokeMethod('showToast', {'message': message});
    } on PlatformException catch (e) {
      throw Exception('Gagal menampilkan toast: ${e.message}');
    }
  }
}
