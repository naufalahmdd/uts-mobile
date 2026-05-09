class SplashService {
  Future<void> executeDelay() async {
    // Logika Personal Anti-AI: Delay persis 7 detik (Digit terakhir NIM: 20123067)
    // Delay dilakukan di level Service/Domain sesuai spesifikasi.
    await Future.delayed(const Duration(seconds: 7));
  }
}
