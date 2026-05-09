import 'package:flutter/material.dart';
import '../data/native_service.dart';

class NativePage extends StatefulWidget {
  const NativePage({super.key});

  @override
  State<NativePage> createState() => _NativePageState();
}

class _NativePageState extends State<NativePage> {
  final NativeService _nativeService = NativeService();
  int? _batteryLevel;
  bool _isLoadingBattery = false;
  String? _errorMessage;

  Future<void> _getBattery() async {
    setState(() {
      _isLoadingBattery = true;
      _errorMessage = null;
    });
    try {
      final level = await _nativeService.getBatteryLevel();
      if (mounted) {
        setState(() {
          _batteryLevel = level;
          _isLoadingBattery = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoadingBattery = false;
        });
      }
    }
  }

  Future<void> _showToast() async {
    try {
      await _nativeService.showNativeToast(
        'Halo dari Flutter! Baterai: ${_batteryLevel != null ? "$_batteryLevel%" : "belum dibaca"}',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Color _getBatteryColor(int level) {
    if (level >= 60) return Colors.green;
    if (level >= 30) return Colors.orange;
    return Colors.red;
  }

  IconData _getBatteryIcon(int level) {
    if (level >= 90) return Icons.battery_full;
    if (level >= 60) return Icons.battery_5_bar;
    if (level >= 40) return Icons.battery_3_bar;
    if (level >= 20) return Icons.battery_2_bar;
    return Icons.battery_1_bar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Native Integration'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // -- KARTU INFO BATERAI --
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      _batteryLevel != null
                          ? _getBatteryIcon(_batteryLevel!)
                          : Icons.battery_unknown,
                      size: 80,
                      color: _batteryLevel != null
                          ? _getBatteryColor(_batteryLevel!)
                          : Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Sisa Baterai HP',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    if (_batteryLevel != null) ...[
                      Text(
                        '$_batteryLevel%',
                        style: TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: _getBatteryColor(_batteryLevel!),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: _batteryLevel! / 100,
                          minHeight: 12,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getBatteryColor(_batteryLevel!),
                          ),
                        ),
                      ),
                    ] else if (_errorMessage != null) ...[
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ] else ...[
                      const Text(
                        'Tekan tombol di bawah untuk membaca baterai',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: _isLoadingBattery
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2),
                              )
                            : const Icon(Icons.battery_charging_full),
                        label: Text(_isLoadingBattery
                            ? 'Membaca...'
                            : 'Baca Level Baterai'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _isLoadingBattery ? null : _getBattery,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // -- KARTU NATIVE TOAST --
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(Icons.notifications_active,
                        size: 60, color: Colors.orange),
                    const SizedBox(height: 12),
                    const Text(
                      'Native Toast Android',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Memunculkan pesan Toast langsung dari kode Kotlin via MethodChannel',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.send),
                        label: const Text('Tampilkan Native Toast'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _showToast,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Pesan toast berasal dari Kotlin, bukan Flutter widget',
                      style:
                          TextStyle(fontSize: 11, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Penjelasan teknis
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ℹ️ Cara Kerja Platform Channel:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(
                    '1. Flutter memanggil MethodChannel("com.example.uts_mobile/native")\n'
                    '2. Kotlin di MainActivity.kt menerima panggilan\n'
                    '3. Kotlin membaca BatteryManager / menampilkan Toast\n'
                    '4. Hasilnya dikembalikan ke Flutter',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
