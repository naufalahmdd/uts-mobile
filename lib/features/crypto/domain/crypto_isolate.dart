import 'dart:isolate';

// Fungsi ini WAJIB berupa top-level function (di luar class)
// agar bisa dijalankan di Isolate terpisah
// Logika Anti-AI: Digit 2 terakhir NIM = 67 -> Loop 67 x 10.000.000 kali
Future<int> runHeavyCalculationInIsolate(int nimLastTwoDigits) async {
  return await Isolate.run(() => _heavyWork(nimLastTwoDigits));
}

// Fungsi berat yang berjalan di dalam Isolate (background thread)
// UI TIDAK akan freeze karena ini berjalan di thread terpisah
int _heavyWork(int nimLastTwoDigits) {
  final totalIterations = nimLastTwoDigits * 10000000; // 67 x 10.000.000
  int result = 0;
  for (int i = 0; i < totalIterations; i++) {
    result += i;
  }
  return result;
}
